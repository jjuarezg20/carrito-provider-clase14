import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';
import 'shared/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const CarritoApp(),
    ),
  );
}

class CarritoApp extends StatelessWidget {
  const CarritoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Clase 14 · Carrito Provider',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const CatalogScreen(),
    );
  }
}
