import 'dart:io';

import "package:denvin_stock/exports.dart";

Widget vGap(double height) => SizedBox(height: height);

Widget hGap(double width) => SizedBox(width: width);

setFileImage(
    {required String url, double? height, double? width, double? radius}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 100),
    child: Image.file(File(url),
        height: height, width: width, fit: BoxFit.contain),
  );
}


PreferredSizeWidget myAppBar({Color? titleColor, bool showBack = true,bool showScanner = false, VoidCallback? onTap, String? title,bool? centerLogo = false, bool showLogo = true, Widget? showOcrButton}) {
  return AppBar(
    scrolledUnderElevation: 0,
    centerTitle: centerLogo ,
    toolbarHeight: 50.0,
    leadingWidth: showBack ? 60.0 : 10.0,
    title: showLogo ? Row(
      children: [
        imageAsset(appLogo,height: 38.0),
        hGap(10.0),
        TextView("Stock Management", style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
      ],
    ) : TextView(title??"", style: whiteColor_18_700()?.copyWith(color: titleColor ?? black),),
    leading: showBack ? IconButton(
      onPressed: onTap ?? ()=> Get.back(),
      icon: const Icon(Icons.arrow_back_outlined,
          color: Color(0xff2A2A33),
          size: 26),
    ).marginOnly(left: 10.0) : const SizedBox(),
    actions: [
      showScanner ? IconButton(onPressed: (){  Get.toNamed(AppRoutes.scannerScreen);}, icon: imageAsset(scanIcon,width: 20)).marginOnly(right: 10.0) : const SizedBox(),
      showOcrButton??const SizedBox()
    ],
  );
}
PreferredSizeWidget myAppBarV2({Color? titleColor, bool showBack = true,bool showScanner = false, VoidCallback? onTap, String? title,bool? centerLogo = false, bool showLogo = true, Widget? showOcrButton}) {
  return AppBar(
    scrolledUnderElevation: 0,
    centerTitle: centerLogo ,
    toolbarHeight: 50.0,
    leadingWidth: showBack ? 60.0 : 10.0,
    title: showLogo ? imageAsset(fullLogo, height: 38.0) : TextView(title??"", style: whiteColor_18_700()?.copyWith(color: titleColor ?? black),),
    leading: showBack ? IconButton(
      onPressed: onTap ?? ()=> Get.back(),
      icon: const Icon(Icons.arrow_back_outlined,
          color: Color(0xff2A2A33),
          size: 26),
    ).marginOnly(left: 10.0) : const SizedBox(),
    actions: [
      showScanner ? IconButton(onPressed: (){  Get.toNamed(AppRoutes.scannerScreen);}, icon: imageAsset(scanIcon,width: 20)).marginOnly(right: 10.0) : const SizedBox(),
      showOcrButton??const SizedBox()
    ],
  );
}

PreferredSizeWidget homeAppBar({VoidCallback? onTap, String? title,bool? isCenterTitle,bool isNotificationIconVisible = true}) {
  return AppBar(
    scrolledUnderElevation:0,
    centerTitle: isCenterTitle ?? false,
    toolbarHeight: 50.0,
    leadingWidth: 4.0,
    leading: const SizedBox(),
    automaticallyImplyLeading: false,
    title: Text(title ?? ""),
    actions: [
    if(isNotificationIconVisible) Padding(
        padding: const EdgeInsets.only(right: margin_23),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (){

          },
          child: Container(
            height: 42,
            width: 42,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xff2A2A33).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            // child: imageAsset(notificationIcon)
          ),
        ),
      ),
    ],
  );
}

Widget addMoreButton({String? text, IconData? icon, required VoidCallback onTap}){
  return  Container(
    height: 24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius_4),
      color: addMoreButtonColor,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Icon(icon ?? Icons.add,color: whiteColor,size: 18,),
          TextView(text ?? Strings.add,)
        ],
      ),
    ),
  ).onTap(() {
    onTap();
  });
}



// circleImageNetWork({imageurl, height, width, radius}) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(radius),
//     child: FadeInImage.assetNetwork(
//         fit: BoxFit.contain,
//         width: width,
//         height: height,
//         placeholder: ICON_profile,
//         image: imageurl ?? ""),
//   );
// }

circleAssetImage(
    {required String asset, double? height, double? width, double? radius}) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 100),
      child:
          imageAsset(asset, height: height, width: width, fit: BoxFit.contain));
}

Widget shimmerEffectWidget(
    {required Widget child, Widget? shimmerWidget, bool showShimmer = true}) {
  return showShimmer
      ? Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.2),
          highlightColor: Colors.black12,
          child: shimmerWidget ?? child)
      : child;
}
// Widget errorWidget(String value)
// {
//   return Center(
//     child: Column(mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         vGap( height_20),
//         imageAsset(appIcon ,height: height_50,width:height_50,color: Colors.grey),
//         vGap( height_10),
//         TextView(value,
//             textAlign: TextAlign.center,
//             // style: getTextStyleHeadLineMedium()
//             style: getTextStyleBodyLargeText()
//
//         )
//       ],
//     ),
//   );
// }

pagenationLoader({double? height, double? width}) {
  return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: CircularProgressIndicator());
}

String getFileExtension(String fileName) {
  try {
    return fileName.split('.').last;
  } catch (e) {
    return "";
  }
}
