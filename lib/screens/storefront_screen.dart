import 'package:flutter/material.dart';
import '../data/mock_crackers.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../services/api_service.dart';
import '../widgets/responsive_navbar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/quick_order_table.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/product_detail_dialog.dart';
import '../widgets/checkout_dialog.dart';
import '../widgets/footer.dart';

class StorefrontScreen extends StatefulWidget {
  final CartController cartController;

  const StorefrontScreen({
    super.key,
    required this.cartController,
  });

  @override
  State<StorefrontScreen> createState() => _StorefrontScreenState();
}

class _StorefrontScreenState extends State<StorefrontScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showKidsSafeOnly = false;
  bool _showNightAerialOnly = false;
  bool _showGiftBoxesOnly = false;
  String _sortBy = 'popularity';
  bool _isQuickOrderMode = false;
  bool _showMobileSearch = false;
  final ScrollController _scrollController = ScrollController();
  
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _usingMockData = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        ApiService.fetchCategories(),
        ApiService.fetchProducts(),
      ]);

      setState(() {
        _categories = results[0] as List<Category>;
        _products = results[1] as List<Product>;
        _usingMockData = false;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        _products = MockCrackers.products;
        _categories = MockCrackers.categories
            .where((c) => c != 'All')
            .map((name) => Category(
                  id: name.toLowerCase().replaceAll(' ', '_'),
                  name: name,
                  icon: '',
                  displayOrder: 0,
                ))
            .toList();
        _usingMockData = true;
        _isLoading = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    List<Product> products = List.from(_products.isEmpty ? MockCrackers.products : _products);

    // Category filter
    if (_selectedCategory != 'All') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Quick toggles
    if (_showKidsSafeOnly) {
      products = products.where((p) => p.safetyType == 'Kids Safe').toList();
    }
    if (_showNightAerialOnly) {
      products = products.where((p) => p.safetyType == 'Night Aerial').toList();
    }
    if (_showGiftBoxesOnly) {
      products = products.where((p) => p.isGiftBox).toList();
    }

    // Sort
    if (_sortBy == 'price_low') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_high') {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'popularity') {
      products.sort((a, b) => b.popularity.compareTo(a.popularity));
    }

    return products;
  }

  void _showCartDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.cartController,
                builder: (context, child) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
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
                              '${widget.cartController.itemCount} items',
                              style: const TextStyle(color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: widget.cartController.items.isEmpty
                            ? const Center(
                                child: Text('Your cart is empty'),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: widget.cartController.items.length,
                                itemBuilder: (context, index) {
                                  final item = widget.cartController.items[index];
                                  return ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF5722).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.local_fire_department, color: Color(0xFFFF5722)),
                                    ),
                                    title: Text(
                                      item.product.name,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text('₹${item.product.price} x ${item.quantity}'),
                                    trailing: Text(
                                      '₹${(item.product.price * item.quantity).toInt()}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (widget.cartController.items.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Net Payable:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    '₹${widget.cartController.netTotal.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFFFF5722),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: widget.cartController.meetsMinimumOrder
                                      ? () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) => CheckoutDialog(
                                              cartController: widget.cartController,
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text('Proceed to Checkout'),
                                ),
                              ),
                              if (!widget.cartController.meetsMinimumOrder)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Min order ₹${widget.cartController.minimumOrderThreshold.toInt()}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailDialog(product: product),
    );
  }

  void _scrollToComboPacks() {
    setState(() {
      _selectedCategory = 'Family Gift Boxes';
      _showGiftBoxesOnly = true;
    });
    // Scroll to products section
    _scrollController.animateTo(
      400,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListenableBuilder(
        listenable: widget.cartController,
        builder: (context, child) {
          return Column(
            children: [
              ResponsiveNavbar(
                onCartPressed: () {
                  final width = MediaQuery.of(context).size.width;
                  if (width >= 1024) {
                    // Show drawer on desktop - we'll handle with overlay
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Cart',
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: CartDrawer(
                            cartController: widget.cartController,
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    );
                  } else {
                    _showCartDrawer(context);
                  }
                },
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                cartItemCount: widget.cartController.itemCount,
                showSearchField: _showMobileSearch,
                onSearchToggle: () {
                  setState(() {
                    _showMobileSearch = !_showMobileSearch;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Hero Banner
                      HeroBanner(onComboPackTap: _scrollToComboPacks),
                      
                      // Centered Container for Web
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isLoading)
                                const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5722)),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Loading products...',
                                          style: TextStyle(color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_usingMockData)
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFF59E0B)),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'API server offline - using demo data',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF92400E),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              // Filter and Controls Section
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final isDesktop = constraints.maxWidth >= 1024;
                                        
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Our Products',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (isDesktop)
                                                  Row(
                                                    children: [
                                                      const Text('View: ', style: TextStyle(color: Color(0xFF475569))),
                                                      ToggleButtons(
                                                        isSelected: [!_isQuickOrderMode, _isQuickOrderMode],
                                                        onPressed: (index) {
                                                          setState(() {
                                                            _isQuickOrderMode = index == 1;
                                                          });
                                                        },
                                                        borderRadius: BorderRadius.circular(8),
                                                        selectedColor: Colors.white,
                                                        fillColor: const Color(0xFFFF5722),
                                                        color: const Color(0xFF475569),
                                                        constraints: const BoxConstraints(minHeight: 36, minWidth: 110),
                                                        children: const [
                                                          Text('Catalog Grid'),
                                                          Text('Quick Price List'),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 16),
                                                      DropdownButton<String>(
                                                        value: _sortBy,
                                                        items: const [
                                                          DropdownMenuItem(value: 'popularity', child: Text('Popularity')),
                                                          DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                                                          DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _sortBy = value!;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            // Category Chips
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8),
                                                    child: FilterChip(
                                                      label: const Text('All'),
                                                      selected: _selectedCategory == 'All',
                                                      onSelected: (selected) {
                                                        setState(() {
                                                          _selectedCategory = 'All';
                                                        });
                                                      },
                                                      selectedColor: const Color(0xFFFF5722).withValues(alpha: 0.2),
                                                      checkmarkColor: const Color(0xFFFF5722),
                                                      labelStyle: TextStyle(
                                                        color: _selectedCategory == 'All' ? const Color(0xFFFF5722) : const Color(0xFF475569),
                                                        fontWeight: _selectedCategory == 'All' ? FontWeight.w600 : FontWeight.normal,
                                                      ),
                                                      side: BorderSide(
                                                        color: _selectedCategory == 'All' ? const Color(0xFFFF5722) : const Color(0xFFE2E8F0),
                                                      ),
                                                    ),
                                                  ),
                                                  ...(_categories.isNotEmpty
                                                      ? _categories.map((category) {
                                                          final isSelected = _selectedCategory == category.name;
                                                          return Padding(
                                                            padding: const EdgeInsets.only(right: 8),
                                                            child: FilterChip(
                                                              label: Text(category.name),
                                                              selected: isSelected,
                                                              onSelected: (selected) {
                                                                setState(() {
                                                                  _selectedCategory = category.name;
                                                                  if (category.name != 'Family Gift Boxes') {
                                                                    _showGiftBoxesOnly = false;
                                                                  }
                                                                });
                                                              },
                                                              selectedColor: const Color(0xFFFF5722).withValues(alpha: 0.2),
                                                              checkmarkColor: const Color(0xFFFF5722),
                                                              labelStyle: TextStyle(
                                                                color: isSelected ? const Color(0xFFFF5722) : const Color(0xFF475569),
                                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                              ),
                                                              side: BorderSide(
                                                                color: isSelected ? const Color(0xFFFF5722) : const Color(0xFFE2E8F0),
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                      : MockCrackers.categories.where((c) => c != 'All').map((category) {
                                                          final isSelected = _selectedCategory == category;
                                                          return Padding(
                                                            padding: const EdgeInsets.only(right: 8),
                                                            child: FilterChip(
                                                              label: Text(category),
                                                              selected: isSelected,
                                                              onSelected: (selected) {
                                                                setState(() {
                                                                  _selectedCategory = category;
                                                                  if (category != 'Family Gift Boxes') {
                                                                    _showGiftBoxesOnly = false;
                                                                  }
                                                                });
                                                              },
                                                              selectedColor: const Color(0xFFFF5722).withValues(alpha: 0.2),
                                                              checkmarkColor: const Color(0xFFFF5722),
                                                              labelStyle: TextStyle(
                                                                color: isSelected ? const Color(0xFFFF5722) : const Color(0xFF475569),
                                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                              ),
                                                              side: BorderSide(
                                                                color: isSelected ? const Color(0xFFFF5722) : const Color(0xFFE2E8F0),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            // Quick Toggles
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                FilterChip(
                                                  label: const Text('Kids Safe Only'),
                                                  selected: _showKidsSafeOnly,
                                                  onSelected: (selected) {
                                                    setState(() {
                                                      _showKidsSafeOnly = selected;
                                                    });
                                                  },
                                                  selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                                                  checkmarkColor: const Color(0xFF10B981),
                                                  avatar: const Icon(Icons.child_care, size: 16),
                                                  labelStyle: TextStyle(
                                                    color: _showKidsSafeOnly ? const Color(0xFF10B981) : const Color(0xFF475569),
                                                  ),
                                                ),
                                                FilterChip(
                                                  label: const Text('Night Sky Shots'),
                                                  selected: _showNightAerialOnly,
                                                  onSelected: (selected) {
                                                    setState(() {
                                                      _showNightAerialOnly = selected;
                                                    });
                                                  },
                                                  selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                                                  checkmarkColor: const Color(0xFF6366F1),
                                                  avatar: const Icon(Icons.nightlight, size: 16),
                                                  labelStyle: TextStyle(
                                                    color: _showNightAerialOnly ? const Color(0xFF6366F1) : const Color(0xFF475569),
                                                  ),
                                                ),
                                                FilterChip(
                                                  label: const Text('Combo Gift Boxes'),
                                                  selected: _showGiftBoxesOnly,
                                                  onSelected: (selected) {
                                                    setState(() {
                                                      _showGiftBoxesOnly = selected;
                                                      if (selected) {
                                                        _selectedCategory = 'Family Gift Boxes';
                                                      }
                                                    });
                                                  },
                                                  selectedColor: const Color(0xFFFFB300).withValues(alpha: 0.2),
                                                  checkmarkColor: const Color(0xFFFFB300),
                                                  avatar: const Icon(Icons.card_giftcard, size: 16),
                                                  labelStyle: TextStyle(
                                                    color: _showGiftBoxesOnly ? const Color(0xFFFFB300) : const Color(0xFF475569),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Showing ${_filteredProducts.length} products',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              // Products Section
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    // final isMobile = constraints.maxWidth < 600;
                                    final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
                                    final isDesktop = constraints.maxWidth >= 1024;
                                    
                                    if (_isQuickOrderMode && isDesktop) {
                                      return QuickOrderTable(
                                        products: _filteredProducts,
                                        quantities: {
                                          for (var p in _filteredProducts)
                                            p.id: widget.cartController.getQuantity(p)
                                        },
                                        onIncrement: (product) => widget.cartController.addToCart(product),
                                        onDecrement: (product) => widget.cartController.removeFromCart(product),
                                        onViewDetails: _showProductDetail,
                                      );
                                    }
                                    
                                    int crossAxisCount = 2;
                                    if (isTablet) crossAxisCount = 3;
                                    if (isDesktop) crossAxisCount = 4;
                                    
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 0.68,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: _filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = _filteredProducts[index];
                                        return ProductCard(
                                          product: product,
                                          quantity: widget.cartController.getQuantity(product),
                                          onAdd: () => widget.cartController.addToCart(product),
                                          onIncrement: () => widget.cartController.addToCart(product),
                                          onDecrement: () => widget.cartController.removeFromCart(product),
                                          onTap: () => _showProductDetail(product),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const Footer(),
                    ],
                  ),
                ),
              ),
              // Mobile Bottom Summary Bar
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600 && widget.cartController.items.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                        border: const Border(
                          top: BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${widget.cartController.itemCount} items | ₹${widget.cartController.netTotal.toInt()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'Saved ₹${widget.cartController.discountTotal.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showCartDrawer(context),
                            child: const Text('View Cart'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
