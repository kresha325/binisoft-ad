import '../../business/domain/entities/business_type.dart';

/// Suggested product category for a [BusinessType] (pick when creating a category).
class CategoryTemplateSuggestion {
  const CategoryTemplateSuggestion({
    required this.slug,
    required this.names,
    this.descriptions = const {},
  });

  final String slug;
  final Map<String, String> names;
  final Map<String, String> descriptions;

  String nameFor(String locale) =>
      names[locale] ?? names['en'] ?? names['sq'] ?? names.values.first;

  String? descriptionFor(String locale) {
    final d = descriptions[locale] ?? descriptions['en'] ?? descriptions['sq'];
    return d != null && d.isNotEmpty ? d : null;
  }
}

/// Predefined category lists per business type (sq / en / de).
abstract final class BusinessCategoryTemplates {
  BusinessCategoryTemplates._();

  static List<CategoryTemplateSuggestion> forType(BusinessType? type) {
    if (type == null) return _generic;
    return _map[type] ?? _generic;
  }

  static CategoryTemplateSuggestion _t(
    String slug,
    String sq,
    String en,
    String de, {
    String? descSq,
    String? descEn,
    String? descDe,
  }) {
    return CategoryTemplateSuggestion(
      slug: slug,
      names: {'sq': sq, 'en': en, 'de': de},
      descriptions: {
        if (descSq != null) 'sq': descSq,
        if (descEn != null) 'en': descEn,
        if (descDe != null) 'de': descDe,
      },
    );
  }

  static final _generic = [
    _t('featured', 'Të zgjedhura', 'Featured', 'Empfohlen'),
    _t('new-arrivals', 'Të reja', 'New arrivals', 'Neuheiten'),
    _t('sale', 'Zbritje', 'Sale', 'Angebote'),
    _t('bestsellers', 'Më të shiturat', 'Bestsellers', 'Bestseller'),
  ];

  static final _map = <BusinessType, List<CategoryTemplateSuggestion>>{
    BusinessType.retail: [
      _t('new-arrivals', 'Të reja', 'New arrivals', 'Neuheiten'),
      _t('bestsellers', 'Më të shiturat', 'Bestsellers', 'Bestseller'),
      _t('sale', 'Zbritje', 'Sale', 'Angebote'),
      _t('accessories', 'Aksesorë', 'Accessories', 'Zubehör'),
      _t('home', 'Shtëpi', 'Home', 'Haushalt'),
      _t('seasonal', 'Sezonale', 'Seasonal', 'Saisonal'),
    ],
    BusinessType.fashion: [
      _t('women', 'Femra', 'Women', 'Damen'),
      _t('men', 'Meshkuj', 'Men', 'Herren'),
      _t('kids', 'Fëmijë', 'Kids', 'Kinder'),
      _t('shoes', 'Këpucë', 'Shoes', 'Schuhe'),
      _t('accessories', 'Aksesorë', 'Accessories', 'Accessoires'),
      _t('sale', 'Zbritje', 'Sale', 'Sale'),
    ],
    BusinessType.electronics: [
      _t('phones', 'Telefona', 'Phones', 'Smartphones'),
      _t('computers', 'Kompjuterë', 'Computers', 'Computer'),
      _t('accessories', 'Aksesorë', 'Accessories', 'Zubehör'),
      _t('smart-home', 'Shtëpi inteligjente', 'Smart home', 'Smart Home'),
      _t('gaming', 'Gaming', 'Gaming', 'Gaming'),
      _t('sale', 'Zbritje', 'Sale', 'Angebote'),
    ],
    BusinessType.it: [
      _t('software', 'Softuer', 'Software', 'Software'),
      _t('hardware', 'Harduer', 'Hardware', 'Hardware'),
      _t('support', 'Suport IT', 'IT support', 'IT-Support'),
      _t('cloud', 'Cloud', 'Cloud', 'Cloud'),
      _t('consulting', 'Konsulencë IT', 'IT consulting', 'IT-Beratung'),
      _t('networking', 'Rrjete', 'Networking', 'Netzwerke'),
    ],
    BusinessType.digitalAgency: [
      _t('web', 'Faqe web', 'Websites', 'Webseiten'),
      _t('seo', 'SEO', 'SEO', 'SEO'),
      _t('social', 'Social media', 'Social media', 'Social Media'),
      _t('ads', 'Reklama', 'Ads', 'Werbung'),
      _t('branding', 'Branding', 'Branding', 'Branding'),
    ],
    BusinessType.construction: [
      _t('materials', 'Materiale', 'Materials', 'Materialien'),
      _t('tools', 'Vegla', 'Tools', 'Werkzeuge'),
      _t('finishing', 'Përfundim', 'Finishing', 'Ausbau'),
      _t('electrical', 'Elektrik', 'Electrical', 'Elektrik'),
      _t('plumbing', 'Hidraulik', 'Plumbing', 'Sanitär'),
    ],
    BusinessType.realEstate: [
      _t('sale', 'Shitje', 'For sale', 'Verkauf'),
      _t('rent', 'Qira', 'For rent', 'Miete'),
      _t('commercial', 'Komerciale', 'Commercial', 'Gewerbe'),
      _t('land', 'Tokë', 'Land', 'Grundstück'),
    ],
    BusinessType.photography: [
      _t('wedding', 'Dasma', 'Wedding', 'Hochzeit'),
      _t('portrait', 'Portret', 'Portrait', 'Porträt'),
      _t('events', 'Evente', 'Events', 'Events'),
      _t('products', 'Produkte', 'Product', 'Produkt'),
    ],
    BusinessType.events: [
      _t('wedding', 'Dasma', 'Wedding', 'Hochzeit'),
      _t('corporate', 'Korporative', 'Corporate', 'Firmen'),
      _t('catering', 'Catering', 'Catering', 'Catering'),
      _t('decoration', 'Dekor', 'Decoration', 'Dekoration'),
    ],
    BusinessType.logistics: [
      _t('local', 'Lokal', 'Local delivery', 'Lokal'),
      _t('national', 'Nacional', 'National', 'National'),
      _t('international', 'Internacional', 'International', 'International'),
      _t('freight', 'Mallra', 'Freight', 'Fracht'),
    ],
    BusinessType.agriculture: [
      _t('produce', 'Produkte', 'Produce', 'Erzeugnisse'),
      _t('dairy', 'Qumështorja', 'Dairy', 'Milch'),
      _t('livestock', 'Blegtori', 'Livestock', 'Vieh'),
      _t('equipment', 'Pajisje', 'Equipment', 'Geräte'),
    ],
    BusinessType.grocery: [
      _t('fresh-produce', 'Fruta & perime', 'Fresh produce', 'Obst & Gemüse'),
      _t('dairy', 'Qumështorja', 'Dairy', 'Milchprodukte'),
      _t('meat', 'Mish', 'Meat', 'Fleisch'),
      _t('bakery', 'Furrë', 'Bakery', 'Bäckerei'),
      _t('beverages', 'Pije', 'Beverages', 'Getränke'),
      _t('household', 'Shtëpiakë', 'Household', 'Haushalt'),
    ],
    BusinessType.bakery: [
      _t('bread', 'Bukë', 'Bread', 'Brot'),
      _t('pastries', 'Ëmbëlsira', 'Pastries', 'Gebäck'),
      _t('cakes', 'Torta', 'Cakes', 'Kuchen'),
      _t('sandwiches', 'Sanduiçe', 'Sandwiches', 'Sandwiches'),
      _t('beverages', 'Pije', 'Beverages', 'Getränke'),
    ],
    BusinessType.wholesale: [
      _t('bulk', 'Shumicë', 'Bulk', 'Großpackungen'),
      _t('packaging', 'Paketim', 'Packaging', 'Verpackung'),
      _t('office', 'Zyrë', 'Office', 'Büro'),
      _t('industrial', 'Industri', 'Industrial', 'Industrie'),
    ],
    BusinessType.restaurant: [
      _t('appetizers', 'Paragjella', 'Appetizers', 'Vorspeisen'),
      _t('main-courses', 'Pjata kryesore', 'Main courses', 'Hauptgerichte'),
      _t('desserts', 'Ëmbëlsira', 'Desserts', 'Desserts'),
      _t('beverages', 'Pije', 'Beverages', 'Getränke'),
      _t('lunch', 'Drekë', 'Lunch menu', 'Mittagsmenü'),
      _t('dinner', 'Darkë', 'Dinner menu', 'Abendmenü'),
    ],
    BusinessType.pizzeria: [
      _t('pizza-classic', 'Pizza klasike', 'Classic pizza', 'Klassische Pizza'),
      _t('pizza-special', 'Pizza speciale', 'Special pizza', 'Spezial-Pizza'),
      _t('calzone', 'Calzone', 'Calzone', 'Calzone'),
      _t('sides', 'Shtesa', 'Sides', 'Beilagen'),
      _t('salads', 'Sallata', 'Salads', 'Salate'),
      _t('beverages', 'Pije', 'Beverages', 'Getränke'),
    ],
    BusinessType.cafe: [
      _t('coffee', 'Kafe', 'Coffee', 'Kaffee'),
      _t('tea', 'Çaj', 'Tea', 'Tee'),
      _t('cold-drinks', 'Pije të ftohta', 'Cold drinks', 'Kaltgetränke'),
      _t('pastries', 'Ëmbëlsira', 'Pastries', 'Gebäck'),
      _t('snacks', 'Snacks', 'Snacks', 'Snacks'),
      _t('breakfast', 'Mëngjes', 'Breakfast', 'Frühstück'),
    ],
    BusinessType.fastFood: [
      _t('burgers', 'Burgerë', 'Burgers', 'Burger'),
      _t('pizza', 'Pizza', 'Pizza', 'Pizza'),
      _t('sides', 'Shtesa', 'Sides', 'Beilagen'),
      _t('combos', 'Combo', 'Combos', 'Menüs'),
      _t('drinks', 'Pije', 'Drinks', 'Getränke'),
      _t('desserts', 'Ëmbëlsira', 'Desserts', 'Desserts'),
    ],
    BusinessType.bar: [
      _t('cocktails', 'Koktej', 'Cocktails', 'Cocktails'),
      _t('beer', 'Birra', 'Beer', 'Bier'),
      _t('wine', 'Verë', 'Wine', 'Wein'),
      _t('spirits', 'Pije të forta', 'Spirits', 'Spirituosen'),
      _t('snacks', 'Snacks', 'Snacks', 'Snacks'),
      _t('non-alcoholic', 'Pa alkool', 'Non-alcoholic', 'Alkoholfrei'),
    ],
    BusinessType.catering: [
      _t('menus', 'Menu banak', 'Banquet menus', 'Bankett-Menüs'),
      _t('buffet', 'Buffet', 'Buffet', 'Buffet'),
      _t('wedding', 'Dasma', 'Weddings', 'Hochzeiten'),
      _t('corporate', 'Korporatë', 'Corporate', 'Firmen'),
      _t('delivery', 'Dërgesë', 'Delivery', 'Lieferung'),
    ],
    BusinessType.butcher: [
      _t('beef', 'Mish lope', 'Beef', 'Rind'),
      _t('lamb', 'Mish qengji', 'Lamb', 'Lamm'),
      _t('chicken', 'Mish pule', 'Chicken', 'Huhn'),
      _t('sausages', 'Salsiçe', 'Sausages', 'Wurst'),
      _t('prepared', 'Gatshme', 'Prepared', 'Fertig'),
    ],
    BusinessType.iceCream: [
      _t('gelato', 'Akullore', 'Ice cream', 'Eis'),
      _t('sorbet', 'Sorbet', 'Sorbet', 'Sorbet'),
      _t('waffles', 'Vafla', 'Waffles', 'Waffeln'),
      _t('toppings', 'Shtesa', 'Toppings', 'Toppings'),
      _t('drinks', 'Pije', 'Drinks', 'Getränke'),
    ],
    BusinessType.flowerShop: [
      _t('bouquets', 'Buqeta', 'Bouquets', 'Sträuße'),
      _t('wedding', 'Dasma', 'Weddings', 'Hochzeit'),
      _t('plants', 'Bimë', 'Plants', 'Pflanzen'),
      _t('gifts', 'Dhurata', 'Gifts', 'Geschenke'),
      _t('funeral', 'Funeral', 'Funeral', 'Trauer'),
    ],
    BusinessType.jewelry: [
      _t('rings', 'Unaza', 'Rings', 'Ringe'),
      _t('necklaces', 'Varëse', 'Necklaces', 'Halsketten'),
      _t('watches', 'Orë', 'Watches', 'Uhren'),
      _t('gold', 'Ar', 'Gold', 'Gold'),
      _t('silver', 'Argjend', 'Silver', 'Silber'),
    ],
    BusinessType.bookstore: [
      _t('books', 'Libra', 'Books', 'Bücher'),
      _t('school', 'Shkollë', 'School', 'Schule'),
      _t('stationery', 'Kancelari', 'Stationery', 'Schreibwaren'),
      _t('gifts', 'Dhurata', 'Gifts', 'Geschenke'),
      _t('magazines', 'Revista', 'Magazines', 'Zeitschriften'),
    ],
    BusinessType.pharmacy: [
      _t('medicines', 'Barna', 'Medicines', 'Medikamente'),
      _t('vitamins', 'Vitamina', 'Vitamins', 'Vitamine'),
      _t('cosmetics', 'Kozmetikë', 'Cosmetics', 'Kosmetik'),
      _t('baby-care', 'Bebe', 'Baby care', 'Babypflege'),
      _t('first-aid', 'Ndihmë e shpejtë', 'First aid', 'Erste Hilfe'),
    ],
    BusinessType.petShop: [
      _t('dog', 'Qen', 'Dogs', 'Hunde'),
      _t('cat', 'Mace', 'Cats', 'Katzen'),
      _t('pet-food', 'Ushqim', 'Pet food', 'Tierfutter'),
      _t('accessories', 'Aksesorë', 'Accessories', 'Zubehör'),
      _t('grooming', 'Grooming', 'Grooming', 'Pflege'),
    ],
    BusinessType.services: [
      _t('consulting', 'Konsulencë', 'Consulting', 'Beratung'),
      _t('installation', 'Instalim', 'Installation', 'Installation'),
      _t('maintenance', 'Mirëmbajtje', 'Maintenance', 'Wartung'),
      _t('packages', 'Paketa', 'Packages', 'Pakete'),
    ],
    BusinessType.salon: [
      _t('haircuts', 'Prerje flokësh', 'Haircuts', 'Haarschnitte'),
      _t('coloring', 'Ngjyrosje', 'Coloring', 'Färben'),
      _t('styling', 'Stilim', 'Styling', 'Styling'),
      _t('nails', 'Thonj', 'Nails', 'Nägel'),
      _t('skin-care', 'Kujdes lëkure', 'Skin care', 'Hautpflege'),
      _t('products', 'Produkte', 'Products', 'Produkte'),
    ],
    BusinessType.spa: [
      _t('massages', 'Masazhe', 'Massages', 'Massagen'),
      _t('facials', 'Fytyrë', 'Facials', 'Gesichtsbehandlungen'),
      _t('body-treatments', 'Trup', 'Body treatments', 'Körperbehandlungen'),
      _t('packages', 'Paketa', 'Packages', 'Pakete'),
      _t('wellness-products', 'Produkte wellness', 'Wellness products', 'Wellness-Produkte'),
    ],
    BusinessType.clinic: [
      _t('consultations', 'Konsulta', 'Consultations', 'Sprechstunden'),
      _t('diagnostics', 'Diagnostikë', 'Diagnostics', 'Diagnostik'),
      _t('treatments', 'Trajtime', 'Treatments', 'Behandlungen'),
      _t('dental', 'Stomatologji', 'Dental', 'Zahnmedizin'),
      _t('pediatrics', 'Pediatri', 'Pediatrics', 'Pädiatrie'),
    ],
    BusinessType.automotive: [
      _t('oil-change', 'Ndërrim vaji', 'Oil change', 'Ölwechsel'),
      _t('tires', 'Goma', 'Tires', 'Reifen'),
      _t('brakes', 'Frenat', 'Brakes', 'Bremsen'),
      _t('inspection', 'Kontroll', 'Inspection', 'Inspektion'),
      _t('parts', 'Pjesë', 'Parts', 'Ersatzteile'),
    ],
    BusinessType.fitness: [
      _t('memberships', 'Anëtarësime', 'Memberships', 'Mitgliedschaften'),
      _t('personal-training', 'Trajner personal', 'Personal training', 'Personal Training'),
      _t('classes', 'Klasa', 'Classes', 'Kurse'),
      _t('supplements', 'Suplemente', 'Supplements', 'Nahrungsergänzung'),
      _t('apparel', 'Veshje sportive', 'Apparel', 'Bekleidung'),
    ],
    BusinessType.education: [
      _t('courses', 'Kurse', 'Courses', 'Kurse'),
      _t('tutoring', 'Mësime private', 'Tutoring', 'Nachhilfe'),
      _t('languages', 'Gjuhë', 'Languages', 'Sprachen'),
      _t('kids', 'Fëmijë', 'Kids', 'Kinder'),
      _t('exam-prep', 'Përgatitje provimi', 'Exam prep', 'Prüfungsvorbereitung'),
    ],
    BusinessType.professional: [
      _t('consulting', 'Konsulencë', 'Consulting', 'Beratung'),
      _t('legal', 'Ligjore', 'Legal', 'Recht'),
      _t('accounting', 'Kontabilitet', 'Accounting', 'Buchhaltung'),
      _t('tax', 'Tatime', 'Tax', 'Steuern'),
      _t('documents', 'Dokumente', 'Documents', 'Dokumente'),
    ],
    BusinessType.homeServices: [
      _t('plumbing', 'Hidraulik', 'Plumbing', 'Sanitär'),
      _t('electrical', 'Elektrik', 'Electrical', 'Elektrik'),
      _t('cleaning', 'Pastrim', 'Cleaning', 'Reinigung'),
      _t('painting', 'Lyerje', 'Painting', 'Malerarbeiten'),
      _t('hvac', 'Klimë', 'HVAC', 'Klima'),
    ],
    BusinessType.hotel: [
      _t('rooms', 'Dhoma', 'Rooms', 'Zimmer'),
      _t('suites', 'Suite', 'Suites', 'Suiten'),
      _t('breakfast', 'Mëngjes', 'Breakfast', 'Frühstück'),
      _t('minibar', 'Minibar', 'Minibar', 'Minibar'),
      _t('extras', 'Ekstra', 'Extras', 'Extras'),
    ],
    BusinessType.other: _generic,
  };
}
