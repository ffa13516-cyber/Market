import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/inventory/presentation/screens/product_list_screen.dart';

/// Root widget. Full go_router setup will replace this direct `home:`
/// wiring once more than one module exists.
class WholesaleErpApp extends StatelessWidget {
  const WholesaleErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wholesale ERP & POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const ProductListScreen(),
    );
  }
}
