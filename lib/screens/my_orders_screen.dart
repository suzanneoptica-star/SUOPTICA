
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/order.dart';
import '../models/product.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Order> orders = [
      Order(
        id: '#12345',
        userId: 'user1',
        product: Product(
          id: '1',
          name: 'Ray-Ban Wayfarer',
          description: 'Clásico diseño de acetato negro.',
          price: 120000,
          category: 'Lentes de Sol',
          imageUrl: '',
          specs: ProductSpecs(bridge: 18, width: 50, temple: 145),
        ),
        status: 'En Laboratorio',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 5)),
        prescriptionData: PrescriptionData(
          od: EyePrescription(sphere: -1.5, cylinder: -0.5, axis: 90),
          oi: EyePrescription(sphere: -2.0, cylinder: 0.0, axis: 0),
          dp: 62,
        ),
      ),
      Order(
        id: '#12300',
        userId: 'user1',
        product: Product(
          id: '3',
          name: 'Cristal Blue Light Cut',
          description: 'Reparación en armazón propio.',
          price: 45000,
          category: 'Cristales',
          imageUrl: '',
        ),
        status: 'Entregado',
        orderDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Comprado':
        return Colors.blue;
      case 'En Laboratorio':
        return Colors.orange;
      case 'En Camino':
        return Colors.purple;
      case 'Entregado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.push('/order-detail', extra: order);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido ${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                title: Text(order.product.name),
                subtitle: Text('Fecha: ${order.orderDate.toString().split(' ')[0]}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
