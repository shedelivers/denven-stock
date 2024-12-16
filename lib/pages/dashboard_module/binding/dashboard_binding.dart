import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/basket_product_detail_controller.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/view_basket_controller.dart';



class DashboardBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<InventoryController>(() => InventoryController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ScanArrivedItemsController>(() => ScanArrivedItemsController());
    Get.lazyPut<ViewBasketController>(() => ViewBasketController());
    Get.lazyPut<BasketProductDetailController>(() => BasketProductDetailController());
  }
}