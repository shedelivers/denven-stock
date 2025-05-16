
import 'package:denvin_stock/components/arrived_item_card.dart';
import 'package:denvin_stock/exports.dart';


class ScanArrivedItemsScreen extends GetView<ScanArrivedItemsController> {

  ScanArrivedItemsScreen({super.key}) {
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
                Strings.scanArrivedItems,
                style: whiteColor_18_700()?.copyWith(color: primaryColor),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      controller.showAndHideSearchBar();
                    },
                    icon: imageAsset(search, width: 18, color: Colors.black)
                ),
              ],
            ) : AppBar(leadingWidth: 60,
                      scrolledUnderElevation: 0,
                      titleSpacing: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.getArrivedItemData();
                          controller.showAndHideSearchBar();
                        },
                      ),
                      title: Row(
                      children: [
                        Expanded(
                            child: CustomTextFieldV3(
                              hintText: Strings.searchOrder,
                              controller: controller.searchController,
                              focusNode: controller.searchFocusNode,
                              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
                              onChanged: (value) {controller.currentPage.value = 0;
                                if (controller.debounce?.isActive ?? false) {
                                  controller.debounce?.cancel();
                                }
                                controller.debounce = Timer(const Duration(milliseconds: 500), () {controller.getArrivedItemData();});
                              },
                              prefix: IconButton(
                                onPressed: () {},
                                icon: imageAsset(search, height: 16.0),
                              ),
                            ).marginOnly(right: 20.0)),
                ],
              ),
            ),
            body:
            _mainBuild()),
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
                // Refresh the data when the user pulls down
                await Get.find<DashboardController>().getSummary(); // Refresh summary data
                await controller.getArrivedItemData(showLoading: false); // Refresh the product list
              },
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8) {
                    // Load more data when the user reaches the bottom
                    if ((getTotalPage() - 1) >= controller.currentPage.value &&
                        controller.shimmerLoaderState == ShimmerLoaderState.fetched &&
                        controller.products.isNotEmpty) {
                      controller.currentPage.value = (controller.implantProductlist?.response?.page ?? 0) + 1;
                      controller.getPaginationArrivedItemData(addMore: true, showLoading: false);
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.products.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (controller.isLoading.value) {
                      return Utils.circularLoader(marginTop: 30);
                    }

                    if (controller.products.isEmpty) {
                      return Utils.noDataFound(message: "No Product Found").marginOnly(top: 20.0);
                    }

                    if (index < controller.products.length) {
                      ArrivedItemModal? product = controller.products[index];
                      return ArrivedItemCard(
                        imagePath: null,
                        name: product.supplierName,
                        isThreeDotsActive: false,
                        supplierCode: product.orderCode,
                        orderAt: product.issuedAt ?? "",
                        price: product.totalCost,
                        cardOnTap: () {
                          Get.toNamed(AppRoutes.arrivedItemDetailScreen,
                              arguments: {RoutesArgument.productDetails: product, RoutesArgument.addRestock: false})
                              ?.then((value) {
                            if (value != null) {
                              controller.searchController.clear();
                              controller.getArrivedItemData();
                              Get.find<DashboardController>().getArrivedCount();
                            }
                          });
                        },
                        menuOnTap: () {
                          _editProductBottomSheet(product);
                        },
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    );
                  },
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
                            controller.getArrivedItemData();
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
                          .onTap(() {}),
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

  _editProductBottomSheet(ArrivedItemModal product) {
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
                            child: imageAsset(imageIcon),
                            // product.productImage != null
                            //     ? ClipRRect(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     child: ShimmerImage(
                            //         url: controller.extractImagePath(
                            //             product.productImage ?? ""),
                            //         withBaseUrl: true,
                            //         thumbnail: fileIcon,
                            //         fit: BoxFit.cover))
                            //     : imageAsset(fileIcon),
                            // imageAsset(fileIcon),
                          ),
                          hGap(20.0),
                          Expanded(
                            child: TextView(
                                product.supplierName ?? "",
                                maxLine: 3,
                                style: black_16_400()?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
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
                                  imageAsset(plusMinusIcon,
                                      width: 20.0, color: black),
                                  vGap(6.0),
                                  TextView("Update Quantity", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
                                ],
                              ),
                            ).onTap(() {
                              Get.back();
                              Get.toNamed(AppRoutes.updateQuantity, arguments: {
                                RoutesArgument.productDetails: product
                              })?.then((value) {
                                if (value != null) {
                                  controller.currentPage.value = 1;
                                  controller.getArrivedItemData();
                                }
                              });
                            }),
                          ),
                          hGap(20.0),
                          Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      width: 1, color: textFieldBorderColor),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    imageAsset(moveIcon, width: 20.0, color: black),
                                    vGap(6.0),
                                    TextView("Return", style: primaryColor_16_700()?.copyWith(color: black, fontSize: 14)),
                                  ],
                                ),
                              ).onTap(() {
                                Get.back();
                                Get.toNamed(AppRoutes.returnProduct, arguments: {
                                  RoutesArgument.productDetails: product
                                })?.then((value) {
                                  // if (value != null)
                                  {
                                    Get.back();
                                    controller.currentPage.value = 1;
                                    controller.getArrivedItemData();
                                    Get.find<DashboardController>().getSummary();
                                  }
                                });

                                //     ?.then((value) {
                                //   Get.back();
                                //
                                // });
                              })),
                        ],
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
                          })?.then((value) {
                            if (value != null) {
                              controller.currentPage.value = 1;
                              controller.getArrivedItemData();
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
                            controller.searchController.clear();
                            controller.getArrivedItemData();
                            // controller.showAndHideSearchBar();
                          });
                        },
                      ),
                      vGap(10.0),
                      BottomSheetItem(
                        title: "Add Barcode",
                        iconUri: scanIcon,
                        onItemTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.scannerScreen)?.then((value) {
                            // if (value != null) {
                            //   BarcodeModal? barcode = value;
                            //   controller.addBarCode(
                            //       addBarcodeDto: AddBarcodeDto(
                            //           localMappingId: product.localMappingId,
                            //           supplierCode: product.supplierCode,
                            //           supplierId: product.supplier?.id,
                            //           ApiRequest: true,
                            //           commands: [
                            //             CommandsDto(
                            //                 symbology: barcode?.symbology ?? "",
                            //                 barcode: barcode?.barcode ?? "",
                            //                 command: 1)
                            //           ]
                            //       )
                            //   );
                            //   // controller.checkBarCodeAdded(value, onGettingItemTap: () {
                            //   //   Utils.showSnackBar("Bar Code Already Added");
                            //   // }, onNotGettingItemTap: () {
                            //   //
                            //   // });
                            // }
                          });
                        },
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
}

/*class LoaderMoreButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const LoaderMoreButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: margin_20),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(6.0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  "Load more",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13),
                ),
                hGap(6.0),
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                )
              ],
            )));
  }
 }*/
