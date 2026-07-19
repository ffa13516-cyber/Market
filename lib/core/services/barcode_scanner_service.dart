import 'package:mobile_scanner/mobile_scanner.dart';

/// Thin wrapper so screens don't depend directly on mobile_scanner's API.
/// Logic (matching scanned barcode -> Product) will be implemented
/// when we build the Inventory / POS modules.
class BarcodeScannerService {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  void dispose() {
    controller.dispose();
  }
}
