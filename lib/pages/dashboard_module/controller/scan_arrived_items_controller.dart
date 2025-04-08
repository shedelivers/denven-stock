import 'dart:async';
import 'dart:collection';

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/arrived_item_modal.dart';
import 'package:denvin_stock/network/modal/barcode_modal.dart';

class ScanArrivedItemsController extends GetxController  {

  RxBool isSearchEnabled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isScannerLoading = false.obs;

  final FocusNode searchFocusNode  = FocusNode();
  final TextEditingController searchController = TextEditingController();

  late ProductApiProvider _productApiProvider;
  RxList<ArrivedItemModal> products = <ArrivedItemModal>[].obs;

  ScrollController scrollController = ScrollController();
  RxInt currentPage = 1.obs;

  Timer? debounce;
  DataResponse<PaginationResponseModal<ArrivedItemModal>> ? implantProductlist;

  ShimmerLoaderState shimmerLoaderState=ShimmerLoaderState.initial;
  @override
  void onInit() {
    initializeVariables();
    super.onInit();
  }
  showInit(){
    currentPage=1.obs;
    implantProductlist=null;
    getArrivedItemData();
    Get.find<DashboardController>().getSummary();
  }
  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  initializeVariables() {
    _productApiProvider  = ProductApiProvider();
  }

  showAndHideSearchBar() {
    isSearchEnabled.value = !isSearchEnabled.value;
  }

  Future getArrivedItemData({bool addMore = false, bool showLoading = true}) async {
    if (await Utils.hasNetwork()) {
      String search = "";
      if (searchController.text.isNotEmpty) {
        search = searchController.text;
      }
      currentPage=1.obs;
      isLoadingMore.value = addMore;
      isLoading.value = showLoading ? true : false;
      shimmerLoaderState=ShimmerLoaderState.loading;
      implantProductlist = await _productApiProvider.getArrivedItems(pageNo: currentPage.value,searchKeyWord: search);
      shimmerLoaderState = ShimmerLoaderState.fetched;
      isLoading.value = false;
      isLoadingMore.value = false;
      if (implantProductlist?.successful == false) {
        Utils.showSnackBar(implantProductlist?.error ?? "Something went wrong");
      } else {
        if (implantProductlist?.response != null) {
          var model = implantProductlist?.response;
          if (addMore){
            products.addAll(model?.data ?? []);
          }else {
            products.value = model?.data ?? [];
          }
        } else {
          Utils.showSnackBar(implantProductlist?.error ?? "Something went wrong");
        }
      }
    }
  }

  Future getPaginationArrivedItemData({bool addMore = false, bool showLoading = true}) async {
    if (await Utils.hasNetwork()) {
      String search = "";
      if (searchController.text.isNotEmpty) {
        search = searchController.text;
      }
      isLoadingMore.value = addMore;
      isLoading.value = showLoading ? true : false;
      shimmerLoaderState=ShimmerLoaderState.loading;
      implantProductlist = await _productApiProvider.getArrivedItems(pageNo: currentPage.value,searchKeyWord: search,);
      shimmerLoaderState=ShimmerLoaderState.fetched;
      isLoading.value = false;
      isLoadingMore.value = false;
      if (implantProductlist?.successful == false) {
        Utils.showSnackBar(implantProductlist?.error ?? "Something went wrong");
      } else {
        if (implantProductlist?.response != null) {
          var model = implantProductlist?.response;
          if (addMore){
            products.addAll(model?.data ?? []);
          }else {
            products.value = model?.data ?? [];
          }
        } else {
          Utils.showSnackBar(implantProductlist?.error ?? "Something went wrong");
        }
      }
    }
  }

  String extractImagePath(String jsonString) {
    try{
      List<dynamic> jsonData = jsonDecode(jsonString);
      String imagePath = jsonData.isNotEmpty ? jsonData[0]['file'] : '';
      int startIndex = imagePath.indexOf('product-images');
      if (startIndex != -1) {
        imagePath = imagePath.substring(startIndex);
      } else {
        imagePath = '';
      }
      return imagePath;}
    catch(e){
      return "";
    }
  }

  addProductFormScan(bool isRestock){
    Get.toNamed(AppRoutes.scannerScreen)?.then((value){
      if(value != null){
        getScanningDetails(value,isRestock);
      }
    });
  }

  String timeAgo(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  Future getScanningDetails(BarcodeModal code, bool isRestock) async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> payload = HashMap();
      payload[ApiConstants.barcode] = code.barcode;
      payload[ApiConstants.symbology] = code.symbology;
      Utils.showLoader(message: "Search...");
      CustomScanResponseModal<ProductModal> response = await _productApiProvider.searchProductFromScan(data: payload);
      Utils.hideLoader();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get product");
        if(response.error == "No product found") {
          Get.toNamed(AppRoutes.chooseSupplierView, arguments: {RoutesArgument.barCode : code,})?.then((value) {
            if (value != null) {
              currentPage.value = 1;
              getArrivedItemData();
              Get.find<DashboardController>().getSummary();
            }
          });
        }
      } else {
        if (response.list != null) {
          List<ProductModal> model = response.list ?? [];
          if(model.length == 1){
            Get.toNamed(AppRoutes.productDetailScreen, arguments: {
              RoutesArgument.productDetails : model.first,
              RoutesArgument.addRestock : model.first.quantity == 0 || model.first.quantity == null ? true : isRestock,
            })?.then((value) { showInit(); });
          } else {
            showScannedResultDialog(model,isRestock);
          }
        } else {
          Utils.showSnackBar(response.error ?? "Unable to get product");
        }
      }
    }
  }

  Future deleteProduct(String productId) async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse response = await _productApiProvider.deleteProduct(productId: productId);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to delete product");
      } else {
        Utils.showSnackBar("Product deleted successfully");
        currentPage.value = 1;
        getArrivedItemData();
      }
    }
  }

  void showAlertDialog(ProductModal? productModal) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap(20.0),
              Row(
                children: [
                  TextView("Are you sure?", style: black_17_600(),),
                  const Spacer(),
                  const Icon(Icons.close).onTap(() {Get.back();}),
                ],
              ).marginSymmetric(horizontal: 20.0),
              TextView("you want to delete this product", style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              ProductCard(
                isHidden: productModal?.hidden??false,
                imagePath: productModal?.productImage != null && (productModal?.productImage??"").isNotEmpty ? "${ApiConstants.baseUrlForImage}/${extractImagePath(productModal?.productImage ?? "")}" : null,
                name: productModal?.name,
                dontShowBorderAndMenu: true,
                supplierCode: productModal?.supplierCode,
                orderAt: productModal?.orderedAt,
                price: productModal?.price,
                type: productModal?.type??1,
                menuOnTap: () {},
                cardOnTap: () {},
              ).marginSymmetric(horizontal: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      borderRadius: BorderRadius.circular(6.0),
                      onTap: (){
                        Get.back();
                      },
                      child: Text("Cancel", style: primaryColor_16_700()).paddingSymmetric(horizontal: 10.0,vertical: 6)),
                  hGap(10.0),
                  InkWell(
                      borderRadius: BorderRadius.circular(6.0),
                      onTap: (){
                        Get.back();
                        deleteProduct(productModal?.id.toString() ?? "").then((value) {
                          currentPage.value = 1;
                          getArrivedItemData();
                          Get.find<DashboardController>().getSummary();
                        });
                      },
                      child: Text("Delete", style: primaryColor_16_700()).paddingSymmetric(horizontal: 10.0,vertical: 6)),
                ],
              ).marginSymmetric(horizontal: 20.0),
              vGap(20),
            ],
          ),
        );
      },
    );
  }

  void showScannedResultDialog(List<ProductModal>? productModalList, bool isRestock) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap(20.0),
              Row(
                children: [
                  TextView("Select Product", style: black_17_600(),),
                  const Spacer(),
                  const Icon(Icons.close).onTap(() {Get.back();}),
                ],
              ).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              ...List.generate(
                  productModalList?.length ?? 0, (index) {
                ProductModal? productModal = productModalList?[index];
                return ProductCard(
                  isHidden: productModal?.hidden??false,
                  imagePath: productModal?.productImage != null && productModal!.productImage!.isNotEmpty ? "${ApiConstants.baseUrlForImage}/${extractImagePath(productModal.productImage ?? "")}" : null,
                  name: productModal?.name,
                  dontShowBorderAndMenu: true,
                  type: productModal?.type??1,
                  supplierCode: productModal?.supplierCode,
                  orderAt: productModal?.orderedAt,
                  price: productModal?.price,
                  localMappingId: productModal?.localMappingId,
                  menuOnTap: (){},
                  cardOnTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.productDetailScreen, arguments: {
                      RoutesArgument.productDetails : productModal,
                      RoutesArgument.addRestock : productModal?.quantity == 0 || productModal?.quantity == null  ? true :   isRestock,
                    })?.then((value) => showInit());
                  },
                ).marginSymmetric(horizontal: 10.0);
              }),
              vGap(20),
            ],
          ),
        );
      },
    );
  }


  Future checkBarCodeAdded(BarcodeModal code, {required Function onNotGettingItemTap,required Function onGettingItemTap,}) async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> payload = HashMap();
      payload[ApiConstants.barcode] = code.barcode;
      payload[ApiConstants.symbology] = code.symbology;
      Utils.showLoader(message: "Search...");
      CustomScanResponseModal<ProductModal> response = await _productApiProvider.searchProductFromScan(data: payload);
      Utils.hideLoader();
      if (response.successful == false) {
        if(response.error == "No product found") {
          onNotGettingItemTap();
        }
      } else {
        if (response.list != null) {
          onGettingItemTap();
        } else {
          onNotGettingItemTap();
        }
      }
    }
  }



  Future addBarCode({required AddBarcodeDto addBarcodeDto}) async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      ComanResponseModal response = await _productApiProvider.addBarCode(addBarcodeDto: addBarcodeDto);
      customLoader.hide();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          Utils.showSnackBar("Bar Code Added");
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }


}