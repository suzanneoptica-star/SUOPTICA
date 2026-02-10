
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Pedido ${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linea de Tiempo de Estado
            _buildStatusTimeline(context),
            const SizedBox(height: 30),

            // Detalles del Producto
            _buildSectionTitle(context, 'Producto Comprado'),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.inventory_2),
                ),
                title: Text(order.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${order.product.category}\n${order.product.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 30),

            // Receta Médica
            if (order.prescriptionData != null || order.prescriptionImageUrl != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(context, 'Mi Receta'),
                  TextButton.icon(
                    onPressed: () {
                      // Acción para descargar o ver pantalla completa
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Descargando receta...')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar PDF'),
                  )
                ],
              ),
              const SizedBox(height: 10),
              _buildPrescriptionCard(context),
            ] else 
              const Center(child: Text("Este pedido no tiene receta asociada.")),
            
            const SizedBox(height: 30),
            
            if (order.estimatedDeliveryDate != null && order.status != 'Entregado')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha Estimada de Entrega', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(order.estimatedDeliveryDate.toString().split(' ')[0]),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context) {
    // Pasos: Comprado -> Laboratorio -> Camino -> Entregado
    const steps = ['Comprado', 'Taller', 'Despacho', 'Recibido'];
    final currentStep = order.currentStep;

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: isCompleted ? Theme.of(context).primaryColor : Colors.grey[300],
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 10, 
                        color: isCompleted ? Colors.black : Colors.grey,
                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal
                      ),
                    )
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < currentStep ? Theme.of(context).primaryColor : Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context) {
    if (order.prescriptionData == null) {
      return Card(
        child: Container(
          height: 150,
          alignment: Alignment.center,
          child: const Text('Imagen de la receta'), // Aquí iría la imagen si fuera URL
        ),
      );
    }

    final od = order.prescriptionData!.od;
    final oi = order.prescriptionData!.oi;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEyeRow('OD (Derecho)', od),
            const Divider(),
            _buildEyeRow('OI (Izquierdo)', oi),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Distancia Pupilar:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('${order.prescriptionData!.dp} mm'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeRow(String label, EyePrescription data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('Esf: ${data.sphere}')),
          Expanded(child: Text('Cil: ${data.cylinder}')),
          Expanded(child: Text('Eje: ${data.axis}°')),
        ],
      ),
    );
  }
}
