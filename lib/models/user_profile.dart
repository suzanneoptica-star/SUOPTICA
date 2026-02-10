
import 'order.dart';

class UserHealthProfile {
  final String id;
  final String name;
  final DateTime lastCheckupDate;
  final String lastCheckupLocation; // "Operativo Empresa X" o "Tienda Central"
  final List<PrescriptionRecord> history;

  UserHealthProfile({
    required this.id,
    required this.name,
    required this.lastCheckupDate,
    required this.lastCheckupLocation,
    required this.history,
  });

  DateTime get nextControlDate => lastCheckupDate.add(const Duration(days: 365));

  bool get needsControl => DateTime.now().isAfter(nextControlDate);
}

class PrescriptionRecord {
  final String id;
  final DateTime date;
  final String origin; // "Consulta Dr. Perez" o "Operativo"
  final String imageUrl; // URL del archivo digital
  final PrescriptionData? data;

  PrescriptionRecord({
    required this.id,
    required this.date,
    required this.origin,
    required this.imageUrl,
    this.data,
  });
}
