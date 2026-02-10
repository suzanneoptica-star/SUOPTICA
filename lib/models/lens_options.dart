
class LensType {
  final String id;
  final String name;
  final double price;
  final String description;

  const LensType({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
}

class LensTreatment {
  final String id;
  final String name;
  final double price;
  final String description;

  const LensTreatment({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
}

// Datos Maestros de Cristales
class LensData {
  static const List<LensType> types = [
    LensType(id: 'none', name: 'Solo Armazón', price: 0, description: 'Sin cristales graduados'),
    LensType(id: 'mono', name: 'Monofocal', price: 25000, description: 'Para visión de lejos o cerca'),
    LensType(id: 'bifocal', name: 'Bifocal', price: 45000, description: 'Dos campos de visión (lejos y cerca) con línea visible'),
    LensType(id: 'multi', name: 'Multifocal (Progresivo)', price: 85000, description: 'Visión continua a todas las distancias'),
  ];

  static const List<LensTreatment> treatments = [
    LensTreatment(id: 'blue', name: 'Filtro Luz Azul', price: 15000, description: 'Protege tus ojos de pantallas digitales'),
    LensTreatment(id: 'photo', name: 'Fotocromático', price: 30000, description: 'Se oscurecen con el sol (Transiciones)'),
    LensTreatment(id: 'anti', name: 'Antirreflejo Premium', price: 10000, description: 'Reduce brillos y mejora estética'),
  ];
}
