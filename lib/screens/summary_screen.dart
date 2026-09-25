import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../shared/app_frame.dart';
import '../shared/theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = cart.selectedProducts;

    return AppFrame(
      toolbar: ShopToolbar(
        title: 'Resumen de compra',
        itemCount: cart.selectedCount,
        showBack: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StepBanner(itemCount: products.length),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Productos seleccionados',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      'Revisar detalles',
                      style: TextStyle(fontSize: 9, color: kMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final product in products) ...[
                  _SummaryProductRow(product: product),
                  const SizedBox(height: 7),
                ],
                const SizedBox(height: 4),
                _PaymentBreakdown(total: cart.total),
                const SizedBox(height: 10),
                const _SecureNote(),
              ]),
            ),
          ),
        ],
      ),
      footer: _CheckoutFooter(
        total: cart.total,
        itemCount: cart.selectedCount,
      ),
    );
  }
}

class _StepBanner extends StatelessWidget {
  final int itemCount;

  const _StepBanner({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: kLine),
      ),
      child: Row(
        children: [
          Container(
            width: 23,
            height: 23,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: kNavy, shape: BoxShape.circle),
            child: const Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Paso final: Verificación',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
          _CountPill(label: '$itemCount artículos'),
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
        borderRadius: BorderRadius.circular(10),
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

class _SummaryProductRow extends StatelessWidget {
  final Product product;

  const _SummaryProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: kLine),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(product.icon, color: kNavy, size: 24),
          ),
          const SizedBox(width: 9),
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
                      fontSize: 10, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Cantidad: 1x',
                  style: TextStyle(fontSize: 9, color: kMuted),
                ),
                const SizedBox(height: 3),
                Text(
                  formatMoney(product.price),
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdown extends StatelessWidget {
  final int total;

  const _PaymentBreakdown({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: kLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Desglose de pago',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
          const Divider(height: 13),
          _AmountLine(label: 'Subtotal', amount: total),
          const SizedBox(height: 6),
          const _LabelValueLine(
              label: 'Envío estándar', value: 'Gratis', positive: true),
          const SizedBox(height: 6),
          const _LabelValueLine(label: 'Impuestos incluidos', value: '\$0'),
          const Divider(height: 16),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800)),
                    Text('IVA incluido',
                        style: TextStyle(fontSize: 8, color: kMuted)),
                  ],
                ),
              ),
              Text(
                formatMoney(total),
                style: const TextStyle(
                  color: kAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
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
  final int amount;

  const _AmountLine({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return _LabelValueLine(label: label, value: formatMoney(amount));
  }
}

class _LabelValueLine extends StatelessWidget {
  final String label;
  final String value;
  final bool positive;

  const _LabelValueLine({
    required this.label,
    required this.value,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              Text(label, style: const TextStyle(fontSize: 9, color: kMuted)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            color: positive ? kGreen : kInk,
            fontWeight: positive ? FontWeight.w700 : FontWeight.w500,
          ),
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
        Icon(Icons.shield_outlined, size: 12, color: kMuted),
        SizedBox(width: 5),
        Flexible(
          child: Text(
            'Transacción protegida con cifrado bancario de 256 bits',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8, color: kMuted),
          ),
        ),
      ],
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  final int total;
  final int itemCount;

  const _CheckoutFooter({required this.total, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kLine)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total final',
                      style: TextStyle(fontSize: 9, color: kMuted),
                    ),
                    Text(
                      formatMoney(total),
                      style: const TextStyle(
                        color: kAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Envío bonificado',
                  style: TextStyle(
                      color: kGreen, fontSize: 8, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () {
                final cart = context.read<CartProvider>();
                final paidTotal = cart.total;
                final paidCount = cart.selectedCount;
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => _PurchaseSuccessDialog(
                    total: paidTotal,
                    itemCount: paidCount,
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Proceder a pagar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseSuccessDialog extends StatelessWidget {
  final int total;
  final int itemCount;

  const _PurchaseSuccessDialog({required this.total, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF4EA),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_circle_rounded, color: kGreen, size: 25),
      ),
      title: const Text(
        '¡Compra exitosa!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tu pedido ha sido confirmado correctamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: kMuted),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F9),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: kLine),
            ),
            child: Column(
              children: [
                const Text(
                  'MONTO TOTAL PAGADO',
                  style:
                      TextStyle(fontSize: 8, color: kMuted, letterSpacing: 0.5),
                ),
                const SizedBox(height: 3),
                Text(
                  formatMoney(total),
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$itemCount productos comprados',
                  style: const TextStyle(fontSize: 9, color: kMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          const Text(
            'Te enviaremos la factura electrónica y el código de seguimiento a tu correo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: kMuted, height: 1.4),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ),
      ],
    );
  }
}
