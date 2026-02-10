
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class ResponsiveShell extends StatefulWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isWishlistDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800; // Breakpoint simple
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    
    // Determine visibility of shop icons
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool showShopIcons = currentPath.startsWith('/catalog') || currentPath == '/cart' || currentPath == '/checkout' || currentPath.startsWith('/product-detail');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () => context.go('/'),
              child: Row(
                children: [
                   const Icon(Icons.remove_red_eye, color: Color(0xFF009B77)), 
                   if (width > 400) ...[
                      const SizedBox(width: 8),
                      const Text('Su Óptica', style: TextStyle(fontWeight: FontWeight.bold)),
                   ]
                ],
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 40),
              _DesktopNavLink(label: 'Inicio', onTap: () => context.go('/')),
              _DesktopNavLink(label: 'Catálogo', onTap: () => context.go('/catalog')),
              _DesktopNavLink(label: 'Operativos', onTap: () => context.go('/operative-request')),
              _DesktopNavLink(label: 'Contáctanos', onTap: () => context.go('/contact')),
            ]
          ],
        ),
        actions: [
          // Ayuda / Soporte Unificado
          PopupMenuButton(
            tooltip: 'Ayuda',
            icon: const Icon(Icons.chat_bubble_outline),
            offset: const Offset(0, 50),
            color: Colors.white,
            surfaceTintColor: Colors.white,
            itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
              const PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.support_agent, color: Color(0xFF009B77)),
                        SizedBox(width: 8),
                        Text('Soporte en línea', style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 32, top: 4),
                      child: Text('Horario: 9:00 - 18:00', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                   const message = 'Hola! me gustaría recibir ayuda';
                   final url = 'https://wa.me/56944290263?text=${Uri.encodeComponent(message)}';
                   if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                   }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () async {
                   final url = 'mailto:suzanne.optica@gmail.com';
                   if (await canLaunchUrl(Uri.parse(url))) {
                     await launchUrl(Uri.parse(url));
                   }
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Enviar correo'),
                ),
              ),
            ],
          ),

          // Buscador
          PopupMenuButton(
            tooltip: 'Buscar',
            icon: const Icon(Icons.search),
            offset: const Offset(0, 50),
            color: Colors.white,
            surfaceTintColor: Colors.white,
            constraints: const BoxConstraints(maxWidth: 340),
            itemBuilder: (context) => [
               PopupMenuItem(
                enabled: false,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Buscar producto', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                           Navigator.pop(context);
                           showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'Cerrar búsqueda',
                                barrierColor: Colors.black54,
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (context, anim1, anim2) {
                                  return const _SearchModal();
                                },
                           );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!)
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 10),
                              Text('Clic para buscar...', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('Etiquetas rápidas:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(onPressed: (){}, child: const Text('Lentes Hombre', style: TextStyle(fontSize: 12))),
                          TextButton(onPressed: (){}, child: const Text('Lentes Mujer', style: TextStyle(fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                ),
               ),
            ],
          ),
          
          // Mi Cuenta
          if (auth.isLoggedIn)
             PopupMenuButton(
              icon: const Icon(Icons.person_outline),
              itemBuilder: (context) => [
                _buildMenuItem(context, 'Mis Pedidos', Icons.receipt_long, '/orders'),
                _buildMenuItem(context, 'Mi Salud Visual', Icons.health_and_safety, '/visual-health'),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 10), Text('Cerrar Sesión')]),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  auth.logout();
                  context.go('/');
                } else {
                  context.push(value.toString());
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'Iniciar Sesión',
              onPressed: () => context.push('/login'),
            ),

          // Lista de Deseos (Sólo visible en Catálogo/Tienda)
          if (showShopIcons)
            IconButton(
              onPressed: () {
                setState(() {
                  _isWishlistDrawerOpen = true;
                });
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Badge(
                label: Text('2'),
                child: Icon(Icons.favorite_border),
              ),
            ),
          
          // Carrito (Sólo visible en Catálogo/Tienda)
          if (showShopIcons)
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              icon: Badge(
                label: Text(cart.items.length.toString()),
                isLabelVisible: cart.items.isNotEmpty,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
            
          const SizedBox(width: 20),
        ],
      ),
      drawer: _isWishlistDrawerOpen 
          ? _buildWishlistDrawer(context) // Custom Wishlist Drawer
          : (isDesktop 
              ? null // No nav drawer on desktop normally
              : _buildNavigationDrawer(context, auth)), // Standard Nav Drawer
      onDrawerChanged: (isOpen) {
        if (!isOpen) {
          // Reset state when drawer closes
          setState(() {
            _isWishlistDrawerOpen = false;
          });
        }
      },
      endDrawer: _buildCartDrawer(context, cart),
      body: widget.child,
      floatingActionButton: _buildWhatsAppButton(),
    );
  }

  // Extracted Navigation Drawer
  Widget _buildNavigationDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Su Óptica', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  if (auth.isLoggedIn)
                    Text('Hola, ${auth.userName}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text('Inicio'), onTap: () { Navigator.pop(context); context.go('/'); }),
            ListTile(leading: const Icon(Icons.grid_view), title: const Text('Catálogo'), onTap: () { Navigator.pop(context); context.go('/catalog'); }),
            ListTile(leading: const Icon(Icons.people), title: const Text('Operativos'), onTap: () { Navigator.pop(context); context.go('/operative-request'); }),
            ListTile(leading: const Icon(Icons.contact_mail), title: const Text('Contáctanos'), onTap: () { Navigator.pop(context); context.go('/contact'); }),
            const Divider(),
            if (auth.isLoggedIn) ...[
               ListTile(leading: const Icon(Icons.receipt), title: const Text('Mis Pedidos'), onTap: () { Navigator.pop(context); context.push('/orders'); }),
               ListTile(leading: const Icon(Icons.health_and_safety), title: const Text('Mi Salud Visual'), onTap: () { Navigator.pop(context); context.push('/visual-health'); }),
               ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)), onTap: () { Navigator.pop(context); auth.logout(); }),
            ] else 
               ListTile(leading: const Icon(Icons.login), title: const Text('Iniciar Sesión'), onTap: () { Navigator.pop(context); context.push('/login'); }),
          ],
        ),
      );
  }

 Widget _buildWishlistDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: Colors.purple[800], // Distinct color for wishlist
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tu Lista de Deseos', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                 _buildWishlistItem('Lente Ray-Ban', 120000, 'assets/images/soho.png'),
                 const Divider(),
                 _buildWishlistItem('Lente Oakley Sport', 150000, 'assets/images/f1.png'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('\$270.000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                         Navigator.pop(context);
                         // Logic to add all to cart
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('AÑADIR TODO AL CARRITO'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.purple[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWishlistItem(String name, int price, String imagePath) {
     return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 60, height: 60,
          color: Colors.grey[200],
          child: const Icon(Icons.image),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${price.toString()}'),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
     );
  }

  Widget _buildWhatsAppButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: const Text("¿Tienes una duda?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        ),
        FloatingActionButton(
          onPressed: () async {
             const message = 'Hola! necesito asesoramiento';
             final url = 'https://wa.me/56944290263?text=${Uri.encodeComponent(message)}';
             if (await canLaunchUrl(Uri.parse(url))) {
               await launchUrl(Uri.parse(url));
             }
          },
          backgroundColor: const Color(0xFF25D366),
          child: const Icon(Icons.chat_bubble, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCartDrawer(BuildContext context, CartProvider cart) {
    return Drawer(
      width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tu Carrito', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Tu carrito está vacío'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                          child: item.product.imageUrl.isNotEmpty 
                              ? Image.network(item.product.imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image))
                              : const Icon(Icons.shopping_bag_outlined),
                        ),
                        title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.lensType != null)
                              Text(item.lensType!.name, style: const TextStyle(fontSize: 12)),
                            if (item.treatments.isNotEmpty)
                              Text('Tratamientos: ${item.treatments.map((t) => t.name).join(", ")}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            if (item.prescriptionFile != null)
                               Row(children: [
                                 const Icon(Icons.description, size: 12, color: Colors.green),
                                 const SizedBox(width: 4),
                                 const Text('Receta adjunta', style: TextStyle(fontSize: 10, color: Colors.green)),
                               ]),
                          ],
                        ),
                        trailing: Text('\$${(item.totalPrice).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text('Envío e impuestos calculados al finalizar', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close Drawer
                        context.push('/checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('FINALIZAR COMPRA'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return PopupMenuItem(
      value: route,
      child: Row(children: [Icon(icon, color: Colors.black54), const SizedBox(width: 10), Text(title)]),
    );
  }
}

// Modal de Búsqueda Avanzada
class _SearchModal extends StatelessWidget {
  const _SearchModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.transparent, // Important for overlay effect
      body: Stack(
        children: [
          // Semi-transparent background that closes modal on tap
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black54),
          ),
          
          // The Search Content
          Center(
            child: Container(
              width: 800,
              height: 500,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const SizedBox(width: 24), // Spacer for centering
                       const Text('Buscar en la tienda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                       IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                     ],
                   ),
                   const SizedBox(height: 10),
                   const Text('La búsqueda avanzada lo ayudará a encontrar rápidamente un producto', style: TextStyle(color: Colors.grey)),
                   const SizedBox(height: 30),
                   
                   TextField(
                     decoration: const InputDecoration(
                       hintText: 'Busque por título, sku, tipo, proveedor, descripción...',
                       suffixIcon: Icon(Icons.search),
                       border: UnderlineInputBorder(),
                       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF009B77))),
                     ),
                     style: const TextStyle(fontSize: 18),
                   ),
                   const SizedBox(height: 20),
                   Row(
                     children: [
                       const Text('Etiquetas de búsqueda rápidas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                       const SizedBox(width: 15),
                       TextButton(onPressed: (){}, child: const Text('Lentes Hombre', style: TextStyle(color: Color(0xFF009B77)))),
                       TextButton(onPressed: (){}, child: const Text('Lentes Niño', style: TextStyle(color: Color(0xFF009B77)))),
                       TextButton(onPressed: (){}, child: const Text('Accesorios', style: TextStyle(color: Color(0xFF009B77)))),
                     ],
                   ),
                   const SizedBox(height: 40),
                   const Text('Lo más buscado hoy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   const SizedBox(height: 20),
                   Expanded(
                     child: ListView.separated(
                       scrollDirection: Axis.horizontal,
                       itemCount: 5,
                       separatorBuilder: (_,__) => const SizedBox(width: 20),
                       itemBuilder: (context, index) {
                         return Container(
                           width: 120,
                           decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(10),
                           ),
                           alignment: Alignment.center,
                           child: const Text('PRODUCTO', style: TextStyle(color: Colors.grey)),
                         );
                       },
                     ),
                   )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DesktopNavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ),
    );
  }
}
