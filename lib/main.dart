import 'package:denvin_stock/exports.dart';
import 'package:upgrader/upgrader.dart';

CustomLoader customLoader = CustomLoader();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await Upgrader.clearSavedSettings();
  await StorageHelper.init();
  runApp(const MyApp());
}

TextTheme textTheme = Theme.of(Get.context!).textTheme;
var log = Logger();

class GlobalVariable{
  static final GlobalKey<ScaffoldMessengerState> navState = GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static startFirstScreen(String message) {
    Utils.hideLoader();
    StorageHelper().clearAll();
    Get.offAllNamed(AppRoutes.logIn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: ScreenUtilInit(
        builder: (context, widget) => GetMaterialApp(
          theme: themeData.copyWith(textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme,)),
          darkTheme: themeDark,
          themeMode: ThemeMode.light,
          initialBinding: InitBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          scaffoldMessengerKey: GlobalVariable.navState,
          debugShowCheckedModeBanner: false,
          enableLog: true,
          logWriterCallback: LoggerX.write,
          builder: EasyLoading.init(),
          defaultTransition: Transition.cupertino,
        ),
      ),
    );
  }
}
