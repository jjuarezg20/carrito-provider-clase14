import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../shared/app_frame.dart';
import '../shared/theme.dart';
import 'summary_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return AppFrame(
      toolbar: ShopToolbar(
        title: 'Catálogo',
        itemCount: cart.selectedCount,
        onCartPressed: cart.canContinue
            ? () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const SummaryScreen(),
                  ),
                )
            : null,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SelectionProgress(count: cart.selectedCount),
                const SizedBox(height: 10),
                for (final product in Product.catalog) ...[
                  _ProductTile(
                    product: product,
                    selected: cart.isSelected(product.id),
                    onTap: () {
                      final updated = context
                          .read<CartProvider>()
                          .toggleProduct(product.id);
                      if (!updated) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ya elegiste 3 productos. Quita uno para cambiar tu selección.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      }
                    },
                  ),
                  const SizedBox(height: 7),
                ],
                const _BundleNote(),
              ]),
            ),
          ),
        ],
      ),
      footer: _CatalogFooter(
        count: cart.selectedCount,
        canContinue: cart.canContinue,
      ),
    );
  }
}

class _SelectionProgress extends StatelessWidget {
  final int count;

  const _SelectionProgress({required this.count});

  @override
  Widget build(BuildContext context) {
    final remaining = CartProvider.selectionLimit - count;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: kLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF0FA),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.checklist_rounded, size: 15, color: kNavy),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$count de 3 productos seleccionados',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _CountPill(label: count == 3 ? 'Listo' : 'Falta $remaining'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: count / CartProvider.selectionLimit,
              minHeight: 4,
              backgroundColor: const Color(0xFFE7EAF0),
              color: kNavy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: kMuted),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  count == 3
                      ? 'Tu selección ya está lista para revisar.'
                      : 'Selecciona ${remaining == 1 ? 'un artículo más' : '$remaining artículos más'} para desbloquear la orden combinada.',
                  style: const TextStyle(
                      fontSize: 10, color: kMuted, height: 1.25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  final String label;

  const _CountPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kAccent,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final bool selected;
  final VoidCallback onTap;

  const _ProductTile({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFFB8C7E4) : kLine,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: product.color,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(product.icon, color: kNavy, size: 27),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9, color: kMuted),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatMoney(product.price),
                      style: const TextStyle(
                        color: kAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: selected ? kNavy : const Color(0xFF9DA5B1),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BundleNote extends StatelessWidget {
  const _BundleNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: kLine),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, color: kNavy, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Al elegir 3 artículos se activa el envío sin costo y la garantía directa de fábrica.',
              style: TextStyle(fontSize: 9, color: kMuted, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogFooter extends StatelessWidget {
  final int count;
  final bool canContinue;

  const _CatalogFooter({required this.count, required this.canContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 7),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kLine)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: canContinue
                  ? () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const SummaryScreen(),
                        ),
                      )
                  : null,
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: const Text('Continuar'),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                canContinue ? Icons.check_circle_outline : Icons.lock_outline,
                size: 11,
                color: canContinue ? kGreen : kMuted,
              ),
              const SizedBox(width: 4),
              Text(
                canContinue
                    ? '$count productos listos para continuar'
                    : 'Selecciona 3 productos para continuar',
                style: const TextStyle(fontSize: 9, color: kMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
