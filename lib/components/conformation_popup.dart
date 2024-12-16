import '../exports.dart';

Future<void> confirmPopUp({
  required String title,
  required String subtitle,
  required Function onConfirm,
  String? conFirmButtonText,
  String? cancelText}) async {
  return showDialog(
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
            TextView(title, style: black_17_600(),).marginSymmetric(horizontal: 20.0),
            vGap(10.0),
            TextView(subtitle,maxLine: 5, style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
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
                      child: Text(cancelText??"No", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                  InkWell(
                      borderRadius: BorderRadius.circular(6.0),
                      onTap: (){
                        Get.back();
                        onConfirm();
                      },
                      child: Text(conFirmButtonText??"Yes", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                ],
              ),
            ).marginSymmetric(horizontal: 10.0),
            vGap(10.0),
          ],
        ),
      );
    },
  );
}