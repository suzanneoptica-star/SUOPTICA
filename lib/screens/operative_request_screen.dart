
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OperativeRequestScreen extends StatefulWidget {
  const OperativeRequestScreen({super.key});

  @override
  State<OperativeRequestScreen> createState() => _OperativeRequestScreenState();
}

class _OperativeRequestScreenState extends State<OperativeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores Simplificados
  final _nameController = TextEditingController(); // Nombre del solicitante
  final _communeController = TextEditingController(); // Comuna
  final _phoneController = TextEditingController(); // Telefono

  @override
  void dispose() {
    _nameController.dispose();
    _communeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organiza tu Operativo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Image or Icon
              Center(
                child: Icon(Icons.groups, size: 80, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Lleva Su Óptica a tu Comunidad',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Ideal para Juntas de Vecinos, Empresas y Fundaciones.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Paso a Paso Estructurado Vertical
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Cómo funciona?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                    const SizedBox(height: 20),
                    _buildStepRow('1', 'Solicitud', 'Completa el formulario simple a continuación.'),
                    _buildStepRow('2', 'Coordinación', 'Te contactaremos para definir fecha y hora.'),
                    _buildStepRow('3', 'Difusión', 'Te enviamos material digital para invitar a tus vecinos.'),
                    _buildStepRow('4', 'Operativo', 'Vamos con equipos profesionales y +300 marcos.'),
                    _buildStepRow('5', 'Entrega', 'Entrega rápida de lentes listos en el mismo lugar.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              const Text(
                '¡Inscríbete Aquí!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Formulario Simplificado
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tu Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => 
                  value == null || value.isEmpty ? 'Por favor ingresa tu nombre' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _communeController,
                decoration: const InputDecoration(
                  labelText: 'Comuna',
                  prefixIcon: Icon(Icons.map),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => 
                  value == null || value.isEmpty ? 'Por favor ingresa tu comuna' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Número de Contacto',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  hintText: '+569 XXXXXXXX'
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => 
                  value == null || value.isEmpty ? 'Por favor ingresa un número' : null,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final commune = _communeController.text;
                    // final phone = _phoneController.text; // Ya lo tiene el usuario al enviar

                    final message = 'Hola!, me gustaria saber si puede hacer un op en mi sector. (Solicitado por: $name, Comuna: $commune)';
                    final url = 'https://wa.me/56944290263?text=${Uri.encodeComponent(message)}';
                    
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('SOLICITAR OPERATIVO'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, 
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 3),
                Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
