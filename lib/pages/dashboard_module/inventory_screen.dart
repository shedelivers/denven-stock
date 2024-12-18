import 'dart:async';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/barcode_modal.dart';
import 'package:denvin_stock/pages/product_module/controller/add_product_controller.dart';
import 'package:denvin_stock/pages/product_module/dialogs/stock_filter_dialog.dart';

class InventoryStockScreen extends GetView<InventoryController> {

  InventoryStockScreen({super.key}) {
    controller.showInit();
  }

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Obx(
        () => Scaffold(
            appBar: !(controller.isSearchEnabled.value) ? AppBar(
                    leadingWidth: 10,
                    scrolledUnderElevation: 0,
                    leading: const SizedBox(),
                    centerTitle: false,
                    title: TextView(
                      Strings.stock,
                      style: whiteColor_18_700()?.copyWith(color: primaryColor),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            controller.showAndHideSearchBar();
                          },
                          icon: imageAsset(search, width: 18, color: Colors.black)
                      ),
                      IconButton(
                          onPressed: () {
                            controller.addProductFormScan(false);
                          },
                          icon: imageAsset(scanIcon, width: 20)
                      ),
                      Obx(()=> IconButton(
                            onPressed: () {
                              stockBottomSheet();
                            },
                            icon: imageAsset(filter, width: 19.0, color: controller.myFilterModal.value?.expiryState != null || controller.myFilterModal.value?.selectedItem != null || controller.myFilterModal.value?.selectedStorageItem != null || controller.myFilterModal.value?.barcodeStatus != null ? primaryColor : Colors.black),
                        ).marginOnly(right: 10.0),
                      ),
                    ],
                  ) : AppBar(
                    leadingWidth: 60,
                    scrolledUnderElevation: 0,
                    titleSpacing: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.getInventoryData();
                        controller.showAndHideSearchBar();
                      },
                    ),
                    title: Row(
                      children: [
                        Expanded(
                            child: CustomTextFieldV3(
                          hintText: Strings.searchProduct,
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
                          onChanged: (value) {
                            controller.currentPage.value = 0;
                            if (controller.debounce?.isActive ?? false) {controller.debounce?.cancel();}
                            controller.debounce = Timer(const Duration(milliseconds: 500), () {controller.getInventoryData();});
                          },
                          prefix: IconButton(
                            onPressed: () {},
                            icon: imageAsset(search, height: 16.0),
                          ),
                        ).marginOnly(right: 20.0)),
                      ],
                    ),
                  ),
            body: _mainBuild()),
      ),
    );
  }

  _mainBuild() {
    return Column(
      children: [
        vGap(10.h),
        GetBuilder<DashboardController>(builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomStockBoxItemView(
                image: boxesIcon,
                price: Get.find<DashboardController>().summaryData.value?.totalProducts.toString() ?? "0",
                title: Strings.totalProducts,
              ),
              Container(
                height: 60,
                width: 0.4,
                color: textFieldBorderColor,
              ),
              CustomStockBoxItemView(
                image: plusMinusIcon,
                price: Get.find<DashboardController>().summaryData.value?.totalQuantity.toString() ?? "0",
                title: Strings.totalQuantity,
              ),
              Container(
                height: 60,
                width: 0.4,
                color: textFieldBorderColor,
              ),
              CustomStockBoxItemView(
                image: dollarIcon,
                price: "£${Get.find<DashboardController>().summaryData.value?.totalPrice ?? "0"}",
                title: Strings.totalPrice,
              ),
            ],
          );
        }),
        vGap(14.0),
        const Divider(height: 0.4, thickness: 0.4, color: Color(0xffdddddd)),
        vGap(14.0),
        Expanded(
          child: Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                await Get.find<DashboardController>().getSummary();
                await controller.getInventoryData(showLoading: false);
              },
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollInfo) {
                  //scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8
                  if(scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8){
                    if((getTotalPage() - 1) >= controller.currentPage.value && controller.shimmerLoaderState == ShimmerLoaderState.fetched && controller.products.isNotEmpty){
                      controller.currentPage.value = (controller.implantProductlist?.response?.page ?? 0) + 1;
                      controller.getPaginationImplantStockData(addMore: true, showLoading: false);
                    }
                  }
                  return true;
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController,
                  children: [
                    controller.isLoading.value ? Utils.circularLoader(marginTop: 30) : controller.products.isEmpty ? Utils.noDataFound(message: "No Product Found").marginOnly(top: 20.0) :
                    ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.products.length,
                                itemBuilder: (_,index) {
                                  ProductModal? product = controller.products[index];


                                  return ProductCard(
                                    imagePath: product.productImage != null && product.productImage!.isNotEmpty ? "${ApiConstants.baseUrlForImage}/${controller.extractImagePath(product.productImage ?? "")}" : null,
                                    name: product.name,
                                    supplierCode: product.supplierCode,
                                    storageName: product.storage?.name,
                                    orderAt: product.orderedAt,
                                    localMappingId: product.localMappingId,
                                    type: product.type??1,
                                    price: product.expiries!.isNotEmpty?product.expiries?.last.price??0:0,
                                   // price: product.price,
                                    cardOnTap: () {
                                      Get.toNamed(AppRoutes.productDetailScreen,
                                          arguments: {RoutesArgument.productDetails: product, RoutesArgument.addRestock: false})?.then((value) {
                                        if (value != null) {
                                          controller.searchController.clear();
                                          controller.getInventoryData();
                                          // controller.showAndHideSearchBar();
                                        }
                                      });
                                    },
                                    menuOnTap: () {controller.editProductBottomSheet(product);},
                                  );
                                }),
                    // if ((getTotalPage() - 1) >= controller.currentPage.value && controller.shimmerLoaderState == ShimmerLoaderState.fetched && controller.products.isNotEmpty)
                    //   Row(
                    //     children: [
                    //       const Spacer(),
                    //       LoaderMoreButton(
                    //         onTap: () {
                    //           controller.currentPage.value = (controller.implantProductlist?.response?.page ?? 0) + 1;
                    //           controller.getPaginationImplantStockData(addMore: true, showLoading: false);
                    //         },
                    //       ),
                    //       const Spacer(),
                    //     ],
                    //   ),
                   // if (controller.shimmerLoaderState == ShimmerLoaderState.loading && controller.products.isNotEmpty && controller.isLoadingMore.value)

                    if (controller.isLoadingMore.value)

                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                           ),
                         ),
                        )
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 20.0);
  }

  num getTotalPage() {
    num totalPage = (controller.implantProductlist?.response?.total ?? 1) / (controller.implantProductlist?.response?.pageSize ?? 1);
    if ((controller.implantProductlist?.response?.total ?? 1) % (controller.implantProductlist?.response?.pageSize ?? 1) != 0) {
      totalPage = totalPage + 1;
    }
    return totalPage;
  }

  _addProductBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      useRootNavigator: false,
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vGap(10.0),
                      TextView(Strings.addDetails,
                          style: black_20_700()?.copyWith(color: primaryColor)),
                      vGap(10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(width: 1, color: textFieldBorderColor),
                        ),
                        child: Row(
                          children: [
                            imageAsset(scanIcon, height: 20.0),
                            hGap(10.0),
                            TextView(Strings.scanning, style: black_17_600()),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: primaryLightColor,
                              radius: 12,
                              child: Icon(Icons.arrow_forward_ios_outlined,
                                  color: primaryColor, size: 14),
                            )
                          ],
                        ).paddingSymmetric(horizontal: 20.0, vertical: 14.0),
                      ).marginSymmetric(horizontal: 20.0, vertical: 10.0).onTap(() {
                        Get.back();
                        controller.addProductFormScan(true);
                      }),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1, color: textFieldBorderColor),
                        ),
                        child: Row(
                          children: [
                            imageAsset(manualEntryIcon, height: 22.0),
                            hGap(10.0),
                            TextView(Strings.manualEntry, style: black_17_600()),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: primaryLightColor,
                              radius: 12,
                              child: Icon(Icons.arrow_forward_ios_outlined, color: primaryColor, size: 14),
                            )
                          ],
                        ).paddingSymmetric(horizontal: 20.0, vertical: 14.0),
                      ).marginSymmetric(horizontal: 20.0, vertical: 10.0).onTap(() {
                        Get.back();
                        Get.toNamed(AppRoutes.chooseSupplierView)?.then((value) {
                          if (value != null) {
                            controller.currentPage.value = 1;
                            controller.getInventoryData();
                            Get.find<DashboardController>().getSummary();
                          }
                        });
                      }),
                      const SizedBox(
                        height: 20.0,
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

  _filtersBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      useRootNavigator: false,
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vGap(20.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(width: 1, color: textFieldBorderColor),
                        ),
                        child: Row(
                          children: [
                            imageAsset(filter, height: 14.0, color: black),
                            hGap(14.0),
                            TextView(Strings.filter,
                                style: black_17_600()
                                    ?.copyWith(fontSize: 14, color: black)),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: primaryLightColor,
                              radius: 12,
                              child: Icon(Icons.arrow_forward_ios_outlined,
                                  color: primaryColor, size: 14),
                            )
                          ],
                        ).paddingSymmetric(horizontal: 20.0, vertical: 12.0),
                      )
                          .marginOnly(left: 20.0, right: 20.0, bottom: 8.0)
                          .onTap(() {
                            Utils.showSnackBar("Coming Soon");
                      }),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     // color: textFieldBorderColor,
                      //     borderRadius: BorderRadius.circular(10.0),
                      //     border: Border.all(width: 1, color: textFieldBorderColor),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       imageAsset(search,height: 14.0,color: black),
                      //       hGap(10.0),
                      //       TextView(Strings.search,style: black_17_600()?.copyWith(fontSize: 14,color: black)),
                      //       const Spacer(),
                      //       CircleAvatar(
                      //         backgroundColor: primaryLightColor,
                      //         radius: 12,
                      //         child: Icon(Icons.arrow_forward_ios_outlined, color: primaryColor,size: 14),
                      //       )
                      //     ],
                      //   ).paddingSymmetric(horizontal: 20.0,vertical: 12.0),
                      // ).marginOnly(left: 20.0,right: 20.0,bottom: 8.0).onTap(() {}),
                      const SizedBox(
                        height: 20.0,
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

  // editProductBottomSheet(ProductModal product) {
  //   debugPrint("=>sds ${product.productImage}");
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     useRootNavigator: false,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext bc) => GestureDetector(
  //       child: Stack(
  //         children: [
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const SizedBox(
  //                 height: 27,
  //               ),
  //               Container(
  //                 width: Get.width,
  //                 padding: const EdgeInsets.symmetric(
  //                     vertical: 15, horizontal: margin_20),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   shape: BoxShape.rectangle,
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     vGap(10.0),
  //                     Row(
  //                       children: [
  //                         Container(
  //                           height: 60,
  //                           width: 60,
  //                           padding: const EdgeInsets.all(8.0),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             border: Border.all(
  //                                 width: 1, color: textFieldBorderColor),
  //                           ),
  //                           child: product.productImage != null
  //                               ? ClipRRect(
  //                                   borderRadius: BorderRadius.circular(10.0),
  //                                   child: ShimmerImage(
  //                                       url: controller.extractImagePath(product.productImage ?? ""),
  //                                       withBaseUrl: true,
  //                                       thumbnail: fileIcon,
  //                                       fit: BoxFit.cover)) : imageAsset(fileIcon),
  //
  //                           // imageAsset(fileIcon),
  //                         ),
  //                         hGap(20.0),
  //                         Expanded(
  //                           child: TextView(product.name ?? "",
  //                               maxLine: 3,
  //                               style: black_16_400()?.copyWith(
  //                                   color: primaryColor,
  //                                   fontWeight: FontWeight.w600)),
  //                         ),
  //                       ],
  //                     ),
  //                     vGap(10.0),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(vertical: 12.0),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                               border: Border.all(width: 1, color: textFieldBorderColor)),
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 imageAsset(updateqtyIcon,
  //                                     width: 20.0, color: black),
  //                                 vGap(6.0),
  //                                 TextView("Update Quantity", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
  //                               ],
  //                             ),
  //                           ).onTap(() {
  //                             Get.back();
  //                             if(product.expiries?.isNotEmpty ?? false) {
  //                               Get.toNamed(AppRoutes.updateQuantity, arguments: {RoutesArgument.productDetails: product})?.then((value) {
  //                                 if (value != null) {
  //                                   controller.currentPage.value = 1;
  //                                   controller.getInventoryData();
  //                                 }
  //                               });
  //                             } else {
  //                               Utils.showSnackBar("This product don't have quantity and expiry");
  //                             }
  //
  //                           }),
  //                         ),
  //                         hGap(20.0),
  //                         Expanded(
  //                             child: Container(
  //                           padding: const EdgeInsets.symmetric(vertical: 12.0),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             border: Border.all(
  //                                 width: 1, color: textFieldBorderColor),
  //                           ),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               imageAsset(moveIcon, width: 20.0, color: black),
  //                               vGap(6.0),
  //                               TextView("Move Storage", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
  //                             ],
  //                           ),
  //                         ).onTap(() {
  //                           Get.back();
  //                           if(product.expiries?.isNotEmpty ?? false){
  //                             Get.toNamed(AppRoutes.moveStorage, arguments: {RoutesArgument.productDetails: product})?.then((value) {
  //                               if (value != null) {
  //                                 controller.currentPage.value = 1;
  //                                 controller.getInventoryData();
  //                               }
  //                             });
  //                           } else {
  //                             Utils.showSnackBar("This product don't have quantity and expiry");
  //                           }
  //                         })),
  //                       ],
  //                     ),
  //                     vGap(10.0),
  //                     BottomSheetItem(
  //                       title: "Consumption",
  //                       iconUri: consumIcon,
  //                       onItemTap:() {
  //                         Get.back();
  //                         if(product.expiries?.isNotEmpty ?? false){
  //                           Get.toNamed(AppRoutes.addConsumptionScreen, arguments: {RoutesArgument.productDetails: product})?.then((value) {
  //                             if (value != null) {
  //                               controller.currentPage.value = 1;
  //                               controller.getInventoryData();
  //                             }
  //                           });
  //                         } else {
  //                           Utils.showSnackBar("This product don't have quantity and expiry");
  //                         }
  //                       },
  //                     ),
  //                     vGap(10.0),
  //                     BottomSheetItem(
  //                       title: "Add to basket",
  //                       iconUri: addBasketIcon,
  //                       onItemTap:() {
  //                         Get.back();
  //                         controller.addToBasket(product.id ?? 0);
  //                       },
  //                     ),
  //                     vGap(10.0),
  //                     BottomSheetItem(
  //                       title: "Edit Product",
  //                       iconUri: editIcon,
  //                       onItemTap: () {
  //                         Get.back();
  //                         Get.toNamed(AppRoutes.addManualProduct, arguments: {
  //                           RoutesArgument.productDetails: product,
  //                           RoutesArgument.isEdit: true,
  //                           RoutesArgument.productType: ProductType.edit
  //                         })?.then((value) {
  //                           if (value != null) {
  //                             controller.currentPage.value = 1;
  //                             controller.getInventoryData();
  //                           }
  //                         });
  //                       },
  //                     ),
  //                     vGap(10.0),
  //                     BottomSheetItem(
  //                       title: "View Product",
  //                       iconUri: viewIcon,
  //                       onItemTap: () {
  //                         Get.back();
  //                         Get.toNamed(AppRoutes.productDetailScreen,
  //                             arguments: {
  //                               RoutesArgument.productDetails: product,
  //                               RoutesArgument.addRestock: false
  //                             })?.then((value) {
  //                           controller.searchController.clear();
  //                           controller.getInventoryData();
  //                           // controller.showAndHideSearchBar();
  //                         });
  //                       },
  //                     ),
  //                     vGap(10.0),
  //                     BottomSheetItem(
  //                       title: "Add Barcode",
  //                       iconUri: scanIcon,
  //                       onItemTap: () {
  //                         Get.back();
  //                         Get.toNamed(AppRoutes.scannerScreen)?.then((value) {
  //                           if (value != null) {
  //                             BarcodeModal? barcode = value;
  //                             controller.addBarCode(
  //                                 addBarcodeDto: AddBarcodeDto(
  //                                     localMappingId: product.localMappingId,
  //                                     supplierCode: product.supplierCode,
  //                                     supplierId: product.supplier?.id,
  //                                     ApiRequest: true,
  //                                     commands: [
  //                                       CommandsDto(
  //                                           symbology: barcode?.symbology ?? "",
  //                                           barcode: barcode?.barcode ?? "",
  //                                           command: 1)
  //                                     ]
  //                                 )
  //                             );
  //                             // controller.checkBarCodeAdded(value, onGettingItemTap: () {
  //                             //   Utils.showSnackBar("Bar Code Already Added");
  //                             // }, onNotGettingItemTap: () {
  //                             // });
  //                           }
  //                         });
  //                       },
  //                     ),
  //                     // vGap(10.0),
  //                     // BottomSheetItem(
  //                     //   title: "Clone",
  //                     //   iconUri: cloneIcon,
  //                     //   onItemTap: () {},
  //                     // ),
  //                     // vGap(10.0),
  //                     // BottomSheetItem(
  //                     //   title: "Delete Product",
  //                     //   iconUri: deleteIcon,
  //                     //   onItemTap: () {
  //                     //     Get.back();
  //                     //
  //                     //     controller.showAlertDialog(product);
  //                     //   },
  //                     // ),
  //                     SizedBox(
  //                       height: 20.h,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Positioned(
  //             right: 16,
  //             top: 0,
  //             child: Container(
  //               height: 54,
  //               width: 54,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: primaryColor,
  //               ),
  //               child: IconButton(
  //                 onPressed: () {
  //                   Get.back();
  //                 },
  //                 icon: const Icon(
  //                   Icons.close,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       onTap: () {
  //         FocusScope.of(Get.context!).requestFocus(FocusScopeNode());
  //       },
  //     ),
  //   );
  // }
}

// class LoaderMoreButton extends StatelessWidget {
//   final GestureTapCallback onTap;
//
//   const LoaderMoreButton({
//     super.key,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onTap,
//         child: Container(
//             margin: const EdgeInsets.symmetric(vertical: margin_20),
//             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//             decoration: BoxDecoration(
//                 color: primaryColor,
//                 border: Border.all(color: primaryColor, width: 1),
//                 borderRadius: BorderRadius.circular(6.0)),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextView(
//                   "Load more",
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 13),
//                 ),
//                 hGap(6.0),
//                 const Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 18,
//                 )
//               ],
//             )));
//   }
// }
