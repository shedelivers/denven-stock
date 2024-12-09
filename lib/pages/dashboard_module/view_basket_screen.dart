import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/baske_modal.dart';
import 'package:denvin_stock/pages/dashboard_module/controller/view_basket_controller.dart';


class ViewBasketScreen extends GetView<ViewBasketController>{
  ViewBasketScreen({super.key}){
    controller.getBasketListing();
  }


  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(
              showBack: true,
              showLogo: false,
              title: "Basket",
              centerLogo: true
          ),
          body: Obx(() => controller.isLoading.value ? Utils.circularLoader() : _mainBody())
      ),
    );
  }

  _mainBody(){
      return  controller.basketItems.isEmpty ? Utils.noDataFound(message: "Basket is empty") :  SingleChildScrollView(
        child: Column(
          children: [
              vGap(20.0),
              ...List.generate(controller.basketItems.length, (index) {
                BasketModal basketItem = controller.basketItems[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.productDetailScreen,
                            arguments: {
                              RoutesArgument.productId: basketItem.product?.id,
                              RoutesArgument.showBasket: false
                            })?.then((value) {
                          if (value != null) {
                            controller.getBasketListing();
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1, color: textFieldBorderColor)
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: basketItem.product?.productImage != null ? ClipRRect(borderRadius: BorderRadius.circular(10.0),child: ShimmerImage(url: "${ApiConstants.baseUrlForImage}/${extractImagePath(basketItem.product?.productImage ?? "")}",fit: BoxFit.cover)) : imageAsset(imageIcon),
                            ),
                            hGap(20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextView(
                                        basketItem.product?.manufacturer != null ? "${basketItem.product?.manufacturer}" : Strings.nA,
                                        style: black_12_600(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextView(
                                          basketItem.product?.name ?? Strings.nA,
                                          maxLine: 2,
                                          style: whiteColor_18_700()?.copyWith(color: primaryColor),
                                        ),
                                      ),
                                      const SizedBox(width: 50.0)
                                    ],
                                  ),
                                  vGap(8.0),
                                  Row(
                                    children: [
                                      TextView(
                                        basketItem.product?.price != null ? "£ ${basketItem.product?.price}" : "£ 00.00",
                                        style: greyColor_16_600()?.copyWith(color: blackColor),
                                      ),
                                      const Spacer(),
                                      TextView(
                                        basketItem.product?.orderedAt != null ? convertDateFormat(basketItem.product?.orderedAt ?? "") : "",
                                        style: black_12_400()?.copyWith(color: greyColor),
                                      ).paddingOnly(right: 20.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        right: 8.0,
                        child: IconButton(
                      onPressed: (){
                        showAlertDialog((basketItem.product?.id ?? "").toString());
                      },
                      icon: const Icon(Icons.delete_outline),
                    ))
                  ],
                );
              }),
              vGap(20.0),
          ],
        ).marginSymmetric(horizontal: 20.0),
      );
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

  void showAlertDialog(String basketItemId) {
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
              TextView("Are you sure?", style: black_17_600(),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              TextView("You want to delete the basket item",maxLine: 3, style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                        },
                        child: Text("No", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                          controller.deleteItem(id: basketItemId);
                        },
                        child: Text("Yes", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                  ],
                ),
              ).marginSymmetric(horizontal: 10.0),
              vGap(20.0),
            ],
          ),
        );
      },
    );
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

}