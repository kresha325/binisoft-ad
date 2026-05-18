const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const pricing = require('../pricing');

describe('isOfferActive', () => {
  it('returns false when active is false', () => {
    const now = Date.now();
    assert.equal(
      pricing.isOfferActive({
        active: false,
        startsAt: { toMillis: () => now - 1000 },
        endsAt: { toMillis: () => now + 1000 },
      }),
      false,
    );
  });

  it('returns true inside the window', () => {
    const now = Date.now();
    assert.equal(
      pricing.isOfferActive({
        active: true,
        startsAt: { toMillis: () => now - 1000 },
        endsAt: { toMillis: () => now + 1000 },
      }),
      true,
    );
  });
});

describe('resolveOfferItemDisplay', () => {
  it('applies percent discount vs base price', () => {
    const result = pricing.resolveOfferItemDisplay(
      { basePrice: 10 },
      { productId: 'p1', discountPercent: 20 },
      {},
    );
    assert.equal(result.hasDiscount, true);
    assert.equal(result.salePrice, 8);
    assert.equal(result.originalPrice, 10);
  });

  it('returns no discount when sale price equals base', () => {
    const result = pricing.resolveOfferItemDisplay(
      { basePrice: 12.5 },
      { productId: 'p1', salePriceEur: 12.5 },
      {},
    );
    assert.equal(result.hasDiscount, false);
  });
});

describe('resolveVariantPricing', () => {
  it('applies offer percent to variant base price', () => {
    const now = Date.now();
    const offers = [
      {
        id: 'o1',
        active: true,
        productIds: ['p1'],
        startsAt: { toMillis: () => now - 1000 },
        endsAt: { toMillis: () => now + 1000 },
        discountPercent: 50,
      },
    ];
    const result = pricing.resolveVariantPricing(20, 'p1', offers);
    assert.equal(result.unitPrice, 10);
    assert.equal(result.onOffer, true);
  });
});

describe('resolveProductPricing', () => {
  it('keeps product active in catalog with onOffer pricing', () => {
    const now = Date.now();
    const offers = [
      {
        id: 'o1',
        active: true,
        productIds: ['p1'],
        items: [{ productId: 'p1', discountPercent: 10 }],
        startsAt: { toMillis: () => now - 1000 },
        endsAt: { toMillis: () => now + 60_000 },
      },
    ];
    const result = pricing.resolveProductPricing({ basePrice: 20 }, 'p1', offers);
    assert.equal(result.onOffer, true);
    assert.equal(result.unitPrice, 18);
    assert.equal(result.originalPrice, 20);
  });
});
