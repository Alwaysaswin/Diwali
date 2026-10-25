import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          color: const Color(0xFF0F172A),
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          child: Column(
            children: [
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandSection(),
                    const SizedBox(height: 24),
                    _buildQuickLinks(),
                    const SizedBox(height: 24),
                    _buildSafetyInfo(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildBrandSection()),
                    Expanded(child: _buildQuickLinks()),
                    Expanded(child: _buildSafetyInfo()),
                  ],
                ),
              const SizedBox(height: 32),
              const Divider(color: Color(0xFF334155)),
              const SizedBox(height: 16),
              Text(
                '© 2026 SparkCart Crackers. All rights reserved. | Demo Web Application',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '⚠️ Please follow all safety guidelines. Use fireworks responsibly with adult supervision.',
                style: TextStyle(
                  color: const Color(0xFFFFB300),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
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
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Your trusted destination for quality crackers and fireworks. Celebrating traditions with safety and joy.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 8),
            _buildSocialIcon(Icons.camera_alt),
            const SizedBox(width: 8),
            _buildSocialIcon(Icons.email),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildLink('Home'),
        _buildLink('All Products'),
        _buildLink('Family Gift Boxes'),
        _buildLink('Green Crackers'),
        _buildLink('Safety Guidelines'),
      ],
    );
  }

  Widget _buildSafetyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Safety & Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildLink('100% Green Crackers'),
        _buildLink('Safety Instructions'),
        _buildLink('Age Guidelines'),
        _buildLink('Storage Tips'),
        _buildLink('Emergency Contacts'),
      ],
    );
  }

  Widget _buildLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
