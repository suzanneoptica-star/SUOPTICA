
import 'dart:io';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCommune = 'Santiago Centro';
  double _shippingCost = 3000;
  XFile? _prescriptionImage;
  // ignore: unused_field
  bool _isUploading = false;
  bool _acceptsPolicies = false;

  final Map<String, double> _communeShippingCosts = {
    'Santiago Centro': 3000,
    'Providencia': 4000,
    'Las Condes': 4500,
    'Vitacura': 4500,
    'Ñuñoa': 4000,
    'Maipú': 5500,
    'Puente Alto': 6000,
    'La Florida': 5000,
    'Regiones (Starken)': 10000,
  };

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: cart.items.isEmpty 
          ? const Center(child: Text('Tu carrito está vacío'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Resumen de Compra
                    Text('Resumen del Pedido', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(item.product.name),
                                  subtitle: Text(item.product.category),
                                  trailing: Text('\$${item.totalPrice.toStringAsFixed(0)}'),
                                  leading: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => cart.removeItem(item),
                                  ),
                                ),
                                if (item.lensType != null && item.lensType!.price > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    width: double.infinity,
                                    color: Colors.blue[50],
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ${item.lensType!.name}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ...item.treatments.map((t) => Text('• ${t.name}', style: const TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    
                    // Validación de Receta (Solo si hay cristales)
                    if (cart.hasLenses) ...[
                      const SizedBox(height: 20),
                      Text('Receta Médica (Obligatorio)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
                      const Text('Has incluido cristales en tu compra. Por favor sube una foto de tu receta vigente.'),
                      const SizedBox(height: 10),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: _prescriptionImage == null ? Colors.red : Colors.green),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[100],
                        ),
                        child: _prescriptionImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                  TextButton(
                                    onPressed: _pickPrescriptionImage,
                                    child: const Text('Subir Foto de Receta'),
                                  ),
                                ],
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  // En Web usamos Image.network si path no está disponible como File, 
                                  // pero image_picker maneja esto. Para simplificar visualización básica:
                                  kIsWeb 
                                    ? Image.network(_prescriptionImage!.path, fit: BoxFit.cover)
                                    : Image.file(File(_prescriptionImage!.path), fit: BoxFit.cover),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _prescriptionImage = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    // Datos de Despacho
                    Text('Datos de Entrega', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 15),
                    
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Dirección (Calle, Número, Depto)'),
                      validator: (value) => value!.isEmpty ? 'Por favor ingrese su dirección' : null,
                    ),
                    const SizedBox(height: 15),
                    
                    DropdownButtonFormField<String>(
                      value: _selectedCommune,
                      decoration: const InputDecoration(labelText: 'Comuna / Zona'),
                      items: _communeShippingCosts.keys.map((String commune) {
                        return DropdownMenuItem<String>(
                          value: commune,
                          child: Text(commune),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCommune = newValue!;
                          _shippingCost = _communeShippingCosts[newValue]!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas Especiales (Opcional)',
                        hintText: 'Ej: Dejar en conserjería, llamar al llegar, detalle de la receta...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),

                    // Totales
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _buildPriceRow('Subtotal:', cart.subtotal),
                          _buildPriceRow('Envío:', _shippingCost),
                          const Divider(),
                          _buildPriceRow('TOTAL:', cart.subtotal + _shippingCost, isTotal: true),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: const Text('He leído y acepto las políticas de la tienda'),
                      subtitle: const Text('Incluye términos de servicio y políticas de devolución'),
                      value: _acceptsPolicies,
                      onChanged: (val) {
                        setState(() {
                          _acceptsPolicies = val ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    
                    // Botón Finalizar
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: () {
                        if (cart.items.isEmpty) return;
                        
                        // Validación Receta
                        if (cart.hasLenses && _prescriptionImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Debes subir tu receta médica para continuar.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (!_acceptsPolicies) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Debes aceptar las políticas de la tienda.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          // Procesar Pago (Mock)
                          _processOrder(context, cart);
                        }
                      },
                      child: const Text('Confirmar Pedido y Pagar', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
            )
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPrescriptionImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _prescriptionImage = image;
      });
    }
  }

  void _processOrder(BuildContext context, CartProvider cart) {
    // Simular carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Cerrar loading
      
      // Mostrar éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¡Pedido Confirmado!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 10),
              Text('Te enviaremos los detalles a tu correo. Puedes ver el estado en "Mis Pedidos".'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                cart.clearCart();
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver (idealmente al Home o Orders)
                // O usar go_router: context.go('/');
              },
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      );
    });
  }
}
