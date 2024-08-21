import 'package:denvin_stock/exports.dart';

class HomeController extends GetxController{

  late AuthApiProvider _authApiProvider;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    super.onInit();
  }

}