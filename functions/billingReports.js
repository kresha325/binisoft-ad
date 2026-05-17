const { onSchedule } = require('firebase-functions/v2/scheduler');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');

const db = getFirestore();
const TZ = 'Europe/Belgrade';

function dateKey(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}

function isoWeekKey(d) {
  const thursday = new Date(d);
  thursday.setDate(d.getDate() + 4 - ((d.getDay() + 6) % 7));
  const yearStart = new Date(thursday.getFullYear(), 0, 1);
  const week = Math.ceil(((thursday - yearStart) / 86400000 + 1) / 7);
  return `${thursday.getFullYear()}-W${String(week).padStart(2, '0')}`;
}

function periodKey(period, anchor) {
  switch (period) {
    case 'daily':
      return dateKey(anchor);
    case 'weekly':
      return isoWeekKey(anchor);
    case 'monthly':
      return `${anchor.getFullYear()}-${String(anchor.getMonth() + 1).padStart(2, '0')}`;
    case 'yearly':
      return `${anchor.getFullYear()}`;
    default:
      return dateKey(anchor);
  }
}

function bounds(period, anchor) {
  switch (period) {
    case 'daily': {
      const start = new Date(anchor.getFullYear(), anchor.getMonth(), anchor.getDate());
      const end = new Date(anchor.getFullYear(), anchor.getMonth(), anchor.getDate(), 23, 59, 59, 999);
      return { start, end };
    }
    case 'weekly': {
      const weekday = anchor.getDay() === 0 ? 7 : anchor.getDay();
      const monday = new Date(anchor);
      monday.setDate(anchor.getDate() - (weekday - 1));
      const start = new Date(monday.getFullYear(), monday.getMonth(), monday.getDate());
      const end = new Date(start);
      end.setDate(start.getDate() + 6);
      end.setHours(23, 59, 59, 999);
      return { start, end };
    }
    case 'monthly': {
      const start = new Date(anchor.getFullYear(), anchor.getMonth(), 1);
      const lastDay = new Date(anchor.getFullYear(), anchor.getMonth() + 1, 0).getDate();
      const end = new Date(anchor.getFullYear(), anchor.getMonth(), lastDay, 23, 59, 59, 999);
      return { start, end };
    }
    case 'yearly': {
      const start = new Date(anchor.getFullYear(), 0, 1);
      const end = new Date(anchor.getFullYear(), 11, 31, 23, 59, 59, 999);
      return { start, end };
    }
    default:
      return bounds('daily', anchor);
  }
}

function previousAnchor(period, now) {
  switch (period) {
    case 'daily': {
      const y = new Date(now);
      y.setDate(now.getDate() - 1);
      return new Date(y.getFullYear(), y.getMonth(), y.getDate());
    }
    case 'weekly': {
      const w = new Date(now);
      w.setDate(now.getDate() - 7);
      return w;
    }
    case 'monthly':
      return new Date(now.getFullYear(), now.getMonth() - 1, 1);
    case 'yearly':
      return new Date(now.getFullYear() - 1, 6, 1);
    default:
      return now;
  }
}

async function generateReport(period, anchor) {
  const key = periodKey(period, anchor);
  const { start, end } = bounds(period, anchor);
  const snap = await db
    .collectionGroup('invoices')
    .where('paidAt', '>=', Timestamp.fromDate(start))
    .where('paidAt', '<=', Timestamp.fromDate(end))
    .get();

  let subscriptionTotal = 0;
  let monthlyTotal = 0;
  const invoices = [];

  snap.forEach((doc) => {
    const d = doc.data();
    const amount = Number(d.amountEur) || 0;
    if (d.type === 'monthly') monthlyTotal += amount;
    else subscriptionTotal += amount;
    invoices.push({
      invoiceNumber: d.invoiceNumber || '',
      userEmail: d.userEmail || '',
      type: d.type || 'subscription',
      amountEur: amount,
      paidAt: d.paidAt || Timestamp.now(),
    });
  });

  const id = `${period}_${key}`;
  await db.collection('billing_reports').doc(id).set(
    {
      periodType: period,
      periodKey: key,
      periodStart: Timestamp.fromDate(start),
      periodEnd: Timestamp.fromDate(end),
      invoiceCount: invoices.length,
      totalEur: subscriptionTotal + monthlyTotal,
      subscriptionTotalEur: subscriptionTotal,
      monthlyTotalEur: monthlyTotal,
      invoices,
      generatedAt: Timestamp.now(),
    },
    { merge: true },
  );
}

async function runScheduled(period) {
  const now = new Date();
  const anchor = previousAnchor(period, now);
  await generateReport(period, anchor);
  // Refresh current partial period.
  await generateReport(period, now);
}

const scheduleOpts = { timeZone: TZ, region: 'us-central1' };

exports.billingReportDaily = onSchedule(
  { schedule: '0 1 * * *', ...scheduleOpts },
  () => runScheduled('daily'),
);

exports.billingReportWeekly = onSchedule(
  { schedule: '0 2 * * 1', ...scheduleOpts },
  () => runScheduled('weekly'),
);

exports.billingReportMonthly = onSchedule(
  { schedule: '0 3 1 * *', ...scheduleOpts },
  () => runScheduled('monthly'),
);

exports.billingReportYearly = onSchedule(
  { schedule: '0 4 1 1 *', ...scheduleOpts },
  () => runScheduled('yearly'),
);

async function refreshReportsForDate(paidAt) {
  const anchor = new Date(paidAt.getFullYear(), paidAt.getMonth(), paidAt.getDate());
  await Promise.all([
    generateReport('daily', anchor),
    generateReport('weekly', anchor),
    generateReport('monthly', anchor),
    generateReport('yearly', anchor),
  ]);
}

exports.onInvoiceCreatedRefreshReports = onDocumentCreated(
  { document: 'users/{userId}/invoices/{invoiceId}', region: 'us-central1' },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const paidAt = data.paidAt?.toDate?.() || new Date();
    await refreshReportsForDate(paidAt);
  },
);

module.exports.generateReport = generateReport;
module.exports.refreshReportsForDate = refreshReportsForDate;
