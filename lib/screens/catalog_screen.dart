
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Cristales',
    'Armazones',
    'Lentes de Sol',
    'Accesorios'
  ];

  // Mock Data
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Ray-Ban Wayfarer',
      description: 'Clásico diseño de acetato negro.',
      price: 120000,
      category: 'Lentes de Sol',
      imageUrl: 'https://via.placeholder.com/150',
      specs: ProductSpecs(bridge: 18, width: 50, temple: 145),
    ),
    Product(
      id: '2',
      name: 'Armazón Titanio Flexible',
      description: 'Ultraligero y resistente.',
      price: 85000,
      category: 'Armazones',
      imageUrl: 'https://via.placeholder.com/150',
      specs: ProductSpecs(bridge: 16, width: 52, temple: 140),
    ),
    Product(
      id: '3',
      name: 'Cristal Blue Light Cut',
      description: 'Protección contra luz azul de pantallas.',
      price: 45000,
      category: 'Cristales',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '4',
      name: 'Cadena Sujetadora',
      description: 'Estilo elegante para tus lentes.',
      price: 15000,
      category: 'Accesorios',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrar productos
    final filteredProducts = _selectedCategory == 'Todos'
        ? _allProducts
        : _allProducts
            .where((p) => p.category == _selectedCategory)
            .toList();

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 5 : width > 800 ? 4 : width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Pro'),
        // Actions removed as they are in the shell
      ), 
      body: Column(
        children: [
          // Filtros
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),
          // Grid de Productos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/product-detail', extra: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Imagen Placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (product.specs != null)
                  Text(
                    '${product.specs!.bridge}-${product.specs!.width}-${product.specs!.temple}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/product-detail', extra: product);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Ver Detalle',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
