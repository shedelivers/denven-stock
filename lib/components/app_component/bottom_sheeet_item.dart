import 'package:denvin_stock/exports.dart';

class BottomSheetItem extends StatelessWidget {
  final String title;
  final String iconUri;
  final GestureTapCallback onItemTap;
  const BottomSheetItem({super.key, required this.onItemTap, required this.title, required this.iconUri});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: textFieldBorderColor),
        ),
        child: Row(
          children: [
            imageAsset(iconUri,height:iconUri == viewIcon? 14 :  20.0,color: black),
            hGap(10.0),
            TextView(title,style: black_17_600()?.copyWith(fontSize: 14,color: black)),
            const Spacer(),
            CircleAvatar(
              backgroundColor: primaryLightColor,
              radius: 12,
              child: Icon(Icons.arrow_forward_ios_outlined, color: primaryColor,size: 14),
            )
          ],
        ).paddingSymmetric(horizontal: 20.0,vertical: 12.0),
      ),
    );
  }
}