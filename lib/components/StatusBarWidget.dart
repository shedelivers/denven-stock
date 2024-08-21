
import "package:denvin_stock/exports.dart";


class MyAnnotatedRegion extends StatelessWidget {
  Widget child;
  bool? isDark;
   MyAnnotatedRegion({Key? key,required this.child,this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(value: statusBarTheme(isDark: isDark??false), child: Container(color: whiteColor, child: child));
  }



}
SystemUiOverlayStyle statusBarTheme({bool isDark = false}) {
  SystemUiOverlayStyle mySystemTheme=  SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark);
  if(isDark){
mySystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light);
  }


  return mySystemTheme;
}



class MyErrorWidget extends StatelessWidget {
  String value;
  MyErrorWidget({Key? key,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(value,
              textAlign: TextAlign.center,
              )
        ],
      ),
    );
  }
}
