import 'package:denvin_stock/exports.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScannerController());
  }
}
