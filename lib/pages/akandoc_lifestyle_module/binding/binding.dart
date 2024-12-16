import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/basket_product_detail_controller.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/view_basket_controller.dart';

import '../controller/controller.dart';



class AkanDocLifeStyleBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AkanDocLifeStyleController>(() => AkanDocLifeStyleController());
  }
}