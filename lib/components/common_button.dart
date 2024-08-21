import 'package:denvin_stock/exports.dart';

class AppButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? rippleColor;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;


  const AppButton({super.key,
    this.buttonColor,this.textColor, this.borderWidth, this.borderColor,
    this.buttonText, required this.onTap,this.isLoading = false, this.backgroundColor, this.rippleColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius_10),
      child: Material(
        color: backgroundColor ?? primaryColor,
        child: InkWell(
          splashColor: rippleColor ?? primaryColorRipple,
          onTap: onTap,
          child: Container(
            height: 60.0,
            width: Get.width,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(radius_10),
              border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth ??  0.3),
            ),
            child: Center(
              child: isLoading ?
              CircularProgressIndicator(color: whiteColor,) :
              TextView(
                  buttonText ?? Strings.submit,
                  style: whiteColor_18_700()?.copyWith( color: textColor,),
              ),
            ),
          ),
        ),
      ),
    ).marginOnly(bottom: 16.0);
  }
}
