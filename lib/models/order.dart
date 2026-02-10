
import 'product.dart';

class Order {
  final String id;
  final String userId;
  final Product product; // Simplificado para este ejemplo: 1 producto principal
  final String status; // 'Comprado', 'En Laboratorio', 'En Camino', 'Entregado'
  final DateTime orderDate;
  final DateTime? estimatedDeliveryDate;
  final String? prescriptionImageUrl;
  final PrescriptionData? prescriptionData;

  Order({
    required this.id,
    required this.userId,
    required this.product,
    required this.status,
    required this.orderDate,
    this.estimatedDeliveryDate,
    this.prescriptionImageUrl,
    this.prescriptionData,
  });

  // Métodos de utilidad para UI
  int get currentStep {
    switch (status) {
      case 'Comprado':
        return 0;
      case 'En Laboratorio':
        return 1;
      case 'En Camino':
        return 2;
      case 'Entregado':
        return 3;
      default:
        return 0;
    }
  }
}

class PrescriptionData {
  // Datos oftalmológicos básicos OD (Ojo Derecho) / OI (Ojo Izquierdo)
  final EyePrescription od;
  final EyePrescription oi;
  final double dp; // Distancia Pupilar

  PrescriptionData({
    required this.od,
    required this.oi,
    required this.dp,
  });
}

class EyePrescription {
  final double sphere; // Esfera
  final double cylinder; // Cilindro
  final int axis; // Eje

  EyePrescription({
    required this.sphere,
    required this.cylinder,
    required this.axis,
  });

  @override
  String toString() {
    return 'Esfera: $sphere, Cilindro: $cylinder, Eje: $axis°';
  }
}
