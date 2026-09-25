import 'package:flutter/material.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final int price;
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
      id: 'backpack',
      name: 'Mochila Urbana Oxford',
      description: 'Resistente al agua, 20L',
      price: 45000,
      icon: Icons.backpack_rounded,
      color: Color(0xFFE9EDF2),
    ),
    Product(
      id: 'headphones',
      name: 'Audífonos Inalámbricos Pro',
      description: 'Cancelación activa de ruido',
      price: 65000,
      icon: Icons.headphones_rounded,
      color: Color(0xFFE6EAF0),
    ),
    Product(
      id: 'watch',
      name: 'Reloj Inteligente Fit Track',
      description: 'Pulso y GPS dual',
      price: 89000,
      icon: Icons.watch_rounded,
      color: Color(0xFFE9EDF2),
    ),
    Product(
      id: 'thermos',
      name: 'Termo de Acero Inoxidable',
      description: 'Aislamiento térmico 24h',
      price: 22500,
      icon: Icons.thermostat_rounded,
      color: Color(0xFFE9EDF2),
    ),
    Product(
      id: 'sunglasses',
      name: 'Lentes de Sol Polarizados',
      description: 'Protección UV400 completa',
      price: 34000,
      icon: Icons.remove_red_eye_rounded,
      color: Color(0xFFE9EDF2),
    ),
  ];
}

String formatMoney(int value) {
  final digits = value.toString();
  final grouped = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      grouped.write('.');
    }
    grouped.write(digits[index]);
  }
  return '\$${grouped.toString()}';
}
