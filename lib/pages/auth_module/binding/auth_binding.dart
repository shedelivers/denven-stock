import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/auth_module/controllers/signup_controller.dart';
import 'package:denvin_stock/pages/settings_module/controller/clinic_selection_controller.dart';


class InitBinding extends Bindings {
  @override
  void dependencies() {

  }
}


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
    // Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    Get.lazyPut<ClinicSelectionController>(() => ClinicSelectionController());
    Get.lazyPut<AuthClinicSelectionController>(() => AuthClinicSelectionController());
    // Get.lazyPut<AddClinicController>(() => AddClinicController());
    // Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    // Get.lazyPut<GetToKnowController>(() => GetToKnowController());
    // Get.lazyPut<EmailLinkController>(() => EmailLinkController());
  }
}
