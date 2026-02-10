
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/review.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Reviews
    final List<Review> reviews = [
      Review(
        id: '1',
        userName: 'María González',
        userImageUrl: '',
        rating: 5.0,
        comment: 'Excelente atención en el operativo de mi empresa. Los lentes quedaron perfectos.',
        date: DateTime.now(),
      ),
      Review(
        id: '2',
        userName: 'Juan Pérez',
        userImageUrl: '',
        rating: 4.5,
        comment: 'Muy buena variedad de armazones. La entrega fue rápida.',
        date: DateTime.now(),
      ),
      Review(
        id: '3',
        userName: 'Ana López',
        userImageUrl: '',
        rating: 5.0,
        comment: 'Me encantó la asesoría personalizada.',
        date: DateTime.now(),
      ),
    ];

    final List<String> partnerLogos = [
      'assets/images/duocuc.png',
      'assets/images/f1.png',
      'assets/images/ministerio.png',
      'assets/images/silentium.png',
      'assets/images/soho.png',
      'assets/images/subus.png',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Eliminamos SliverAppBar por redundancia con Shell
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Hero Section (Carrusel) con Curva
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: SizedBox(
                    height: 450, // Altura aumentada
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 450.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                          ),
                          items: [
                            _buildHeroImage(
                              'https://images.unsplash.com/photo-1572635196237-14b3f281503f?q=80&w=1000&auto=format&fit=crop',
                              'ASESORÍA PERSONALIZADA',
                              'Nuestro equipo te ayudará a tomar la mejor decisión, para que veas y te veas bien.',
                            ),
                            _buildHeroImage(
                              'https://images.unsplash.com/photo-1591076482161-42ce6da69f67?q=80&w=1000&auto=format&fit=crop',
                              'TECNOLOGÍA DE VANGUARDIA',
                              'Equipos modernos para un diagnóstico preciso y confiable.',
                            ),
                            _buildHeroImage(
                              'https://plus.unsplash.com/premium_photo-1675808563229-4171ec552195?q=80&w=1000&auto=format&fit=crop',
                              'VARIEDAD Y ESTILO',
                              'Encuentra el armazón perfecto que refleje tu personalidad.',
                            ),
                          ],
                        ),
                        // Botones superpuestos
                        Positioned(
                          bottom: 50, // Ajustado para estar dentro de la curva
                          left: 20, 
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.push('/catalog'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child: const Text('VER CATÁLOGO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.push('/operative-request'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.9),
                                    foregroundColor: Colors.black,
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child: const Text('SOLICITAR OPERATIVO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                

                // Value Proposition (Estilo Banner iconográfico)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  color: Colors.white,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Adaptable: Row scroll horizontal en movil, Wrap centrado en desktop
                      if (constraints.maxWidth > 800) {
                        return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildValuePropsList(context),
                        );
                      } else {
                        // Carousel for mobile value props
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 120.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            viewportFraction: 0.5, // Show 2 at a time or partial
                            enlargeCenterPage: true,
                          ),
                          items: _buildValuePropsList(context).map((w) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Center(child: w),
                                )).toList(),
                        );
                      }
                    },
                  ),
                ),

                // Featured Categories Section
                Container(
                  color: Colors.grey[50], // Puede quitarse el color si se prefiere blanco
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      _buildSectionHeader(context, 'CATEGORÍAS DESTACADAS', 'Encuentra el estilo perfecto para ti'),
                      const SizedBox(height: 30),
                      SingleChildScrollView( 
                        scrollDirection: Axis.horizontal, 
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeaturedCategory(context, 'Marcos Ópticos', Colors.blue[50]!, Icons.visibility, () => context.push('/catalog?category=opticos')),
                            const SizedBox(width: 25),
                            _buildFeaturedCategory(context, 'Lentes de Sol', Colors.orange[50]!, Icons.wb_sunny, () => context.push('/catalog?category=sol')),
                            const SizedBox(width: 25),
                            _buildFeaturedCategory(context, 'Infantil', Colors.purple[50]!, Icons.child_care, () => context.push('/catalog?category=ninos')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Operativos Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                       _buildSectionHeader(context, 'OPERATIVOS EN TU ZONA', 'Llevamos salud visual a tu comunidad'),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){}, child: const Text('Ver todos')),
                      ),
                      _buildOperativesList(context),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Testimonios
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildSectionHeader(context, 'LO QUE DICEN NUESTROS CLIENTES', 'La experiencia de cada uno de ellos'),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 180, // Altura fija para el scroll horizontal
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 15),
                          itemBuilder: (context, index) {
                            return _buildReviewCard(context, reviews[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Social Proof (Moved to Bottom)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                  child: Column(
                    children: [
                      _buildSectionHeader(context, 'EMPRESAS QUE CONFÍAN EN NOSOTROS', 'Alianzas estratégicas y corporativas'),
                      const SizedBox(height: 30),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 80,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          viewportFraction: 0.3, 
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true,
                        ),
                        items: partnerLogos.map((logo) => _buildCompanyLogo(logo)).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                _buildFooter(context),
                const SizedBox(height: 20), // Padding extra
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const url = 'https://wa.me/56944290263'; // Número actualizado
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
             await launchUrl(uri);
          } else {
            // Manejar error, tal vez mostrar un snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir WhatsApp')),
            );
          }
        },
        tooltip: 'Contactar por WhatsApp',
        backgroundColor: const Color(0xFF25D366), // WhatsApp Green
        child: const Icon(Icons.message, color: Colors.white, size: 30), // Icono más grande
      ),
    );
  }

  Widget _buildHeroImage(String imageUrl, String label, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent], // Darker gradient specifically for text readiness
          ),
        ),
        padding: const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 100), // Adjusted padding
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32, // Larger
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.1,
            color: Colors.black87
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCompanyLogo(String assetPath) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(assetPath, fit: BoxFit.contain), 
    );
  }

  Widget _buildOperativesList(BuildContext context) {
    final List<Map<String, dynamic>> operatives = [
      {
        'place': 'Junta de Vecinos Los Alerces',
        'location': 'Peñalolén',
        'date': '15 Oct',
        'time': '10:00 - 18:00',
        'status': 'Próximo',
        'color': Colors.green
      },
      {
        'place': 'Centro Cultural La Florida',
        'location': 'La Florida',
        'date': '22 Oct',
        'time': '09:00 - 14:00',
        'status': 'Próximo',
        'color': Colors.green
      },
       {
        'place': 'Empresa TechSolution',
        'location': 'Las Condes',
        'date': '05 Oct',
        'time': '09:00 - 17:00',
        'status': 'Realizado',
        'color': Colors.grey
      },
    ];

    return Column(
      children: operatives.map((op) {
        final bool isUpcoming = op['status'] == 'Próximo';

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Date Box
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: op['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(op['date'].split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: op['color'])),
                        Text(op['date'].split(' ')[1], style: TextStyle(fontSize: 12, color: op['color'])),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(op['place'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(op['location'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 10),
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(op['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Button
                  if (isUpcoming)
                    ElevatedButton(
                      onPressed: () async {
                        final place = op['place'];
                        final message = 'Hola quisiera tomar una hora para el operativo en $place';
                        final url = 'https://wa.me/56944290263?text=${Uri.encodeComponent(message)}';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Reservar', style: TextStyle(fontSize: 12)),
                    )
                  else
                    const Chip(label: Text('Finalizado', style: TextStyle(fontSize: 10))),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(review.userName[0], style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildValuePropsList(BuildContext context) {
    return [
      _buildValuePropItem(context, Icons.currency_exchange, 'PRECIOS', 'justos y con garantía'),
      _buildValuePropItem(context, Icons.local_shipping_outlined, 'ENVIO GRATIS', 'Por compras superior a \$100.000'),
      _buildValuePropItem(context, Icons.change_circle_outlined, 'GARANTÍAS', '1 año'),
      _buildValuePropItem(context, Icons.shield_outlined, 'PAGOS SEGUROS', '10 años en el mercado'),
      _buildValuePropItem(context, Icons.headset_mic_outlined, 'POST VENTA', 'atención por whatsapp'),
    ];
  }

  Widget _buildValuePropItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: Colors.grey[700]), // Gris oscuro como la foto
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 5),
        SizedBox(
          width: 120,
          child: Text(
            subtitle, 
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  // Deprecated: _buildValueProp removed in favor of _buildValuePropItem styling matching the image

  Widget _buildFeaturedCategory(BuildContext context, String title, Color color, IconData icon, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
             BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF1B5E20), // Dark Green matching app theme
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Su Óptica', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Huemul 12267', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('La Florida, Santiago', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: const [
              Icon(Icons.phone, color: Colors.white70, size: 20),
              SizedBox(width: 10),
              Text('+56 9 4429 0263', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: const [
              Icon(Icons.email, color: Colors.white70, size: 20),
              SizedBox(width: 10),
              Text('contacto@suoptica.cl', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white, size: 30), 
                onPressed: () async {
                  const url = 'https://web.facebook.com/profile.php?id=100031039042122';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                }
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30), // Instagram placeholder check
                onPressed: () async {
                  const url = 'https://www.instagram.com/_su.optica_/';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                }
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© 2024 Su Óptica. Todos los derechos reservados.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
