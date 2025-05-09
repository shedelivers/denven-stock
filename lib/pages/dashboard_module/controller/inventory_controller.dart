import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:denvin_stock/components/conformation_popup.dart';
import 'package:denvin_stock/components/product_card.dart';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/barcode_modal.dart';
import 'package:denvin_stock/network/modal/filter_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../Network/modal/dto/add_bar_code_dto.dart';
import '../../../../Network/modal/enum/shimmer_enum.dart';
import '../../../network/modal/baske_modal.dart';
import '../../product_module/dialogs/stock_filter_dialog.dart';

class InventoryController extends GetxController {

  RxBool isSearchEnabled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isScannerLoading = false.obs;

  final FocusNode searchFocusNode  = FocusNode();

  final TextEditingController searchController = TextEditingController();

  late ProductApiProvider _productApiProvider;

  RxList<ProductModal> products = <ProductModal>[].obs;

  ScrollController scrollController = ScrollController();

  RxInt currentPage = 1.obs;

  Timer? debounce;

  DataResponse<PaginationResponseModal<ProductModal>> ? implantProductlist;

  Rxn<FilterModal> myFilterModal = Rxn<FilterModal>(FilterModal());

  ShimmerLoaderState shimmerLoaderState=ShimmerLoaderState.initial;
  @override
  void onInit() {
    initializeVariables();
    super.onInit();
  }
  showInit(){
    currentPage=1.obs;
    implantProductlist = null;
    getInventoryData();
    Get.find<DashboardController>(). getSummary();
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

  Future getInventoryData({bool addMore = false, bool showLoading = true}) async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> filterPayload = HashMap();
      filterPayload["page"] = 1;
      filterPayload["OrderCol"] = 10;
      filterPayload["OrderDir"] = "desc";
      filterPayload["packageType"] = myFilterModal.value?.openProducts??"1";
      filterPayload["showHidden"] = myFilterModal.value?.showHiddenProduct == "0"? false: true;

      if (searchController.text.isNotEmpty) {
         filterPayload["search"] = searchController.text;
      }

      if(myFilterModal.value?.barcodeStatus != null){
        filterPayload["scanState"] = myFilterModal.value?.barcodeStatus;
      }

      if(myFilterModal.value?.expiryState != null){
        filterPayload["expireState"] = myFilterModal.value?.expiryState;
      }

      if(myFilterModal.value?.selectedStorageItem != null){
        if(myFilterModal.value?.selectedStorageItem?.isNotEmpty ?? false){
          String storageList = myFilterModal.value?.selectedStorageItem?.map((e) => e.id,).join(",") ?? "";
          filterPayload["storageId"] = storageList;
        }
      }

      if(myFilterModal.value?.selectedItem != null){
        if(myFilterModal.value?.selectedItem?.isNotEmpty ?? false){
          String supplierList = myFilterModal.value?.selectedItem?.map((e) => e.id,).join(",") ?? "";
          filterPayload["supplierId"] = supplierList;
        }
      }

      currentPage = 1.obs;
      isLoadingMore.value = addMore;
      isLoading.value = showLoading ? true : false;
      shimmerLoaderState=ShimmerLoaderState.loading;
      implantProductlist = await _productApiProvider.getInventoryStock(filters: filterPayload);
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

  Future getPaginationImplantStockData({bool addMore = false, bool showLoading = true}) async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> filterPayload = HashMap();
      filterPayload["page"] = currentPage.value;
      filterPayload["OrderCol"] = 10;
      filterPayload["OrderDir"] = "desc";
      if (searchController.text.isNotEmpty) {
        filterPayload["search"] = searchController.text;
      }
      if (searchController.text.isNotEmpty) {
        filterPayload["search"] = searchController.text;
      }

      if(myFilterModal.value?.barcodeStatus != null){
        filterPayload["scanState"] = myFilterModal.value?.barcodeStatus;
      }

      if(myFilterModal.value?.expiryState != null){
        filterPayload["expireState"] = myFilterModal.value?.expiryState;
      }

      if(myFilterModal.value?.selectedStorageItem != null){
        if(myFilterModal.value?.selectedStorageItem?.isNotEmpty ?? false){
          String storageList = myFilterModal.value?.selectedStorageItem?.map((e) => e.id,).join(",") ?? "";
          filterPayload["storageId"] = storageList;
        }
      }

      if(myFilterModal.value?.selectedItem != null){
        if(myFilterModal.value?.selectedItem?.isNotEmpty ?? false){
          String supplierList = myFilterModal.value?.selectedItem?.map((e) => e.id,).join(",") ?? "";
          filterPayload["supplierId"] = supplierList;
        }
      }
      isLoadingMore.value = addMore;
      isLoading.value = showLoading ? true : false;
      shimmerLoaderState= ShimmerLoaderState.loading;
      implantProductlist = await _productApiProvider.getInventoryStock(filters: filterPayload,);
      shimmerLoaderState= ShimmerLoaderState.fetched;
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

  Future getScanningDetails(BarcodeModal code, bool isRestock) async {
    if (await Utils.hasNetwork()) {
      Map<String,dynamic> payload = HashMap();
      payload[ApiConstants.barcode] = code.barcode;
      payload[ApiConstants.symbology] = code.symbology;
      Utils.showLoader(message: "Search...");
      DataResponse<PaginationResponseModal<ProductModal>> response = await _productApiProvider.searchProductFromScanStock(barcode: code.barcode, type: code.symbology);
      Utils.hideLoader();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get product");
        if(response.error == "No product found") {
          Get.toNamed(AppRoutes.chooseSupplierView, arguments: {RoutesArgument.barCode : code,})?.then((value) {
            if (value != null) {
              currentPage.value = 1;
              getInventoryData();
              Get.find<DashboardController>().getSummary();
            }
          });
        }
      } else {
        if (response.response?.data != null) {
          List<ProductModal> model = response.response?.data ?? [];
          if(model.length == 1) {
            showScannedResultDialog(model,isRestock);
            // Get.toNamed(AppRoutes.productDetailScreen, arguments: {
            //   RoutesArgument.productDetails : model.first,
            //   RoutesArgument.addRestock : model.first.quantity == 0 || model.first.quantity == null ? true : isRestock,
            // })?.then((value) { showInit(); });
          } else if(model.isEmpty) {
            Utils.showSnackBar("No product found.");
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
        getInventoryData();
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
                imagePath: productModal?.productImage??[],
                    isHidden: productModal?.hidden??false,
                 // imagePath: productModal?.productImage != null && (productModal?.productImage??"").isNotEmpty ? "${ApiConstants.baseUrlForImage}/${extractImagePath(productModal?.productImage ?? "")}" : null,
                  name: productModal?.name,
                  dontShowBorderAndMenu: true,
                  supplierCode: productModal?.supplierCode,
                  orderAt: productModal?.orderedAt,
                  price: productModal?.price,
                  localMappingId: productModal?.localMappingId,
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
                          getInventoryData();
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
                  imagePath: productModal?.productImage??[],
                  isHidden: productModal?.hidden??false,
                //  imagePath: productModal?.productImage != null && productModal!.productImage!.isNotEmpty ? "${ApiConstants.baseUrlForImage}/${extractImagePath(productModal.productImage ?? "")}" : null,
                  name: productModal?.name,
                  supplierCode: productModal?.supplierCode,
                  orderAt: productModal?.orderedAt,
                  storageName: productModal?.storage?.name,
                  price: productModal?.price,
                  type: productModal?.type??1,
                  menuOnTap: (){
                    editProductBottomSheet(productModal ?? ProductModal());
                  },
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

      CustomScanResponseModal<ProductModal> response = await _productApiProvider.searchProductFromScan(data: payload);

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


  Future<void> hideUnHideProduct({required int id,required bool isHidden }) async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      Map<String,dynamic> payload = HashMap();
      payload['Id'] = id;
      payload['Status'] = 1;
      payload['IsHidden'] = isHidden;
      DataResponse response = await _productApiProvider.hideUnHideProduct(id: id.toString(), payload: payload);

      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
        isLoading.value = false;
      } else {
        showInit();
        // Utils.showSnackBar("Product deleted successfully");
        // currentPage.value = 1;
       // getInventoryData();
      }
    }
  }


  editProductBottomSheet(ProductModal product) {
    showModalBottomSheet(
      context: Get.context!,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 27,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: margin_20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vGap(10.0),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 1, color: textFieldBorderColor),
                            ),
                            child: product.productImage != null
                                ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ShimmerImage(
                                  url: product.productImage?.isNotEmpty??false? product.productImage![0]:"",
                                   // url: extractImagePath(product.productImage ?? ""),
                                    withBaseUrl: true,
                                    thumbnail: imageIcon,
                                    fit: BoxFit.cover)) : imageAsset(imageIcon),

                            // imageAsset(fileIcon),
                          ),
                          hGap(20.0),
                          Expanded(
                            child: TextView(product.name ?? "",
                                maxLine: 3,
                                style: black_16_400()?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: product.hidden==false,
                        child: Column(
                          children: [
                            vGap(10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(width: 1, color: textFieldBorderColor)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        imageAsset(updateqtyIcon,
                                            width: 20.0, color: black),
                                        vGap(6.0),
                                        TextView("Update Quantity", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
                                      ],
                                    ),
                                  ).onTap(() {
                                    Get.back();
                                    if(product.expiries?.isNotEmpty ?? false) {
                                      Get.toNamed(AppRoutes.updateQuantity, arguments: {RoutesArgument.productDetails: product})?.then((value) {
                                        if (value != null) {
                                          currentPage.value = 1;
                                          getInventoryData();
                                        }
                                      });
                                    } else {
                                      Utils.showSnackBar("This product don't have quantity and expiry");
                                    }

                                  }),
                                ),
                                hGap(20.0),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(width: 1, color: textFieldBorderColor),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          imageAsset(moveIcon, width: 20.0, color: black),
                                          vGap(6.0),
                                          TextView("Move to storage", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
                                        ],
                                      ),
                                    ).onTap(() {
                                      Get.back();
                                      if(product.expiries?.isNotEmpty ?? false){
                                        Get.toNamed(AppRoutes.moveStorage, arguments: {RoutesArgument.productDetails: product})?.then((value) {
                                          if (value != null) {
                                            currentPage.value = 1;
                                            getInventoryData();
                                          }
                                        });
                                      } else {
                                        Utils.showSnackBar("Product is out of stock");
                                      }
                                    }
                                    )
                                ),
                              ],
                            ),
                            vGap(10.0),
                            BottomSheetItem(
                              title: "Consumption",
                              iconUri: consumIcon,
                              onItemTap:() {
                                Get.back();
                                if(product.expiries?.isNotEmpty ?? false){
                                  Get.toNamed(AppRoutes.addConsumptionScreen, arguments: {RoutesArgument.productDetails: product})?.then((value) {
                                    if (value != null) {
                                      currentPage.value = 1;
                                      getInventoryData();
                                    }
                                  });
                                } else {
                                  Utils.showSnackBar("This product don't have quantity and expiry");
                                }
                              },
                            ),
                            vGap(10.0),
                            BottomSheetItem(
                              title: "Add to basket",
                              iconUri: addBasketIcon,
                              onItemTap:() {
                                Get.back();
                                addToBasket(product.id ?? 0);
                              },
                            ),
                          ],
                        ),
                      ),

                      vGap(10.0),
                      BottomSheetItem(
                        title: "Edit Details",
                        iconUri: editIcon,
                        onItemTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.addManualProduct, arguments: {
                            RoutesArgument.productDetails: product,
                            RoutesArgument.isEdit: true,
                            RoutesArgument.productType: ProductType.edit
                          })?.then((value) {
                            if (value != null) {
                              currentPage.value = 1;
                              getInventoryData();
                            }
                          });
                        },
                      ),

                      vGap(10.0),
                      BottomSheetItem(
                        title: "View Details",
                        iconUri: viewIcon,
                        onItemTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.productDetailScreen,
                              arguments: {
                                RoutesArgument.productDetails: product,
                                RoutesArgument.addRestock: false
                              })?.then((value) {
                            searchController.clear();
                            getInventoryData();
                            // controller.showAndHideSearchBar();
                          });
                        },
                      ),

                      Visibility(
                          visible: product.hidden==false,
                          child: Column(
                        children: [
                          vGap(10.0),
                          BottomSheetItem(
                            title: "Add Barcode",
                            iconUri: scanIcon,
                            onItemTap: () {
                              Get.back();
                              Get.toNamed(AppRoutes.scannerScreen)?.then((value) {
                                if (value != null) {
                                  BarcodeModal? barcode = value;
                                  addBarCode(
                                      addBarcodeDto: AddBarcodeDto(
                                          localMappingId: product.localMappingId,
                                          supplierCode: product.supplierCode,
                                          supplierId: product.supplier?.id,
                                          ApiRequest: true,
                                          commands: [
                                            CommandsDto(
                                                symbology: barcode?.symbology ?? "",
                                                barcode: barcode?.barcode ?? "",
                                                command: 1)
                                          ]
                                      )
                                  );
                                  // controller.checkBarCodeAdded(value, onGettingItemTap: () {
                                  //   Utils.showSnackBar("Bar Code Already Added");
                                  // }, onNotGettingItemTap: () {
                                  // });
                                }
                              });
                            },
                          ),
                        ],
                      )),


                      Visibility(
                        visible: product.type != 1,
                          child: Column(
                           children: [
                            vGap(10.0),
                            BottomSheetItem(
                            title: "Open Product",
                            iconUri: closeBoxIcon,
                            onItemTap: () {
                              Get.back();
                              String productQuantity = "12";

                              for(ProductModal prod in products){
                                print('supplierCode Test 1: ${prod.supplierCode}');
                                print('supplierCode Test 2: ${product.supplierCode}**');
                                print('supplierCode Test prod.type: ${product.type}');
                                if(prod.type == 1 && prod.supplierCode == "${product.supplierCode}**"){
                                  if(prod.expiries?.isNotEmpty??false){
                                    productQuantity = prod.expiries?[0].qty.toString()??"12";
                                  }
                                }
                              }

                              openProduct(
                               productId: product.id??0,
                                productName: product.name??"",
                                productQuantity: productQuantity,
                                expiryDate: product.expiries??[]

                              );
                              },
                          ),
                        ],
                      )),

                      vGap(10.0),
                      InkWell(
                        onTap: (){
                          confirmPopUp(
                              title: product.hidden == true?'Confirm Unhide Product':'Confirm Hide Product',
                              subtitle: product.hidden == true?"Are you sure you want to show this product?":"Are you sure you want to hide this product?",
                              onConfirm: (){
                                Get.back();
                                Get.back();
                                hideUnHideProduct(
                                    id: product.id??0,
                                    isHidden: product.hidden == true? false:true
                                );
                              });

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1, color: textFieldBorderColor),
                          ),
                          child: Row(
                            children: [
                              Icon(product.hidden == false? Icons.visibility_off:Icons.visibility, color: black,),
                              hGap(10.0),
                              TextView(product.hidden == false?'Hide Product':'Unhide product',style: black_17_600()?.copyWith(fontSize: 14,color: black)),
                              const Spacer(),
                              // CircleAvatar(
                              //   backgroundColor: primaryLightColor,
                              //   radius: 12,
                              //   child: Icon(Icons.arrow_forward_ios_outlined, color: primaryColor,size: 14),
                              // )
                            ],
                          ).paddingSymmetric(horizontal: 20.0,vertical: 12.0),
                        ),
                      ),



                      // vGap(10.0),
                      // BottomSheetItem(
                      //   title: "Clone",
                      //   iconUri: cloneIcon,
                      //   onItemTap: () {},
                      // ),
                      // vGap(10.0),
                      // BottomSheetItem(
                      //   title: "Delete Product",
                      //   iconUri: deleteIcon,
                      //   onItemTap: () {
                      //     Get.back();
                      //
                      //     controller.showAlertDialog(product);
                      //   },
                      // ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 16,
              top: 0,
              child: Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          FocusScope.of(Get.context!).requestFocus(FocusScopeNode());
        },
      ),
    );
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



  addToBasket(int id) async {
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> payload = HashMap();
      payload[ApiConstants.ProductIds] = [
        id,
      ];
      CustomLoader().show();
      DataResponse response = await _productApiProvider.addToBasket(data: payload);
      CustomLoader().hide();
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



  openTheProduct({required int id, required int countInPack,required int countTimeInPack,required String expiry,}) async {
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> payload = HashMap();
      payload['Id'] = id;
      payload['CountInPack'] = countInPack;
      payload['CountTimeInPack'] = countTimeInPack;
      payload['Expiry'] = expiry;
      CustomLoader().show();
      DataResponse response = await _productApiProvider.openThePackage(data: payload);
      CustomLoader().hide();
      isLoading.value = true;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
        isLoading.value = false;
      } else {
        Get.back();
        showInit();
        // Utils.showSnackBar("Product deleted successfully");
        // currentPage.value = 1;
        // getInventoryData();
      }
    }
  }


  Future<void> openProduct({
    required int productId,
    required String productName,
    required String productQuantity,
    required List<Expiries> expiryDate,
}) async {

    final TextEditingController numberOfProduct = TextEditingController(text: productQuantity);
    final TextEditingController packagesToOpen = TextEditingController(text: "1");
    ExpiryFilterDTO? selectedExpiryDate;

    List<ExpiryFilterDTO> expiryDateList = <ExpiryFilterDTO>[];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    for(Expiries expiry in expiryDate){
      if(expiry.at != null && expiry.at != ""){
        expiryDateList.add(
            ExpiryFilterDTO(
                title: expiry.at??"",
                id: expiry.at??"0"
            )
        );
      }
    }

    if(expiryDateList.isNotEmpty){
      selectedExpiryDate = expiryDateList[0];
    } else {
      expiryDateList.add(
          ExpiryFilterDTO(
              title: "Without expiry",
              id: ""
          )
      );
    }


    return Get.dialog(
      GetBuilder<InventoryController>(
        builder: (controller) {
          return Container(
            alignment: Alignment.center,
            child: Container(
                width: Get.width * 0.8,
                padding: const EdgeInsets.symmetric(vertical: margin_10, horizontal: margin_20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius_20)),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextView(
                              productName,
                              style: black_15_700()?.copyWith(color: primaryColor),
                            ),
                          ),
                          IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close)),
                        ],
                      ),

                      vGap(10.0),
                      Utils.textFieldLabel(label: "Number of items in the package"),
                      vGap(10.0),
                      CustomTextField(
                        controller: numberOfProduct,
                        hintText: "Count",
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value){
                          if(value!.isEmpty){
                            return "Number of items";
                          } else if (int.parse(value) == 0){
                            return "Number of items can't be 0";
                          }
                        },
                      ),

                      vGap(10.0),
                      Utils.textFieldLabel(label: "Package expiry"),
                      vGap(10.0),
                      Container(
                        decoration: BoxDecoration(
                            color: textFieldFillColor,
                            border: Border(
                                bottom: BorderSide(color: textFieldBorderColor, width: 1))),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<ExpiryFilterDTO>(
                            isExpanded: true,
                            value: selectedExpiryDate,
                            hint: TextView(
                              "Package expiry",
                              style: TextStyle(
                                  color: hintTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            padding: const EdgeInsets.symmetric( vertical: 4.0),
                            icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
                            iconSize: 24,
                            style: const TextStyle(color: Colors.black,),
                            underline: Container(height: 0, color: Colors.transparent,),
                            onChanged: (value) async {
                              selectedExpiryDate = value;
                              update();
                            },
                            elevation: 1,
                            items: expiryDateList.map((e) => DropdownMenuItem<ExpiryFilterDTO>(value: e, child: Text(e.title,),),).toList()),
                          ),
                        ),

                      vGap(10.0),
                      Utils.textFieldLabel(label: "How many Packages to open"),
                      vGap(10.0),
                      CustomTextField(
                        controller: packagesToOpen,
                        hintText: "Count",
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value){
                          if(value!.isEmpty){
                            return "Packages to open";
                          } else if (int.parse(value) == 0){
                            return "Packages to open can't be 0";
                          }
                        },
                      ),
                      vGap(20.0),

                      SizedBox(
                        height: 70,
                        child: AppButton(
                            buttonText: "Open the package",
                            onTap: (){
                              if(formKey.currentState != null && formKey.currentState!.validate()){
                                openTheProduct(
                                    id: productId,
                                    countInPack: int.parse(numberOfProduct.text),
                                    countTimeInPack: int.parse(packagesToOpen.text),
                                    expiry: selectedExpiryDate?.id == null ||  selectedExpiryDate?.id == ""? "":selectedExpiryDate?.title??"");
                              }

                            }),
                      ),
                    ],
                  ),
                ),
            ),
          );
        }
      ),
    );
  }

}