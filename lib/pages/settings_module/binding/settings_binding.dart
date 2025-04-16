import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/consumer_module/controller/consumer_controller.dart';
import 'package:denvin_stock/pages/settings_module/controller/policy_page_controller.dart';
import 'package:denvin_stock/pages/settings_module/controller/change_password_controller.dart';
import 'package:denvin_stock/pages/settings_module/controller/training_videos_controller.dart';
import 'package:denvin_stock/pages/settings_module/controller/user_profile_controller.dart';

class SettingsBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(() => UserProfileController());
    Get.lazyPut<PolicyPageController>(() => PolicyPageController());
    Get.lazyPut<ConsumerController>(() => ConsumerController());
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
    Get.lazyPut<TrainingVideosController>(() => TrainingVideosController());
  }

}