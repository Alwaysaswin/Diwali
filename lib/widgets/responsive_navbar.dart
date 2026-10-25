import 'package:flutter/material.dart';

class ResponsiveNavbar extends StatefulWidget {
  final VoidCallback onCartPressed;
  final ValueChanged<String> onSearchChanged;
  final int cartItemCount;
  final bool showSearchField;
  final VoidCallback onSearchToggle;

  const ResponsiveNavbar({
    super.key,
    required this.onCartPressed,
    required this.onSearchChanged,
    required this.cartItemCount,
    required this.showSearchField,
    required this.onSearchToggle,
  });

  @override
  State<ResponsiveNavbar> createState() => _ResponsiveNavbarState();
}

class _ResponsiveNavbarState extends State<ResponsiveNavbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        // final isDesktop = constraints.maxWidth >= 1024;

        if (isMobile) {
          return AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: const Color(0xFFE2E8F0),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFFF5722),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'SparkCart',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF475569)),
                onPressed: widget.onSearchToggle,
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Color(0xFF475569)),
                    onPressed: widget.onCartPressed,
                  ),
                  if (widget.cartItemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5722),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${widget.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            bottom: widget.showSearchField
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: widget.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search crackers...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFF5722)),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        } else if (isTablet) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFFF5722),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SparkCart Crackers',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: widget.onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: 'Search for crackers, gift boxes...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    ElevatedButton.icon(
                      onPressed: widget.onCartPressed,
                      icon: const Icon(Icons.shopping_cart),
                      label: Text('Cart (${widget.cartItemCount})'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          // Desktop
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFF5722),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SparkCart Crackers',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Diwali Mega Sale Store',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.onSearchChanged,
                          decoration: const InputDecoration(
                            hintText: 'Search for crackers, sparkles, gift boxes...',
                            prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Stack(
                      children: [
                        ElevatedButton.icon(
                          onPressed: widget.onCartPressed,
                          icon: const Icon(Icons.shopping_cart),
                          label: Text('Cart (${widget.cartItemCount})'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
