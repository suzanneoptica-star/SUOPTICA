
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800; // Breakpoint simple
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () => context.go('/'),
              child: const Row(
                children: [
                   Icon(Icons.remove_red_eye, color: Color(0xFF009B77)), 
                   SizedBox(width: 8),
                   Text('Su Óptica', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 40),
              _DesktopNavLink(label: 'Inicio', onTap: () => context.go('/')),
              _DesktopNavLink(label: 'Catálogo', onTap: () => context.go('/catalog')),
              _DesktopNavLink(label: 'Operativos', onTap: () => context.go('/operative-request')),
            ]
          ],
        ),
        actions: [
          // Nav Items
          if (!isDesktop) ...[
            IconButton(
               icon: const Icon(Icons.search),
               onPressed: () {},
            ),
          ],
          
          // Cart
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Badge(
              label: Text(cart.items.length.toString()),
              isLabelVisible: cart.items.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
          
          const SizedBox(width: 10),

          // User Menu
          if (auth.isLoggedIn)
            PopupMenuButton(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(auth.userName?[0] ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 8),
                    Text(auth.userName ?? 'Usuario', style: const TextStyle(color: Colors.black)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ]
                ],
              ),
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
            TextButton.icon(
              onPressed: () => context.push('/login'),
              icon: const Icon(Icons.person_outline),
              label: Text(isDesktop ? 'Iniciar Sesión' : ''),
            ),
            
          const SizedBox(width: 20),
        ],
      ),
      drawer: isDesktop ? null : Drawer(
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
            const Divider(),
            if (auth.isLoggedIn) ...[
               ListTile(leading: const Icon(Icons.receipt), title: const Text('Mis Pedidos'), onTap: () { Navigator.pop(context); context.push('/orders'); }),
               ListTile(leading: const Icon(Icons.health_and_safety), title: const Text('Mi Salud Visual'), onTap: () { Navigator.pop(context); context.push('/visual-health'); }),
               ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)), onTap: () { Navigator.pop(context); auth.logout(); }),
            ] else 
               ListTile(leading: const Icon(Icons.login), title: const Text('Iniciar Sesión'), onTap: () { Navigator.pop(context); context.push('/login'); }),
          ],
        ),
      ),
      endDrawer: _buildCartDrawer(context, cart),
      body: widget.child,
      floatingActionButton: _buildWhatsAppButton(),
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
