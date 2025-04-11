import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/basket_product_detail_controller.dart';

class BasketProductDetailScreen extends GetView<BasketProductDetailController> {
  final formGlobalKey = GlobalKey<FormState>();

  BasketProductDetailScreen({super.key}) {
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Obx(
        ()=> Scaffold(
            backgroundColor: Colors.white,
            appBar: myAppBar(
                showBack: true,
                showLogo: false,
                title: "Product Detail",
                centerLogo: true),
            body: _mainBody()),
      ),
    );
  }

  _mainBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _banner(),
          _enterProductName(),
          _otherDetails(),
          _showMoreFields(),
          // _addQrAndBarCode(),
          vGap(20.0),
        ],
      ),
    );
  }

  _banner() {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          controller.showBannerCode.value ? controller.products.value?.productImage !=null && controller.products.value!.productImage!.isNotEmpty ?
          FullScreenWidget(
            isOpen: (isOpen){
            },
            disposeLevel: DisposeLevel.Low,
            child: SizedBox(
                    width: Get.width,
                    height: 200,
                    child: ShimmerImage(
                      url: controller.products.value?.productImage != null  ? "${ApiConstants.baseUrlForImage}/${controller.extractImagePath(controller.products.value?.productImage ?? "")}" : "",
                      fit: BoxFit.cover,
                    ),
                  )) : SizedBox(
                        width: Get.width,
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageAsset(blankImageIcon, color: Colors.grey, height: 40),
                              Utils.noDataFound(
                                  message: "No banner added to this product"),
                            ],
                          ),
                        ),
                      )
              : const SizedBox(),
          // _barCodeSlider(),
          // Positioned(
          //   left: 10,
          //   bottom: 10,
          //   child: Container(
          //     width: 80,
          //     height: 30,
          //     padding: const EdgeInsets.all(3),
          //     decoration: BoxDecoration(
          //         color: textFieldBorderColor,
          //         borderRadius: BorderRadius.circular(8.0)),
          //     child: Obx(
          //       () => Row(
          //         children: [
          //           Container(
          //             height: 25,
          //             width: 37,
          //             decoration: BoxDecoration(
          //                 color: controller.showBannerCode.value
          //                     ? whiteColor
          //                     : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(5.0)),
          //             child: Icon(
          //               Icons.image,
          //               color: black,
          //               size: 18,
          //             ),
          //           ),
          //           Container(
          //             height: 25,
          //             width: 37,
          //             padding: const EdgeInsets.all(3),
          //             decoration: BoxDecoration(
          //                 color: controller.showBannerCode.value
          //                     ? Colors.transparent
          //                     : whiteColor,
          //                 borderRadius: BorderRadius.circular(5.0)),
          //             child: imageAsset(scanIcon, color: black),
          //           ),
          //         ],
          //       ).onTap(() {
          //         controller.showBannerCode.value = !controller.showBannerCode.value;
          //       }),
          //     ),
          //   ),
          // ),
          // if(getBarCodeCount(controller.products.value?.barcode) != 0) controller.showBannerCode.value == false ? Positioned(
          //   right: 10,
          //   bottom: 10,
          //   child: Container(
          //     width: 60,
          //     height: 30,
          //     decoration: BoxDecoration(
          //         color: Colors.black.withOpacity(0.1),
          //         borderRadius: BorderRadius.circular(8.0)
          //     ),
          //     child: Center(child: Text(" ${controller.currentBarcodeIndex.value} / ${getBarCodeCount(controller.products.value?.barcode)}")),
          //   ),
          // ) : const SizedBox()
        ],
      ),
    );
  }

  // _barCodeSlider() {
  //   return getBarCodeCount(controller.products.value?.barcode) != 0
  //       ? CarouselSlider(
  //           options: CarouselOptions(
  //             height: 200.0,
  //             autoPlay: false,
  //             disableCenter: false,
  //             enlargeCenterPage: true,
  //             enableInfiniteScroll: false,
  //             viewportFraction: 1.0,
  //             onPageChanged: (index, reason) {
  //               controller.currentBarcodeIndex.value = index + 1;
  //             },
  //           ),
  //           items: getBarCodeList(controller.products.value?.barcode).map((i) {
  //             return Builder(
  //               builder: (BuildContext context) {
  //                 return Container(
  //                   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0, top: 10),
  //                   width: Get.width,
  //                   height: 180,
  //                   child: BarcodeWidget(
  //                     barcode: Barcode.code128(escapes: true),
  //                     data: i,
  //                     height: 140,
  //                   ),
  //                 );
  //               },
  //             );
  //           }).toList(),
  //         ) : SizedBox(
  //           width: Get.width,
  //           height: 200,
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 imageAsset(barIcon, color: Colors.grey, height: 40),
  //                 Utils.noDataFound(
  //                     message: "No barcode added to this product"),
  //               ],
  //             ),
  //           ),
  //         );
  // }

  _enterProductName() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 14.0),
      color: const Color(0xfff2f2f2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            Strings.product,
            style: black_14_600()?.copyWith(color: const Color(0xff707070)),
          ),
          vGap(4.0),
          TextView(controller.products.value?.name ?? Strings.nA, maxLine: 3,style: black_14_600()?.copyWith(color: black, fontSize: 15)),
        ],
      ),
    );
  }


  _otherDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.quantity,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller.products.value?.quantity != null
                            ? controller.products.value?.quantity.toString() ??
                                "0"
                            : "0",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
            Container(
              height: 60.0,
              width: 1,
              color: const Color(0xffe3e3e3),
            ),
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.minimumLevel,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller.products.value?.minLevel.toString() ??
                            Strings.nA,
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            )
          ],
        ),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.price,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller.products.value?.price != null
                            ? "£ ${controller.products.value?.price.toString()}"
                            : "£00.00",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
            Container(
              height: 60.0,
              width: 1,
              color: const Color(0xffe3e3e3),
            ),
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.totalPrice,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(getTotalQty(),
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
          ],
        ),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
      ],
    );
  }

  String getTotalQty() {
    num price;
    double qty;
    if (controller.products.value?.price != null &&
        controller.products.value?.quantity != null) {
      price = double.parse(controller.products.value?.price.toString()??"0.0");
      qty = controller.products.value?.quantity?.toDouble() ?? 0.0;
      return "£ ${(price * qty).toStringAsFixed(2)}";
    } else {
      return "£00.00";
    }
  }

  _showMoreFields() {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        controller: controller.expansionTileController,
        iconColor: primaryColor,
        // collapsedIconColor: Colors.transparent,
        // iconColor: Colors.transparent,
        childrenPadding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        title: Row(
          children: [
            // Icon(
            //   Icons.keyboard_arrow_down,
            //   color: primaryColor,
            // ),
            // hGap(8.0),
            Text(
              Strings.showMoreDetails,
              style: black_15_700()?.copyWith(color: primaryColor),
            ),
          ],
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.storage,
                      style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller.products.value?.storage?.name ?? Strings.nA,
                        style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView(
                      Strings.supplierCode,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(controller.products.value?.supplierCode ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          vGap(24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.supplier,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(controller.products.value?.supplier?.name ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView(
                      Strings.orderDate,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller.products.value?.orderedAt != null ? controller.convertDateFormat(controller.products.value?.orderedAt ?? "") : Strings.nA,
                        style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          vGap(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.manufacture,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(controller.products.value?.manufacturer ?? Strings.nA, maxLine: 2, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                    vGap(20.0),
                    if(controller.products.value?.note != null && controller.products.value!.note!.isNotEmpty) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          Strings.note,
                          style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                        ),
                        vGap(4.0),
                        TextView(
                            controller.products.value?.note?.isEmpty ?? true ? Strings.nA : controller.products.value?.note ?? Strings.nA,
                            maxLine: 2,
                            style: black_14_600()?.copyWith(color: black, fontSize: 15)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView("${Strings.expiryDate}   Qty",
                      style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    if (controller.products.value?.expiries?.isEmpty ?? true)
                      TextView(Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                    ...List.generate(
                      controller.products.value?.expiries?.length ?? 0,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextView("${controller.convertExpiryDateFormat(controller.products.value?.expiries?[index].at ?? Strings.nA)} ", style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15)),
                          TextView("  ${controller.products.value?.expiries?[index].qty}", style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  // _addQrAndBarCode() {
  //   return Column(
  //     children: [
  //       Container(
  //         height: 1.0,
  //         width: Get.width,
  //         color: const Color(0xffe3e3e3),
  //       ),
  //       vGap(10.0),
  //       Row(
  //         children: [
  //           TextView(
  //             Strings.qrBarCode,
  //             style: black_15_700()?.copyWith(color: greyIconColor),
  //           ),
  //           const Spacer(),
  //           TextView(
  //             "${getBarCodeCount(controller.products.value?.barcode)} barcode",
  //             style: black_15_700()?.copyWith(color: primaryColor),
  //           )
  //         ],
  //       ).marginSymmetric(horizontal: 20.0),
  //       vGap(10.0),
  //       ...List.generate(getBarCodeCount(controller.products.value?.barcode), (index) {
  //         return Row(
  //           children: [
  //             IconButton(onPressed: () {}, icon: imageAsset(barIcon, color: black, height: 20)),
  //             hGap(20.0),
  //             Expanded(child: TextView(
  //               getBarCodeText(controller.products.value?.barcode, index),
  //               style: black_14_600()?.copyWith(color: black),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 20.0,
  //             ),
  //           ],
  //         ).marginSymmetric(horizontal: 20.0);
  //       }),
  //       // Row(
  //       //   children: [
  //       //     IconButton(
  //       //         onPressed: () {},
  //       //         icon: imageAsset(scanIcon, color: hintTextColor, height: 20)),
  //       //     const Spacer(),
  //       //     TextView(
  //       //       Strings.addQrBarcode,
  //       //       style: black_14_600()?.copyWith(color: hintTextColor),
  //       //     ),
  //       //     const Spacer(),
  //       //     const SizedBox(
  //       //       width: 20.0,
  //       //     ),
  //       //   ],
  //       // ).marginSymmetric(horizontal: 20.0),
  //     ],
  //   );
  // }

  int getBarCodeCount(List<BarcodeAPIModal>? barcode) {
    if (barcode?.isEmpty ?? true) {
      return 0;
    }
    if (barcode?[0].barcodes?.isEmpty ?? true) {
      return 0;
    }
    return barcode?[0].barcodes?.length ?? 0;
  }

  List<String> getBarCodeList(List<BarcodeAPIModal>? barcode) {
    if (barcode?.isEmpty ?? true) {
      return [];
    }
    if (barcode?[0].barcodes?.isEmpty ?? true) {
      return [];
    }
    List<String> codes = [];
    for (var myCode in barcode?[0].barcodes ?? []) {
      codes.add(myCode.barcode);
    }
    return codes;
  }

  String getBarCodeText(List<BarcodeAPIModal>? barcode, int index) {
    if (barcode?.isEmpty ?? true) {
      return "";
    }
    if (barcode?[0].barcodes?.isEmpty ?? true) {
      return "";
    }
    return barcode?[0].barcodes?[index].barcode ?? "N/A";
  }






  getExpansionPanelListView(){

  }
}
