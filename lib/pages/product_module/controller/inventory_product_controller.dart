import 'dart:collection';
import 'package:denvin_stock/exports.dart';
import 'package:intl/intl.dart';

class InventoryProductController extends GetxController {

  Rxn<ProductModal> products = Rxn();
  RxBool isLoading = false.obs;
  RxBool isFabLoading = false.obs;
  RxBool addRestock = false.obs;
  RxBool showBannerCode = true.obs;
  RxBool showAddToCart = true.obs;
  RxInt currentBarcodeIndex = 1.obs;
  late ProductApiProvider _productApiProvider;
  late TextEditingController textEditingControllerQuantity;
  late TextEditingController priceControllerQuantity;
  late TextEditingController expiryDateController;
  late FocusNode textEditingFocusNodeQuantity;
  late FocusNode expiryDateFocusNode;
  late FocusNode priceFocusNode;
  late ExpansionTileController expansionTileController;


  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    textEditingControllerQuantity = TextEditingController();
    priceControllerQuantity = TextEditingController();
    expiryDateController = TextEditingController();
    textEditingFocusNodeQuantity = FocusNode();
    expiryDateFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    expansionTileController = ExpansionTileController();
    getArguments();
    super.onInit();
  }

  getArguments(){
    if(Get.arguments != null) {
      if(Get.arguments[RoutesArgument.productDetails]!=null) {
        products.value = Get.arguments[RoutesArgument.productDetails];
      } else if(Get.arguments[RoutesArgument.productId] != null) {
        products.value = ProductModal(id: Get.arguments[RoutesArgument.productId]);
        if(Get.arguments[RoutesArgument.showBasket] != null){
          showAddToCart.value = Get.arguments[RoutesArgument.showBasket];
        }
      }
      if(Get.arguments[RoutesArgument.addRestock] != null){
        addRestock.value = Get.arguments[RoutesArgument.addRestock];
      }
      getProductById();
    }
  }

  getProductById() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<ProductModal> response = await _productApiProvider.getProductById(productId: products.value?.id);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        if (response.response != null) {
          var model = response.response;
          products.value = model;
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }

  String extractImagePath(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    String imagePath = jsonData.isNotEmpty ? jsonData[0]['file'] : '';
    int startIndex = imagePath.indexOf('product-images');
    if (startIndex != -1) {
      imagePath = imagePath.substring(startIndex);
    } else {
      imagePath = '';
    }
    return imagePath;
  }

  Color getExpiryColor({required List<ExpiriesWithPrice> list, String? date, required int index}) {
    print('expiriesWithPrice level is; ${list[index].level}');
    int level = 0;
    if(list.isEmpty) {
      return Colors.grey;
    } else {
      level = list[index].level ?? 0;
      if(level == 1){
        return Colors.redAccent;
      } else if(level == 2){
        return const Color(0xfff17a00);
      } else if(level == 3) {
        return const Color(0xfffda600);
      } else if(level == 4){
        return const Color(0xff1ec1b0);
      }
    }
    return Colors.grey;
  }

  String convertDateFormat(String originalDateTimeString) {
    DateFormat originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    try {
      DateTime originalDateTime = originalFormat.parse(originalDateTimeString);
      String formattedDate = targetFormat.format(originalDateTime);
      return formattedDate;
    } catch (e) {
      return originalDateTimeString;
    }
  }

  String convertExpiryDateFormat(String originalDateString) {
    DateFormat originalFormat = DateFormat("dd/MM/yyyy");
    // DateFormat originalFormat = DateFormat("yyyy/MM/dd");
    // DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    try {
      DateTime originalDate = originalFormat.parse(originalDateString);
      String formattedDate = targetFormat.format(originalDate);
      return formattedDate;
    } catch (e) {
      return originalDateString;
    }
  }

  getExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      fieldHintText: "dd/mm/yyyy",
      context: Get.context!,
      initialDate: DateTime.tryParse(expiryDateController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    expiryDateController.text = DateFormat('dd/MM/yyyy').format(picked!);
    update();
  }

  updateQuantity () async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> payload = {};
      payload["id"] = products.value?.id;
      payload["name"] = products.value?.name;
      if(products.value?.manufacturer?.isNotEmpty ?? false) payload["manufacturer"] = products.value?.manufacturer;
      payload["createdAt"] = products.value?.createdAt;
      payload["updatedAt"] = products.value?.updatedAt;
      payload["storageId"] = products.value?.storageId;
      payload["supplierName"] = products.value?.supplier?.name;
      payload["supplierCode"] = products.value?.supplierCode;
      payload["minLevel"] = products.value?.minLevel;
      payload["price"] = priceControllerQuantity.text.isNotEmpty ? priceControllerQuantity.text : products.value?.price;
      payload["orderedAt"] = products.value?.orderedAt;
      payload["quantity"] = products.value?.quantity;
      List<Expiries> expiries = [];
      expiries = products.value?.expiries ?? [];
      expiries.add(Expiries(at: expiryDateController.text, qty: int.tryParse(textEditingControllerQuantity.text) ?? 0));
      payload[ApiConstants.expiries] = expiries;
      isLoading.value = true;
      Get.back();
      DataResponse<ProductModal> response = await _productApiProvider.updateQty(productId: products.value?.id.toString(),data: payload);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        if (response.response != null) {
          var model = response.response;
          products.value?.expiries = model?.expiries;
          expiryDateController.clear();
          textEditingControllerQuantity.clear();
          priceControllerQuantity.clear();
          getProductById();
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }

  addToBasket() async {
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> payload = HashMap();
      payload[ApiConstants.ProductIds] = [
        products.value?.id ?? "",
      ];
      CustomLoader().show();
      DataResponse response = await _productApiProvider.addToBasket(data: payload);
      CustomLoader().hide();
      isFabLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        Get.back();
        await Get.find<DashboardController>().getBasketCount();
        Utils.showSnackBar("Product added to basket", isSuccess: true,showIcon: true);
        update();
      }
    }
  }
}