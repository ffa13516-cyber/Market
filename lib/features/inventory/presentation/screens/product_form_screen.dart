import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../shared/domain/entities/product.dart';
import '../providers/product_providers.dart';

/// Add a new product, or edit an existing one if [existingProduct] is passed.
class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? existingProduct;

  const ProductFormScreen({super.key, this.existingProduct});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _wholesalePriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _lowStockController;

  bool _isSaving = false;

  bool get _isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameController = TextEditingController(text: p?.name ?? '');
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _purchasePriceController =
        TextEditingController(text: p?.purchasePrice.toString() ?? '');
    _sellingPriceController =
        TextEditingController(text: p?.sellingPrice.toString() ?? '');
    _wholesalePriceController =
        TextEditingController(text: p?.wholesalePrice.toString() ?? '');
    _stockController =
        TextEditingController(text: p?.stockQuantity.toString() ?? '');
    _lowStockController =
        TextEditingController(text: p?.lowStockThreshold.toString() ?? '5');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _wholesalePriceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final scanned = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _BarcodeScanScreen()),
    );
    if (scanned != null && mounted) {
      setState(() => _barcodeController.text = scanned);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final repository = ref.read(productRepositoryProvider);
    final id = widget.existingProduct?.id ??
        IdGenerator.newId(FirestorePaths.products);

    final product = Product(
      id: id,
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim(),
      purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
      sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0,
      wholesalePrice: double.tryParse(_wholesalePriceController.text) ?? 0,
      stockQuantity: int.tryParse(_stockController.text) ?? 0,
      lowStockThreshold: int.tryParse(_lowStockController.text) ?? 5,
    );

    try {
      if (_isEditing) {
        await repository.updateProduct(product);
      } else {
        await repository.addProduct(product);
      }
      // Firestore writes resolve instantly against the local cache
      // (even offline), so it's safe to pop right away.
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'تعديل منتج' : 'إضافة منتج'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildField(
              controller: _nameController,
              label: 'اسم المنتج',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _barcodeController,
                    label: 'الباركود',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _scanBarcode,
                  icon: const Icon(Icons.qr_code_scanner),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _purchasePriceController,
              label: 'سعر الشراء',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _sellingPriceController,
              label: 'سعر البيع (قطاعي)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _wholesalePriceController,
              label: 'سعر الجملة',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _stockController,
              label: 'الكمية بالمخزون',
              keyboardType: TextInputType.number,
              validator: _requiredNumber,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _lowStockController,
              label: 'حد التنبيه لانخفاض المخزون',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'حفظ التعديلات' : 'إضافة المنتج'),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'مطلوب';
    if (double.tryParse(value) == null) return 'رقم غير صحيح';
    return null;
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Full-screen barcode scanner. Pops with the scanned code as the result.
class _BarcodeScanScreen extends StatelessWidget {
  const _BarcodeScanScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('امسح الباركود')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            Navigator.of(context).pop(barcode);
          }
        },
      ),
    );
  }
}
