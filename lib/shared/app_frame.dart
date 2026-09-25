import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

class AppFrame extends StatelessWidget {
  final Widget toolbar;
  final Widget body;
  final Widget footer;

  const AppFrame({
    super.key,
    required this.toolbar,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackdrop,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 560;
            final frameWidth = math.min(constraints.maxWidth, 430.0);

            return Center(
              child: Container(
                width: frameWidth,
                height: constraints.maxHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isWide ? 14 : 0),
                  boxShadow: isWide
                      ? const [
                          BoxShadow(
                            color: Color(0x260E1A32),
                            blurRadius: 26,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : const [],
                ),
                child: Column(
                  children: [
                    toolbar,
                    Expanded(child: body),
                    footer,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShopToolbar extends StatelessWidget {
  final String title;
  final int itemCount;
  final bool showBack;
  final VoidCallback? onCartPressed;

  const ShopToolbar({
    super.key,
    required this.title,
    required this.itemCount,
    this.showBack = false,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: kNavy,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              tooltip: 'Volver al catálogo',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
            )
          else
            const SizedBox(
              width: 44,
              child: Icon(Icons.menu_rounded, color: Colors.white, size: 22),
            ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Carrito: $itemCount productos',
            onPressed: onCartPressed,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 21),
                Positioned(
                  top: -6,
                  right: -7,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 16),
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: kAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
