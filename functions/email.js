const DASHBOARD_JOIN_URL = 'https://kresha325.github.io/binisoft-ad/app/#/join';
const DASHBOARD_URL = 'https://kresha325.github.io/binisoft-ad/app/#/login';

/** Email disabled — use invite codes in the app instead. */
const EMAIL_DISABLED = true;

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

async function deliverEmail() {
  return { channel: 'disabled', skipped: true };
}

function buildTeamInviteEmail() {
  return { subject: '', html: '' };
}

async function sendTeamInviteEmail() {
  return { channel: 'disabled', skipped: true };
}

module.exports = {
  DASHBOARD_JOIN_URL,
  DASHBOARD_URL,
  EMAIL_DISABLED,
  escapeHtml,
  deliverEmail,
  buildTeamInviteEmail,
  sendTeamInviteEmail,
};
