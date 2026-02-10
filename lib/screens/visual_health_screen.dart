
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_profile.dart';
import '../models/order.dart';

class VisualHealthScreen extends StatelessWidget {
  const VisualHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final profile = UserHealthProfile(
      id: 'u1',
      name: 'Joaquín',
      lastCheckupDate: DateTime.now().subtract(const Duration(days: 400)), // Hace más de un año
      lastCheckupLocation: 'Operativo Municipalidad',
      history: [
        PrescriptionRecord(
          id: 'p1',
          date: DateTime.now().subtract(const Duration(days: 400)),
          origin: 'Operativo Municipalidad',
          imageUrl: '',
          data: PrescriptionData(
            od: EyePrescription(sphere: -1.5, cylinder: -0.5, axis: 90),
            oi: EyePrescription(sphere: -2.0, cylinder: 0.0, axis: 0),
            dp: 62,
          ),
        ),
        PrescriptionRecord(
          id: 'p2',
          date: DateTime.now().subtract(const Duration(days: 800)),
          origin: 'Consulta Dr. Soto',
          imageUrl: '',
          data: PrescriptionData(
            od: EyePrescription(sphere: -1.25, cylinder: -0.25, axis: 85),
            oi: EyePrescription(sphere: -1.75, cylinder: 0.0, axis: 0),
            dp: 61,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Salud Visual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Alerta de Control
            _buildHealthAlert(context, profile),
            const SizedBox(height: 25),

            // Archivo Digital Header
            Text(
              'Historial de Recetas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text('Accede y descarga tus recetas antiguas.'),
            const SizedBox(height: 15),

            // Lista de Recetas
            ...profile.history.map((record) => _buildPrescriptionCard(context, record)),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthAlert(BuildContext context, UserHealthProfile profile) {
    if (profile.needsControl) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.notification_important, color: Colors.red, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('¡Recordatorio de Control!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 5),
                  Text('Ya pasó un año desde tu último chequeo en ${profile.lastCheckupLocation}. Es hora de revisar tu vista.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.push('/operative-request'), // O agendar hora
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('Agendar hora'),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Salud Visual al Día', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 5),
                  Text('Tu próximo control sugerido es en: ${_formatDate(profile.nextControlDate)}'),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildPrescriptionCard(BuildContext context, PrescriptionRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.description, color: Theme.of(context).primaryColor),
        ),
        title: Text(record.origin, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_formatDate(record.date)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (record.data != null) ...[
                  _buildEyeDataRow('OD', record.data!.od),
                  const SizedBox(height: 5),
                  _buildEyeDataRow('OI', record.data!.oi),
                  const SizedBox(height: 10),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     OutlinedButton.icon(
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Descargando receta digital...')),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Descargar Archivo'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEyeDataRow(String eye, EyePrescription data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(eye, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Esf: ${data.sphere}'),
        Text('Cil: ${data.cylinder}'),
        Text('Eje: ${data.axis}°'),
      ],
    );
  }

  String _formatDate(DateTime date) {
    // Simple date formatter
    return '${date.day}/${date.month}/${date.year}';
  }
}
