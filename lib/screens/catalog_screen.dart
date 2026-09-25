import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../shared/theme.dart';
import 'summary_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const _Brand(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _SelectionBadge(count: cart.selectedCount),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 28 : 20,
                    22,
                    wide ? 28 : 20,
                    8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Eyebrow(label: 'CATÁLOGO · 6 PRODUCTOS'),
                      const SizedBox(height: 12),
                      Text(
                        'Elige tus tres favoritos',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                            ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Selecciona exactamente 3 productos para preparar tu compra.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: kMuted),
                      ),
                      const SizedBox(height: 22),
                      _SelectionProgress(count: cart.selectedCount),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              wide ? 28 : 20,
              12,
              wide ? 28 : 20,
              28,
            ),
            sliver: SliverGrid.builder(
              itemCount: Product.catalog.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 390,
                mainAxisExtent: 226,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = Product.catalog[index];
                return _ProductCard(
                  product: product,
                  selected: cart.isSelected(product.id),
                  onTap: () {
                    final updated =
                        context.read<CartProvider>().toggleProduct(product.id);
                    if (!updated) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ya elegiste 3 productos. Quita uno para hacer un cambio.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _CatalogBottomBar(
        count: cart.selectedCount,
        canContinue: cart.canContinue,
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: kNavy,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Mercado 14',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ],
    );
  }
}

class _SelectionBadge extends StatelessWidget {
  final int count;
  const _SelectionBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 17, color: kNavy),
          const SizedBox(width: 7),
          Text(
            '$count / 3',
            style: const TextStyle(fontWeight: FontWeight.w700, color: kNavy),
          ),
        ],
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String label;
  const _Eyebrow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kNavySoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kNavy,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _SelectionProgress extends StatelessWidget {
  final int count;
  const _SelectionProgress({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count de 3 seleccionados',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: count / CartProvider.selectionLimit,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE9EDF3),
                    color: kAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            count == CartProvider.selectionLimit
                ? Icons.check_circle_rounded
                : Icons.touch_app_rounded,
            color: count == CartProvider.selectionLimit
                ? const Color(0xFF18845A)
                : kMuted,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool selected;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? kNavy : const Color(0xFFE7EAF0);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F4FA) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(product.icon, color: kNavy, size: 28),
                  ),
                  const Spacer(),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.add_circle_outline_rounded,
                    color: selected ? kNavy : const Color(0xFF9AA3B0),
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kMuted, fontSize: 13),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    formatUsd(product.price),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    selected ? 'Seleccionado' : 'Agregar',
                    style: TextStyle(
                      color: selected ? kNavy : kMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogBottomBar extends StatelessWidget {
  final int count;
  final bool canContinue;

  const _CatalogBottomBar({required this.count, required this.canContinue});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 600;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7EAF0))),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count de 3 productos',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          canContinue
                              ? 'Tu selección está lista'
                              : 'Elige ${3 - count} más para continuar',
                          style: const TextStyle(color: kMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: wide ? 230 : 154,
                    child: ElevatedButton.icon(
                      onPressed: canContinue
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const SummaryScreen(),
                                ),
                              )
                          : null,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                      label: Text(wide ? 'Ver resumen' : 'Continuar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
