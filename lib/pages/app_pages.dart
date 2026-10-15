import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/auth_module/signup_screen.dart';
import 'package:denvin_stock/pages/consumer_module/view/add_consumer_screen.dart';
import 'package:denvin_stock/pages/consumer_module/view/consumers_screen.dart';
import 'package:denvin_stock/pages/dashboard_module/basket_product_detail_screen.dart';
import 'package:denvin_stock/pages/dashboard_module/binding/dashboard_binding.dart';
import 'package:denvin_stock/pages/dashboard_module/view_basket_screen.dart';
import 'package:denvin_stock/pages/product_module/arrived_items_detail/arrived_items_detail_screen.dart';
import 'package:denvin_stock/pages/product_module/consumption_screen.dart';
import 'package:denvin_stock/pages/product_module/move_storage_screen.dart';
import 'package:denvin_stock/pages/settings_module/about_screen.dart';
import 'package:denvin_stock/pages/settings_module/clinic_selection_screen.dart';
import 'package:denvin_stock/pages/settings_module/change_password.dart';
import 'package:denvin_stock/pages/settings_module/controller/training_videos_controller.dart';
import 'package:denvin_stock/pages/settings_module/training_videos.dart';
import 'package:denvin_stock/pages/settings_module/user_profile_screen.dart';
import 'settings_module/binding/settings_binding.dart';

class AppPages {
  static const INITIAL = AppRoutes.splash;

  static final routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => SplashScreen(),
        bindings: [InitBinding(), AuthBinding()],
    ),

    GetPage(
        name: AppRoutes.logIn,
        page: () => LoginScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transition: Transition.cupertino,
        bindings: [AuthBinding()],
    ),

    GetPage(
        name: AppRoutes.authClinicSelection,
        page: () => AuthClinicSelectionScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transition: Transition.cupertino,
        bindings: [AuthBinding()],
    ),

    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [DashboardBinding()],
    ),
    GetPage(
      name: AppRoutes.viewBasketScreen,
      page: () => ViewBasketScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [DashboardBinding()],
    ),

    GetPage(
      name: AppRoutes.productDetailScreen,
      page: () =>   InventoryProductDetailScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [ProductBinding()],
    ),


    GetPage(
      name: AppRoutes.addManualProduct,
      page: () => ManualAddProductScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [ProductBinding()],
    ),

    GetPage(
      name: AppRoutes.scannerScreen,
      page: () => const ScannerScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.fadeIn,
      binding: ScannerBinding(),
    ),

    GetPage(
      name: AppRoutes.updateQuantity,
      page: () => UpdateQuantityScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      binding: UpdateQuantityBinding(),
    ),

    GetPage(
      name: AppRoutes.arrivedItemDetailScreen,
      page: () => ArrivedItemsDetailScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [ProductBinding()],
    ),

    GetPage(
      name: AppRoutes.clinicSelectionScreen,
      page: () => ClinicSelectionScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [AuthBinding()],
    ),

    GetPage(
      name: AppRoutes.userProfileScreen,
      page: () => UserProfileScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),


    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),

    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [AuthBinding()],
    ),

    GetPage(
      name: AppRoutes.basketProductView,
      page: () => BasketProductDetailScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [DashboardBinding()],
    ),

    GetPage(
      name: AppRoutes.moveStorage,
      page: () => MoveStorageScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [ProductBinding()],
    ),

    GetPage(
      name: AppRoutes.aboutUs,
      page: () => AboutScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),

    GetPage(
      name: AppRoutes.consumerScreen,
      page: () => const ConsumerScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),

    GetPage(
      name: AppRoutes.addConsumerScreen,
      page: () => AddConsumerScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),

    GetPage(
      name: AppRoutes.addConsumptionScreen,
      page: () => ConsumptionScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [ProductBinding()],
    ),

    GetPage(
      name: AppRoutes.trainingVideos,
      page: () => const TrainingVideosScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.cupertino,
      bindings: [SettingsBinding()],
    ),

  ];
}