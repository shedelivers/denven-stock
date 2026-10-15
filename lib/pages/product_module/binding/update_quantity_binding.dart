import 'package:denvin_stock/exports.dart';

class UpdateQuantityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdateQuantityController());
  }
}
