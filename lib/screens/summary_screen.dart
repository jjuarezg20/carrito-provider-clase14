import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../shared/theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = cart.selectedProducts;
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen de compra',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  wide ? 28 : 20,
                  24,
                  wide ? 28 : 20,
                  30,
                ),
                sliver: SliverList.list(
                  children: [
                    const _SummaryHero(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tus productos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${products.length} artículos',
                          style: const TextStyle(color: kMuted, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (final product in products) ...[
                      _SummaryProductRow(product: product),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    _TotalCard(total: cart.total, itemCount: products.length),
                    const SizedBox(height: 18),
                    const _SecureNote(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _CheckoutBottomBar(enabled: cart.canContinue),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F3864), Color(0xFF345583)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.shopping_bag_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Buena elección!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Revisa tu selección antes de pagar.',
                  style: TextStyle(color: Color(0xFFDCE6F6), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFFB7E5D0),
            size: 25,
          ),
        ],
      ),
    );
  }
}

class _SummaryProductRow extends StatelessWidget {
  final Product product;
  const _SummaryProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(product.icon, color: kNavy, size: 25),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: kMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            formatUsd(product.price),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double total;
  final int itemCount;
  const _TotalCard({required this.total, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        children: [
          _AmountLine(label: 'Productos ($itemCount)', amount: total),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total a pagar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                formatUsd(total),
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: kNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  final String label;
  final double amount;
  const _AmountLine({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: kMuted, fontSize: 13),
          ),
        ),
        Text(
          formatUsd(amount),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ],
    );
  }
}

class _SecureNote extends StatelessWidget {
  const _SecureNote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline_rounded, size: 15, color: kMuted),
        SizedBox(width: 7),
        Text(
          'Tu compra de demostración es segura',
          style: TextStyle(color: kMuted, fontSize: 12),
        ),
      ],
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  final bool enabled;
  const _CheckoutBottomBar({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7EAF0))),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: enabled
                      ? () {
                          final paidTotal = context.read<CartProvider>().total;
                          showDialog<void>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              icon: const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF18845A),
                                size: 42,
                              ),
                              title: const Text('¡Compra confirmada!'),
                              content: Text(
                                'Tu pago por ${formatUsd(paidTotal)} se realizó correctamente.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('Listo'),
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: const Text('Proceder a pagar'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
