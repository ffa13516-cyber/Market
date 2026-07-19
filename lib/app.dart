import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

/// Root widget. Routing (go_router) will be wired in once
/// the first module's screens exist — kept minimal for now.
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
      home: const Scaffold(
        body: Center(
          child: Text(
            'Wholesale ERP & POS\nModules loading...',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
