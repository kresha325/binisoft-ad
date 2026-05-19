const GENERIC_ORDER_LABELS = new Set([
  'porosit tani',
  'shiko produktet',
  'porosit online',
  'order now',
  'view products',
]);

const FOOD_ORDER = new Set([
  'restaurant',
  'pizzeria',
  'cafe',
  'fastFood',
  'bar',
  'catering',
  'iceCream',
  'pastry',
]);
const RETAIL_ORDER = new Set([
  'retail',
  'fashion',
  'electronics',
  'grocery',
  'convenienceStore',
  'bakery',
  'wholesale',
  'butcher',
  'flowerShop',
  'jewelry',
  'bookstore',
  'pharmacy',
  'agriculture',
  'petShop',
]);
const APPOINTMENT = new Set([
  'services',
  'salon',
  'spa',
  'clinic',
  'dental',
  'veterinary',
  'fitness',
  'education',
  'automotive',
]);

function category(type) {
  if (!type) return 'contactLead';
  if (FOOD_ORDER.has(type)) return 'foodOrder';
  if (RETAIL_ORDER.has(type)) return 'retailOrder';
  if (APPOINTMENT.has(type)) return 'appointment';
  return 'contactLead';
}

function heroPreset(type) {
  const cat = category(type);
  if (cat === 'foodOrder') {
    return {
      primaryLabel: 'Porosit tani',
      primaryTarget: 'products',
      secondaryLabel: 'Shërbimet',
      secondaryTarget: 'services',
      trustBullets: ['Porosi online', 'Menu & oferta', 'Kontakt i shpejtë'],
    };
  }
  if (cat === 'retailOrder') {
    return {
      primaryLabel: 'Shiko produktet',
      primaryTarget: 'products',
      secondaryLabel: 'Ofertat',
      secondaryTarget: 'offers',
      trustBullets: ['Produkte të zgjedhura', 'Porosi online', 'Çmime transparente'],
    };
  }
  if (cat === 'appointment') {
    return {
      primaryLabel: 'Rezervo termin',
      primaryTarget: 'whatsapp',
      secondaryLabel: 'Shërbimet',
      secondaryTarget: 'services',
      trustBullets:
        type === 'clinic'
          ? ['Termine & konsultime', 'Na kontaktoni', 'Lokacion i qartë']
          : ['Rezervim i lehtë', 'Na kontaktoni', 'Orar i përshtatshëm'],
    };
  }
  return {
    primaryLabel: type === 'hotel' ? 'Rezervo qëndrimin' : 'Na kontaktoni',
    primaryTarget: 'contact',
    secondaryLabel: 'Shërbimet',
    secondaryTarget: 'services',
    trustBullets: ['Përgjigje e shpejtë', 'Eksperiencë profesionale', 'Na vizitoni'],
  };
}

function contactLabel(type) {
  const cat = category(type);
  if (cat === 'appointment' || cat === 'contactLead') return 'Na kontaktoni';
  if (cat === 'foodOrder') return 'Porosit në WhatsApp';
  return 'Na shkruani në WhatsApp';
}

function isGenericOrderLabel(label) {
  const n = String(label || '')
    .trim()
    .toLowerCase();
  return n && GENERIC_ORDER_LABELS.has(n);
}

function allowsOrderCopy(type) {
  const cat = category(type);
  return cat === 'foodOrder' || cat === 'retailOrder';
}

function enrichSections(sections, businessType) {
  const preset = heroPreset(businessType);
  const contact = contactLabel(businessType);
  const allowOrder = allowsOrderCopy(businessType);

  return sections.map((s) => {
    if (s.id === 'hero') {
      const out = { ...s };
      let label = out.ctaLabel;
      if (!label) label = preset.primaryLabel;
      else if (!allowOrder && isGenericOrderLabel(label)) label = preset.primaryLabel;
      out.ctaLabel = label;
      if (!out.ctaTarget) out.ctaTarget = preset.primaryTarget;
      if (!out.secondaryCtaLabel) out.secondaryCtaLabel = preset.secondaryLabel;
      if (!out.secondaryCtaTarget) out.secondaryCtaTarget = preset.secondaryTarget;
      if (!out.trustBullets || !out.trustBullets.length) {
        out.trustBullets = preset.trustBullets;
      }
      return out;
    }
    if (s.id === 'contact') {
      const out = { ...s };
      if (!out.ctaLabel) out.ctaLabel = contact;
      return out;
    }
    return s;
  });
}

module.exports = {
  heroPreset,
  contactLabel,
  enrichSections,
  isGenericOrderLabel,
  allowsOrderCopy,
};
