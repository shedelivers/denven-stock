import 'package:denvin_stock/exports.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:upgrader/upgrader.dart';

CustomLoader customLoader = CustomLoader();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Intercom.instance.initialize(
      'j5x74qha',
      iosApiKey: 'ios_sdk-7431ce308d7cff9a7b79aca1b012c267fc1bc417',
      androidApiKey: 'android_sdk-c5cce85dd55f474ea6c4c48d43bedc689b1d64e9');
  await Intercom.instance.setThemeMode(IntercomTheme.light);


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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static startFirstScreen(String message) {
    Utils.hideLoader();
    StorageHelper().clearAll();
    Get.offAllNamed(AppRoutes.logIn);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    print('Dispose app');
    super.dispose();
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
