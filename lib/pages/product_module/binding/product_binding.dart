import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/product_module/controller/arrived_items_detail_controller.dart';
import 'package:denvin_stock/pages/product_module/controller/consumption_controller.dart';


class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryProductController>(() => InventoryProductController());
    Get.lazyPut<AddProductController>(() => AddProductController());
    Get.lazyPut<ArrivedItemsDetailController>(() => ArrivedItemsDetailController());
    Get.lazyPut<MoveStorageController>(() => MoveStorageController());
    Get.lazyPut<ConsumptionController>(() => ConsumptionController());
  }
}