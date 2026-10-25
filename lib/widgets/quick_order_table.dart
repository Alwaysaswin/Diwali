import 'package:flutter/material.dart';
import '../models/product.dart';

class QuickOrderTable extends StatelessWidget {
  final List<Product> products;
  final Map<String, int> quantities;
  final Function(Product) onIncrement;
  final Function(Product) onDecrement;
  final Function(Product) onViewDetails;

  const QuickOrderTable({
    super.key,
    required this.products,
    required this.quantities,
    required this.onIncrement,
    required this.onDecrement,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Group products by category
    Map<String, List<Product>> grouped = {};
    for (var product in products) {
      if (!grouped.containsKey(product.category)) {
        grouped[product.category] = [];
      }
      grouped[product.category]!.add(product);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5722),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Product',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Pack',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'MRP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Price',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Qty',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rows
                    ...entry.value.asMap().entries.map((rowEntry) {
                      final product = rowEntry.value;
                      final qty = quantities[product.id] ?? 0;
                      final isLast = rowEntry.key == entry.value.length - 1;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: isLast
                                ? BorderSide.none
                                : const BorderSide(color: Color(0xFFF1F5F9)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () => onViewDetails(product),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: product.isGreenCracker
                                                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(3),
                                            border: product.isGreenCracker
                                                ? Border.all(
                                                    color: const Color(0xFF10B981),
                                                    width: 0.5,
                                                  )
                                                : null,
                                          ),
                                          child: Text(
                                            product.isGreenCracker ? '🌱' : '',
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xFF0F172A),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      product.safetyType,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                product.packContent,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '₹${product.mrp.toInt()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: Color(0xFF94A3B8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    '₹${product.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF5722),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '-${product.discountPercent}%',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () => onDecrement(product),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.remove,
                                            size: 14,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          '$qty',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => onIncrement(product),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.add,
                                            size: 14,
                                            color: Color(0xFFFF5722),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                qty > 0 ? '₹${(product.price * qty).toInt()}' : '-',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: qty > 0 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
