
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../models/lens_options.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  LensType? _selectedLensType;
  final List<LensTreatment> _selectedTreatments = [];
  XFile? _prescriptionFile;

  bool get _isFrame => widget.product.category == 'Armazones';

  @override
  void initState() {
    super.initState();
    // Valor por defecto si es armazón
    if (_isFrame) {
      _selectedLensType = LensData.types.first; 
    }
  }

  Future<void> _pickPrescription() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _prescriptionFile = image;
    });
  }

  double get _totalPrice {
    double total = widget.product.price;
    
    if (_isFrame && _selectedLensType != null) {
      total += _selectedLensType!.price;
      for (var t in _selectedTreatments) {
        total += t.price;
      }
    }
    
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          if (isDesktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildImageSection(context, height: 400)),
                  const SizedBox(width: 50),
                  Expanded(flex: 1, child: _buildDetailsSection(context)),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageSection(context, height: 300),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildDetailsSection(context),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Final', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('\$${_totalPrice.toStringAsFixed(0)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Validate prescription if lens is selected
                  if (_isFrame && 
                      _selectedLensType != null && 
                      _selectedLensType!.id != 'none' && 
                      _prescriptionFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor suba su receta para continuar'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final cartItem = CartItem(
                    product: widget.product,
                    lensType: _isFrame ? _selectedLensType : null,
                    treatments: _isFrame ? List.from(_selectedTreatments) : [],
                    prescriptionFile: _prescriptionFile,
                  );

                  Provider.of<CartProvider>(context, listen: false).addItem(cartItem);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Producto agregado al carrito'),
                      action: SnackBarAction(label: 'VER CARRITO', onPressed: () => context.push('/checkout')),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Agregar al Carrito'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, {double height = 300}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Center(
              child: Icon(Icons.inventory_2, size: 100, color: Colors.grey[200]),
            ),
            if (widget.product.imageUrl.isNotEmpty)
              Image.network(widget.product.imageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Chip(label: Text(widget.product.category), backgroundColor: Colors.grey[100]),
                ],
              ),
            ),
            Text(
              '\$${widget.product.price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Text(widget.product.description, style: Theme.of(context).textTheme.bodyLarge),

        if (widget.product.specs != null) ...[
          const SizedBox(height: 20),
          const Text('Medidas', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSpecItem('Ancho', '${widget.product.specs!.width}mm'),
              const SizedBox(width: 20),
              _buildSpecItem('Puente', '${widget.product.specs!.bridge}mm'),
              const SizedBox(width: 20),
              _buildSpecItem('Patilla', '${widget.product.specs!.temple}mm'),
            ],
          ),
        ],

        const Divider(height: 40),

        if (_isFrame)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build_circle, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text('Personaliza tus Cristales', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                  ],
                ),
                const SizedBox(height: 20),

                const Text('1. Tipo de Lente', style: TextStyle(fontWeight: FontWeight.bold)),
                ...LensData.types.map((type) => RadioListTile<LensType>(
                  title: Text(type.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(type.description, style: const TextStyle(fontSize: 12)),
                  secondary: Text(type.price > 0 ? '+\$${type.price.toStringAsFixed(0)}' : 'Incluido', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                  value: type,
                  groupValue: _selectedLensType,
                  onChanged: (val) {
                    setState(() {
                      _selectedLensType = val;
                      // Reset treatments if lens type changes to none? No, keep them.
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                )),

                if (_selectedLensType != null && _selectedLensType!.id != 'none') ...[
                  const Divider(),
                  const Text('2. Tratamientos / Extras', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...LensData.treatments.map((treatment) {
                    final isSelected = _selectedTreatments.contains(treatment);
                    return CheckboxListTile(
                      title: Text(treatment.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(treatment.description, style: const TextStyle(fontSize: 12)),
                      secondary: Text('+\$${treatment.price.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedTreatments.add(treatment);
                          } else {
                            _selectedTreatments.remove(treatment);
                          }
                        });
                      },
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    );
                  }),
                  
                  const Divider(),
                  const Text('3. Subir Receta (Requerido para cristales)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _pickPrescription,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue.withOpacity(0.5), style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _prescriptionFile != null ? Icons.check_circle : Icons.cloud_upload_outlined, 
                            size: 30, 
                            color: _prescriptionFile != null ? Colors.green : Colors.blue
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _prescriptionFile != null 
                              ? 'Receta cargada: ${_prescriptionFile!.name}' 
                              : 'Toque aquí para subir foto de receta',
                            style: TextStyle(
                              color: _prescriptionFile != null ? Colors.green[700] : Colors.blue[700],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
