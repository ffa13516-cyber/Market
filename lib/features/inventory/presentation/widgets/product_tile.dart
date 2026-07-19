import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stockColor = product.isLowStock ? AppColors.danger : AppColors.textSecondary;

    return Card(
      color: AppColors.surfaceElevated,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Stock status indicator — glanceable at a distance during rush hour.
              Container(
                width: 8,
                height: 40,
                decoration: BoxDecoration(
                  color: product.isLowStock ? AppColors.danger : AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.subheading),
                    const SizedBox(height: 4),
                    Text(
                      product.barcode.isEmpty ? 'لا يوجد باركود' : product.barcode,
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(product.sellingPrice),
                    style: AppTextStyles.subheading.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المخزون: ${product.stockQuantity}',
                    style: AppTextStyles.body.copyWith(color: stockColor),
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
