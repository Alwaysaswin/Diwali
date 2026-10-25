import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 400;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scaleByDouble(_isHovered && isDesktop ? 1.02 : 1.0, _isHovered && isDesktop ? 1.02 : 1.0, _isHovered && isDesktop ? 1.02 : 1.0, 1.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: _isHovered && isDesktop ? 8 : 2,
              child: InkWell(
                onTap: widget.onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF5722).withValues(alpha: 0.1),
                            const Color(0xFFFFB300).withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.local_fire_department,
                              size: 48,
                              color: const Color(0xFFFF5722).withValues(alpha: 0.7),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.product.isGreenCracker
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF64748B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.product.isGreenCracker ? 'GREEN' : 'REGULAR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5722),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${widget.product.discountPercent}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.product.category,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  widget.product.safetyType == 'Kids Safe'
                                      ? Icons.child_care
                                      : widget.product.safetyType == 'Night Aerial'
                                          ? Icons.nightlight
                                          : Icons.wb_sunny,
                                  size: 12,
                                  color: const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.product.safetyType,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.product.packContent,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${widget.product.price.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF5722),
                                      ),
                                    ),
                                    Text(
                                      '₹${widget.product.mrp.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                widget.quantity == 0
                                    ? ElevatedButton(
                                        onPressed: widget.onAdd,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          minimumSize: const Size(50, 28),
                                        ),
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFFF5722)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: widget.onDecrement,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 14,
                                                  color: Color(0xFFFF5722),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '${widget.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  color: Color(0xFFFF5722),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: widget.onIncrement,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
