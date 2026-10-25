import 'package:flutter/material.dart';
import '../state/cart_controller.dart';
import 'checkout_dialog.dart';

class CartDrawer extends StatelessWidget {
  final CartController cartController;
  final VoidCallback onClose;

  const CartDrawer({
    super.key,
    required this.cartController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cartController,
      builder: (context, child) {
        return Container(
          width: 400,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Color(0xFFFF5722)),
                    const SizedBox(width: 8),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${cartController.itemCount} items',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              // Items
              Expanded(
                child: cartController.items.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Color(0xFFCBD5E1),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add some crackers to get started',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: cartController.items.length,
                        itemBuilder: (context, index) {
                          final item = cartController.items[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFFF5722).withValues(alpha: 0.1),
                                          const Color(0xFFFFB300).withValues(alpha: 0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.local_fire_department,
                                      color: Color(0xFFFF5722),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF0F172A),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.product.packContent,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${item.product.price.toInt()}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF5722),
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '₹${item.product.mrp.toInt()}',
                                              style: const TextStyle(
                                                decoration: TextDecoration.lineThrough,
                                                color: Color(0xFF94A3B8),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => cartController.removeFromCart(item.product),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: Color(0xFF64748B),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => cartController.addToCart(item.product),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: Color(0xFFFF5722),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${(item.product.price * item.quantity).toInt()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // Summary
              if (cartController.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Minimum Order Progress
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cartController.meetsMinimumOrder
                              ? const Color(0xFF10B981).withValues(alpha: 0.1)
                              : const Color(0xFFFFB300).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: cartController.meetsMinimumOrder
                                ? const Color(0xFF10B981)
                                : const Color(0xFFFFB300),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  cartController.meetsMinimumOrder
                                      ? Icons.check_circle
                                      : Icons.info,
                                  color: cartController.meetsMinimumOrder
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFFFB300),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    cartController.meetsMinimumOrder
                                        ? 'Minimum order met!'
                                        : 'Add ₹${(cartController.minimumOrderThreshold - cartController.netTotal).toInt()} more for minimum order',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: cartController.meetsMinimumOrder
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFFFB300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: cartController.progressToMinimum,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  cartController.meetsMinimumOrder
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFFFB300),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow('MRP Total', '₹${cartController.mrpTotal.toInt()}', false),
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        'Festive Discount',
                        '-₹${cartController.discountTotal.toInt()}',
                        true,
                        color: const Color(0xFF10B981),
                      ),
                      const Divider(height: 16),
                      _buildSummaryRow(
                        'Net Payable',
                        '₹${cartController.netTotal.toInt()}',
                        false,
                        isBold: true,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cartController.meetsMinimumOrder
                              ? () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) => CheckoutDialog(
                                      cartController: cartController,
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDiscount, {
    Color? color,
    bool isBold = false,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: color ?? const Color(0xFF475569),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: color ?? const Color(0xFF0F172A),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
