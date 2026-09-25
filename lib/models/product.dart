import 'package:flutter/material.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });

  static const catalog = <Product>[
    Product(
      id: 'headphones',
      name: 'Audífonos Nova',
      description: 'Sonido nítido para cada momento.',
      price: 29.99,
      icon: Icons.headphones_rounded,
      color: Color(0xFFE9EAFE),
    ),
    Product(
      id: 'bottle',
      name: 'Botella térmica',
      description: 'Acero inoxidable · 600 ml.',
      price: 18.50,
      icon: Icons.water_drop_rounded,
      color: Color(0xFFE3F4F1),
    ),
    Product(
      id: 'notebook',
      name: 'Libreta A5',
      description: 'Tapa dura para tus ideas.',
      price: 8.00,
      icon: Icons.menu_book_rounded,
      color: Color(0xFFFFF1DD),
    ),
    Product(
      id: 'backpack',
      name: 'Mochila urbana',
      description: 'Práctica, ligera y lista para salir.',
      price: 42.00,
      icon: Icons.backpack_rounded,
      color: Color(0xFFFCE8E5),
    ),
    Product(
      id: 'lamp',
      name: 'Lámpara de mesa',
      description: 'Luz cálida con diseño compacto.',
      price: 23.75,
      icon: Icons.light_rounded,
      color: Color(0xFFFFF4D6),
    ),
    Product(
      id: 'charger',
      name: 'Cargador rápido',
      description: 'Carga USB-C de 30 W.',
      price: 16.90,
      icon: Icons.bolt_rounded,
      color: Color(0xFFE7F0FF),
    ),
  ];
}

String formatUsd(double value) => '\$${value.toStringAsFixed(2)}';
