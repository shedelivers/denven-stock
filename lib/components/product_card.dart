import 'package:denvin_stock/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final VoidCallback menuOnTap;
  final VoidCallback cardOnTap;
  String? name;
  String? orderAt;
  List<String> imagePath;
  bool isThreeDotsActive;
  num? price;
  String? supplierCode;
  String? storageName;
  bool dontShowBorderAndMenu;
  int? localMappingId;
  bool? hasOnlyDenvenBarcode;
  int type;
  bool isHidden;
  ProductCard({super.key,required this.menuOnTap,this.storageName,this.isThreeDotsActive = true, this.dontShowBorderAndMenu = false, required this.cardOnTap, this.name,required this.imagePath,this.orderAt, this.price,this.supplierCode, this.localMappingId, this.hasOnlyDenvenBarcode, required this.type, required this.isHidden});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                child: imagePath.isNotEmpty? ClipRRect(borderRadius: BorderRadius.circular(10.0),
                    child: ShimmerImage(url: imagePath[0] ?? "",fit: BoxFit.cover)) : imageAsset(imageIcon),
              ),
              hGap(10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        RichText(
                          text: TextSpan(
                            style: black_12_600(),
                            children: [
                              if (supplierCode != null)
                                ...supplierCode!.split('**').map((part) {
                                  if (part.isNotEmpty) {
                                    return TextSpan(text: "#$part", style: black_12_600());
                                  } else {
                                    return TextSpan(text: '**', style: black_14_600()?.copyWith(color: gradientColor3));
                                  }
                                })
                              else
                                TextSpan(text: Strings.nA, style: black_12_600()),
                            ],
                          ),
                        ),

                        /* TextView(
                          supplierCode != null ? "#$supplierCode" : Strings.nA,
                          style: black_12_600(),
                        ),*/

                        Visibility(
                            visible: type == 1,
                            replacement: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: imageAsset(openBoxIcon, width: 15, color: black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: imageAsset(closeBoxIcon, width: 15, color: gradientColor3),
                            )),

                        Visibility(
                            visible: localMappingId != null && hasOnlyDenvenBarcode == false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: imageAsset(scanIcon, width: 15),
                            )),

                        Visibility(
                            visible: isHidden,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Icon(Icons.visibility_off, size: 16,),
                            )),

                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextView(
                            name ?? Strings.nA,
                            maxLine: 2,
                            style: whiteColor_18_700()?.copyWith(color: primaryColor,fontSize: 17),
                          ),
                        ),
                        const SizedBox(width: 50.0)
                      ],
                    ),
                    vGap(8.0),
                    Row(
                      children: [
                        TextView(
                          type == 1? "":price != null ? "£ $price" : "£ 00.00",
                          style: greyColor_16_600()?.copyWith(color: blackColor),
                        ),
                        const Spacer(),
                        TextView(storageName != null ? storageName ?? "" : orderAt != null ? convertDateFormat(orderAt ?? "") : "",
                          style: black_12_400()?.copyWith(color: greyColor,fontSize: 11),
                        ).paddingOnly(right: 20.0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).onTap(cardOnTap),
        if(isThreeDotsActive ?? false) dontShowBorderAndMenu ? const SizedBox() : Positioned(
          right: 0,
          top: 0,
          child: Container(
            // color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20.0),
            child: const Icon(Icons.more_vert).marginOnly(right: 10.0),
          ).onTap(menuOnTap),
        ),
      ],
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
}