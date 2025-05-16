import 'package:denvin_stock/components/colors.dart';
import 'package:denvin_stock/components/common_webview_screen.dart';
import 'package:denvin_stock/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InventoryProductDetailScreen extends GetView<InventoryProductController> {
  final formGlobalKey = GlobalKey<FormState>();

  InventoryProductDetailScreen({super.key}) {
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child:  Obx(() => Scaffold(
              backgroundColor: Colors.white,
              appBar: myAppBar(
                  showBack: true,
                  showLogo: false,
                  title: "Product Detail",
                  centerLogo: true,
                  showOcrButton: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 36,
                    width: 36,
                    child: IconButton(
                        onPressed: (){
                          if(!controller.isLoading.value){
                            Get.toNamed(AppRoutes.addManualProduct, arguments: {
                              RoutesArgument.productDetails: controller.products.value,
                              RoutesArgument.isEdit: true,
                              RoutesArgument.productType: ProductType.edit
                            })?.then((value) {
                              if (value != null) {
                                controller.getProductById();
                              }
                            });
                          }
                        },
                        icon: Image.asset(editIcon)),
                  )),
              body: controller.isLoading.value ? Utils.circularLoader() : _mainBody()),
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
          _tags(),
          _addQrAndBarCode(),
          vGap(20.0),
          _addToBasket(),
          vGap(20.0),
        ],
      ),
    );
  }

  _addToBasket(){
    return controller.showAddToCart.value ?  AppButton(
      onTap: (){
        controller.addToBasket();
      }, buttonText: "Add to basket"
    ).marginSymmetric(horizontal: 20.0) : const SizedBox();
  }

  _banner() {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          controller.showBannerCode.value ? controller.products.value?.productImage !=null && controller.products.value!.productImage!.isNotEmpty ?
          SizedBox(
                  width: Get.width,
                  height: 200,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: 200,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: false,
                            viewportFraction: 1.0,
                            onPageChanged: (index, carouselPageChangedReason){
                              controller.productCarouselIndex.value = index;
                            }
                          ),
                          items: controller.products.value?.productImage?.map((i) {
                            return FullScreenWidget(
                              isOpen: (isOpen){

                              },
                              disposeLevel: DisposeLevel.Low,
                              child: Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ShimmerImage(
                                    url: i,
                                    //  url: controller.products.value?.productImage != null  ? "${ApiConstants.baseUrlForImage}/${controller.extractImagePath(controller.products.value?.productImage?[0] ?? "")}" : "",
                                    fit: BoxFit.cover,
                                  )
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < (controller.products.value?.productImage?.length ?? 0); i++)
                                Container(
                                  height: 10,
                                  width: 10,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: controller.productCarouselIndex.value == i? primaryColor:greyText,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  // child: ShimmerImage(
                  //   url: controller.products.value?.productImage?[0]??"",
                  // //  url: controller.products.value?.productImage != null  ? "${ApiConstants.baseUrlForImage}/${controller.extractImagePath(controller.products.value?.productImage?[0] ?? "")}" : "",
                  //   fit: BoxFit.cover,
                  // ),

                ) : SizedBox(
                        width: Get.width,
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageAsset(blankImageIcon, color: Colors.grey, height: 40),
                              Utils.noDataFound(
                                  message: "Image not uploaded"),
                            ],
                          ),
                        ),
                      )
              : _barCodeSlider(),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              width: 80,
              height: 30,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: textFieldBorderColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Obx(
                () => Row(
                  children: [
                    Container(
                      height: 25,
                      width: 37,
                      decoration: BoxDecoration(
                          color: controller.showBannerCode.value
                              ? whiteColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Icon(
                        Icons.image,
                        color: black,
                        size: 18,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 37,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: controller.showBannerCode.value
                              ? Colors.transparent
                              : whiteColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: imageAsset(scanIcon, color: black),
                    ),
                  ],
                ).onTap(() {
                  controller.showBannerCode.value = !controller.showBannerCode.value;
                }),
              ),
            ),
          ),
          if(getBarCodeCount(controller.products.value?.barcode) != 0) controller.showBannerCode.value == false ? Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Center(child: Text(" ${controller.currentBarcodeIndex.value} / ${getBarCodeCount(controller.products.value?.barcode)}")),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }

  _barCodeSlider() {
    return getBarCodeCount(controller.products.value?.barcode) != 0
        ? CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: false,
              disableCenter: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                controller.currentBarcodeIndex.value = index + 1;
              },
            ),
            items: getBarCodeList(controller.products.value?.barcode).map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0, top: 10),
                    width: Get.width,
                    height: 180,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(escapes: true),
                      data: i,
                      height: 140,
                    ),
                  );
                },
              );
            }).toList(),
          ) : SizedBox(
            width: Get.width,
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageAsset(barIcon, color: Colors.grey, height: 40),
                  Utils.noDataFound(
                      message: "No barcode added to this product"),
                ],
              ),
            ),
          );
  }

  _enterProductName() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
      color: const Color(0xfff2f2f2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextView(
                Strings.product,
                style: black_14_600()?.copyWith(color: const Color(0xff707070)),
              ),

              Visibility(
                visible: controller.products.value?.link != null && controller.products.value?.link != "",
                child: GestureDetector(
                  onTap: (){
                    Get.to(() => CommonWebViewScreen(
                        url: controller.products.value?.link??"",
                        title: Strings.product)
                    );
                  },
                  child: SizedBox(
                      width: 40,
                      child: Center(child: Icon(CupertinoIcons.link, color: primaryColor,size: 20,))),
                ),
              )
            ],
          ),
          vGap(4.0),
          SelectableText(controller.products.value?.name ?? Strings.nA,style: black_14_600()?.copyWith(color: black, fontSize: 15)),
        ],
      ),
    );
  }

  _tags(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vGap(10.0),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        vGap(10.0),
        TextView(
          Strings.tags,
          style: black_14_600()?.copyWith(color: const Color(0xff707070)),
        ).marginSymmetric(horizontal: 20.0),
        vGap(10.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            children: [
              ...List.generate(controller.products.value?.tags?.length ?? 0, (index) {
                String myTag = controller.products.value?.tags![index] ?? "";
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 14.0),
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                 // child: SelectableText(myTag ?? "",style: const TextStyle(fontSize: 14),maxLines: 1,),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectableText(myTag ?? "",style: const TextStyle(fontSize: 14),maxLines: 1,),
                    ],
                  ),
                );
              }),
            ],
          ),
        ).marginSymmetric(horizontal: 20.0),
        if(controller.products.value?.tags!.isNotEmpty ?? false) vGap(10.0),
      ],
    );
  }

  _actionButtons() {
    return controller.addRestock.value == false ? Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    Get.toNamed(AppRoutes.addProstheticsScreen, arguments: {
                      RoutesArgument.productDetails: controller.products.value
                    })?.then((value) {
                      if(value != null){
                        if(value == "BACK"){
                          Get.back(result: "BACK");
                        }
                      }
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryLightColor.withOpacity(0.7),
                        child: imageAsset(prostheticsIcon, height: 20.0),
                      ),
                      vGap(4.0),
                      TextView("Add Prosthetics".toUpperCase(), style: black_12_600()?.copyWith(color: greyIconColor)),
                    ],
                  ).paddingAll(10.0),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    Get.toNamed(AppRoutes.addPlacements, arguments: {
                      RoutesArgument.productDetails: controller.products.value
                    })?.then((value) {
                      if(value != null){
                        if(value == "BACK"){
                          Get.back(result: "BACK");
                        }
                      }
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryLightColor.withOpacity(0.7),
                        child: imageAsset(placementIcon, height: 20.0),
                      ),
                      vGap(4.0),
                      TextView("Add Placement".toUpperCase(),
                          style:
                              black_12_600()?.copyWith(color: greyIconColor)),
                    ],
                  ).paddingAll(10.0),
                ),
              ],
            ),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: primaryColor, width: 1)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 14,
                  ),
                  hGap(3.0),
                  Text(
                    "Add Restock",
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  )
                ],
              ),
            ).onTap(() {
              _addRestockBottomSheet();
            }),
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
                    SelectableText(
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
                    SelectableText(
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
                      Strings.unitPrice,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    SelectableText(
                        controller.products.value?.type == 1?"-":
                        controller.products.value?.expiries != null && controller.products.value!.expiries!.isNotEmpty && controller.products.value?.expiries?.last.price != "null"
                            ? "£ ${controller.products.value?.expiries?.last.price.toString()}"
                            : "£00.00",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),


                    /*TextView(controller.products.value?.type == 1?Strings.unitPrice:
                      Strings.totalPrice,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    SelectableText(
                        controller.products.value?.price != null
                            ? "£ ${
                            controller.products.value?.type == 1?
                            controller.products.value?.expiries?.first.price??"00.00"
                                :controller.products.value?.price.toString()}"
                            : "£00.00",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),*/
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
                    SelectableText(
                        controller.products.value?.type == 1?"-":
                        controller.products.value?.quantity == 0?"0":
                        controller.products.value?.price != null
                            ? "£ ${controller.products.value?.price.toString()}"
                            : "£00.00",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),

                    /*TextView(
                      Strings.supplierCode,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    SelectableText(controller.products.value?.supplierCode ?? Strings.nA,
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),*/

                    // SelectableText(controller.products.value?.supplierCode ?? Strings.nA,
                    //     style: black_14_600()
                    //         ?.copyWith(color: black, fontSize: 15)),


                    /*TextView(getTotalPrice(),
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),*/
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

  String getTotalPrice() {
    num price;
    double qty;
    if(controller.products.value?.type != null) {
      if(controller.products.value?.type == 1) {
        price = controller.products.value?.price ?? 0.0;
        return "£ ${(price).toStringAsFixed(2)}";
      }
    }
    if (controller.products.value?.price != null &&
        controller.products.value?.quantity != null) {
      price = controller.products.value?.price ?? 0.0;
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
        controller: controller.expansionTileController,
        iconColor: primaryColor,
        //iconColor: Colors.transparent,
       // collapsedIconColor: Colors.transparent,
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        title: Row(
          children: [
            // Visibility(
            //   visible: controller.expansionTileController.isExpanded,
            //   replacement: Icon(
            //     Icons.keyboard_arrow_up,
            //     color: primaryColor,
            //   ),
            //   child: Icon(
            //     Icons.keyboard_arrow_down,
            //     color: primaryColor,
            //   ),
            // ),
            //hGap(8.0),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                    Strings.storage,
                    style: black_14_600()
                        ?.copyWith(color: const Color(0xff707070)),
                  ),
                  vGap(4.0),
                  SelectableText(
                      controller.products.value?.storage?.name ?? Strings.nA,
                      style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                ],
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
                    SelectableText(controller.products.value?.supplierCode ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  //  SelectableText(controller.products.value?.manufacturer ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
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
                    SelectableText(controller.products.value?.supplier?.name ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextView(
                    Strings.orderDate,
                    style: black_14_600()
                        ?.copyWith(color: const Color(0xff707070)),
                  ),
                  vGap(4.0),
                  SelectableText(
                      controller.products.value?.orderedAt != null ? controller.convertDateFormat(controller.products.value?.orderedAt ?? "") : Strings.nA,
                      style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                ],
              ),
            ],
          ),
          vGap(24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(Strings.expiryDate,
                    style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                  ),
                  vGap(4.0),
                  if (controller.products.value?.expiries?.isEmpty ?? true)
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                        margin: const EdgeInsets.only(bottom: 6.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6.0)
                        ),
                        child: SelectableText(Strings.nA, style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15))),

                  ...List.generate(
                    controller.products.value?.expiriesWithPrice?.length ?? 0,
                        (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        controller.products.value?.expiriesWithPrice?[index].date  != null && controller.products.value!.expiriesWithPrice![index].date!.isNotEmpty ?? false?
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                            margin: const EdgeInsets.only(bottom: 6.0),
                            decoration: BoxDecoration(
                                color: controller.products.value?.expiriesWithPrice != null ? controller.getExpiryColor(index: index, list: controller.products.value!.expiriesWithPrice ?? []) : Colors.grey,
                                borderRadius: BorderRadius.circular(6.0)
                            ),
                              child: SelectableText(controller.products.value?.expiriesWithPrice?[index].date ?? Strings.nA, style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15))):
                        //    child: SelectableText("${controller.convertExpiryDateFormat(controller.products.value?.expiriesWithPrice?[index].date ?? Strings.nA)} ", style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15))):
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                            margin: const EdgeInsets.only(bottom: 6.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6.0)
                            ),
                            child: SelectableText(Strings.nA, style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15)))
                           // Text(Strings.nA, style: black_14_600()?.copyWith(color: Colors.black, fontSize: 15))
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView("Qty",
                    style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                  ),
                  vGap(4.0),
                  if (controller.products.value?.expiries?.isEmpty ?? true)
                    TextView(Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ...List.generate(
                    controller.products.value?.expiries?.length ?? 0,
                        (index) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                            margin: const EdgeInsets.only(bottom: 6.0),
                            child: SelectableText("${controller.products.value?.expiries?[index].qty?? "0"}", style: black_14_600()?.copyWith(color: black, fontSize: 15))),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(Strings.unitPrice,
                    style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                  ),
                  vGap(4.0),
                  if (controller.products.value?.expiries?.isEmpty ?? true)
                    TextView(Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ...List.generate(
                    controller.products.value?.expiries?.length ?? 0,
                        (index) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                            margin: const EdgeInsets.only(bottom: 6.0),
                            child: SelectableText("${controller.products.value?.expiries?[index].price?? Strings.nA}", style: black_14_600()?.copyWith(color: black, fontSize: 15))),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView(
                      Strings.manufacturer,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                     SelectableText(controller.products.value?.manufacturer ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15),textAlign: TextAlign.end,),
                  ],
                ),
              ),

            ],
          ),

          /*Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.manufacturer,
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
                          if(controller.products.value?.expiries?[index].at  != null && controller.products.value!.expiries![index].at!.isNotEmpty ?? false) Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                              margin: const EdgeInsets.only(bottom: 6.0),
                              decoration: BoxDecoration(
                                color: controller.products.value?.expiryLevel != null ? controller.getExpiryColor(index: index, list: controller.products.value!.expiryLevel ?? []) : Colors.grey,
                                borderRadius: BorderRadius.circular(6.0)
                              ),
                              child: TextView("${controller.convertExpiryDateFormat(controller.products.value?.expiryLevel?[index].at ?? Strings.nA)} ", style: black_14_600()?.copyWith(color: Colors.white, fontSize: 15))),
                          TextView("  ${controller.products.value?.expiryLevel?[index].qty}", style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }



  _addQrAndBarCode() {
    return Column(
      children: [
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        vGap(10.0),
        Row(
          children: [
            TextView(
              Strings.qrBarCode,
              style: black_15_700()?.copyWith(color: greyIconColor),
            ),
            const Spacer(),
            TextView(
              "${getBarCodeCount(controller.products.value?.barcode)} barcode",
              style: black_15_700()?.copyWith(color: primaryColor),
            )
          ],
        ).marginSymmetric(horizontal: 20.0),
        vGap(10.0),
        ...List.generate(getBarCodeCount(controller.products.value?.barcode), (index) {
          return Row(
            children: [
              IconButton(onPressed: () {}, icon: imageAsset(barIcon, color: black, height: 20)),
              hGap(20.0),
              Expanded(child: SelectableText(
                getBarCodeText(controller.products.value?.barcode, index),
                style: black_14_600()?.copyWith(color: black),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ).marginSymmetric(horizontal: 20.0);
        }),
        // Row(
        //   children: [
        //     IconButton(
        //         onPressed: () {},
        //         icon: imageAsset(scanIcon, color: hintTextColor, height: 20)),
        //     const Spacer(),
        //     TextView(
        //       Strings.addQrBarcode,
        //       style: black_14_600()?.copyWith(color: hintTextColor),
        //     ),
        //     const Spacer(),
        //     const SizedBox(
        //       width: 20.0,
        //     ),
        //   ],
        // ).marginSymmetric(horizontal: 20.0),
      ],
    );
  }

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


  _addRestockBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => SingleChildScrollView(
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
                      Text(
                        "Add Quantity",
                        style: whiteColor_18_700()?.copyWith(color: primaryColor),
                      ),
                      vGap(10.0),
                      Form(
                        key: formGlobalKey,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: Strings.quantity,
                                    controller: controller.textEditingControllerQuantity,
                                    focusNode: controller.textEditingFocusNodeQuantity,
                                    textInputType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) => value?.isEmptyFieldAndGraterZero(messageTitle: Strings.quantity,value: value),
                                    onFieldSubmitted: (String? value) =>  FocusScope.of(Get.context!).requestFocus(controller.expiryDateFocusNode),
                                  ),
                                ),
                                hGap(10.0),
                                Expanded(
                                  child: CustomTextField(
                                      hintText: Strings.expiryDate,
                                      onTap: () {
                                        controller.getExpiryDate();
                                      },
                                      readOnly: true,
                                      controller: controller.expiryDateController,
                                      validator: (value) {
                                        if(controller.products.value?.expiries?.isNotEmpty ?? false){
                                          if(controller.products.value!.expiries?.any((element) => element.at == value) ?? false){
                                            return "You cant add the same date again";
                                          }
                                          else {
                                          }
                                        }
                                        return null;
                                      },
                                      suffix: IconButton(
                                        onPressed: () {
                                          controller.getExpiryDate();
                                        },
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: greyIconColor,
                                        ),
                                      ),
                                      focusNode: controller.expiryDateFocusNode,
                                      onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.priceFocusNode),
                                    ),
                                 )
                              ],
                            ),
                            vGap(10.0),
                            CustomTextField(
                              hintText: "Unit Price",
                              controller: controller.priceControllerQuantity,
                              focusNode: controller.priceFocusNode,
                              textInputType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              validator: (value) => value?.isEmptyFieldAndGraterZero(messageTitle: "Unit Price", value: value),
                              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
                            ),
                          ],
                        ),
                      ),
                      vGap(14.0),
                      Obx(
                        () => AppButton(
                            onTap: () {
                              if (formGlobalKey.currentState!.validate()) {
                                controller.textEditingFocusNodeQuantity.unfocus();
                                controller.updateQuantity();
                              }
                            },
                            isLoading: controller.isLoading.value),
                      ),
                      vGap(20.0),
                      KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom - 10.0 : null,
                        );
                      }),
                    ],
                  ).marginSymmetric(horizontal: 20.0),
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
      ),
    );
  }



  getExpansionPanelListView(){

  }
}
