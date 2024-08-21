import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/baske_modal.dart';

class ViewBasketController extends GetxController {

  RxBool isLoading = false.obs;
  RxList<BasketModal> basketItems = <BasketModal>[].obs;

  late ProductApiProvider _productApiProvider;

  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    super.onInit();
  }

  Future getBasketListing() async {
    basketItems.value = [];
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<PaginationResponseModal<BasketModal>> response = await _productApiProvider.getBasket();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          basketItems.addAll((model?.data ?? []));
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  Future deleteItem({String? id}) async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse response = await _productApiProvider.deleteBasketItem(id: id);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        Utils.showSnackBar("Basket item deleted successfully",showIcon: true,isSuccess: true);
        getBasketListing();
        update();
      }
    }
  }
}