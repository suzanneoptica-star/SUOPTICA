
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Descomentar cuando se genere
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
// import 'screens/operative_request_screen.dart'; // Deprecated
import 'screens/my_orders_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/checkout_screen.dart';
import 'models/order.dart';
import 'providers/cart_provider.dart';
import 'screens/visual_health_screen.dart';
import 'screens/product_detail_screen.dart';
import 'models/product.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/contact_screen.dart';
import 'widgets/responsive_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ); // Todo: Configurar Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SuOpticaApp(),
    ),
  );
}

// Nueva definición de router con Guards
final _routerWithGuards = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveShell(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/catalog', builder: (context, state) => const CatalogScreen()),
        // Merge Operative Request into Contact Screen
        GoRoute(
          path: '/operative-request', 
          redirect: (context, state) => '/contact?type=operative',
        ), 
        GoRoute(
          path: '/contact', 
          builder: (context, state) {
            final type = state.uri.queryParameters['type'];
            return ContactScreen(initialOperativeRequest: type == 'operative');
          }
        ),
        
         GoRoute(
          path: '/product-detail',
          builder: (context, state) {
            final product = state.extra as Product;
            return ProductDetailScreen(product: product);
          },
        ),

        // Protected Routes
        GoRoute(
          path: '/orders',
          builder: (context, state) => const MyOrdersScreen(),
          redirect: (context, state) {
             final auth = Provider.of<AuthProvider>(context, listen: false);
             if (!auth.isLoggedIn) return '/login?redirect=/orders';
             return null;
          }
        ),
        GoRoute(
          path: '/visual-health',
          builder: (context, state) => const VisualHealthScreen(),
           redirect: (context, state) {
             final auth = Provider.of<AuthProvider>(context, listen: false);
             if (!auth.isLoggedIn) return '/login?redirect=/visual-health';
             return null;
          }
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
           redirect: (context, state) {
             final auth = Provider.of<AuthProvider>(context, listen: false);
             if (!auth.isLoggedIn) return '/login?redirect=/checkout';
             return null;
          }
        ),
         GoRoute(
          path: '/order-detail',
          builder: (context, state) {
            final order = state.extra as Order;
            return OrderDetailScreen(order: order);
          },
        ),
      ],
    ),
    
    // Login fuera del shell (o dentro, decisión de diseño. Fuera para "focus")
    GoRoute(
      path: '/login',
      builder: (context, state) {
         final redirect = state.uri.queryParameters['redirect'];
         return LoginScreen(redirectLocation: redirect);
      },
    ),
  ],
);

class SuOpticaApp extends StatelessWidget {
  const SuOpticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Su Óptica',
      theme: SuOpticaTheme.themeData,
      routerConfig: _routerWithGuards,
      debugShowCheckedModeBanner: false,
    );
  }
}
