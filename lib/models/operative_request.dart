
class OperativeRequest {
  final String id;
  final String institutionName;
  final String institutionType; // 'junta_vecinos', 'parroquia', 'empresa', 'otro'
  final String address;
  final int estimatedPeople;
  final String contactName;
  final String contactPhone;
  final String status; // 'pendiente', 'coordinado', 'realizado'
  final DateTime requestDate;

  OperativeRequest({
    required this.id,
    required this.institutionName,
    required this.institutionType,
    required this.address,
    required this.estimatedPeople,
    required this.contactName,
    required this.contactPhone,
    required this.status,
    required this.requestDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institutionName': institutionName,
      'institutionType': institutionType,
      'address': address,
      'estimatedPeople': estimatedPeople,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'status': status,
      'requestDate': requestDate.toIso8601String(),
    };
  }

  factory OperativeRequest.fromMap(Map<String, dynamic> map, String id) {
    return OperativeRequest(
      id: id,
      institutionName: map['institutionName'] ?? '',
      institutionType: map['institutionType'] ?? '',
      address: map['address'] ?? '',
      estimatedPeople: map['estimatedPeople'] ?? 0,
      contactName: map['contactName'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      status: map['status'] ?? 'pendiente',
      requestDate: DateTime.parse(map['requestDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
