import 'package:denvin_stock/network/modal/change_password.dart';

import '../../../exports.dart';
import '../../../network/api_provider/settings_api_provider.dart';

class ChangePasswordController extends GetxController {

  late SettingApiProvider _settingsApiProvider;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  late FocusNode oldPasswordFocusNode;
  late FocusNode newPasswordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  RxBool isLoading = false.obs;
  RxBool oldPassword = true.obs;
  RxBool newPassword = true.obs;
  RxBool confirmPassword = true.obs;

  @override
  void onInit() {
    _settingsApiProvider = SettingApiProvider();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    oldPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    super.onInit();
  }

  showOrHideOldPasswordVisibility() {
    oldPassword.value = !oldPassword.value;
    update();
  }

  showOrHideNewPasswordVisibility() {
    newPassword.value = !newPassword.value;
    update();
  }

  showOrHideConfirmPasswordVisibility() {
    confirmPassword.value = !confirmPassword.value;
    update();
  }


  Future changePassword() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;

      Map<String, dynamic> payload = {
        "id": StorageHelper().getUserId(),
        "oldPassword": oldPasswordController.text.toString(),
        "newPassword": newPasswordController.text.toString(),
        "confirmPassword": confirmPasswordController.text.toString(),
      };

      ComanResponseModal? response = await _settingsApiProvider.changePassword(payload);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to add data");
      } else {
        if (response.response != null) {
         // print('changePasswordModel: ${changePasswordModel.successful}');

          Utils.showSnackBar("Password change successfully",isSuccess: true);

        } else {
          Utils.showSnackBar(response.error ?? "Unable to change");
        }
      }
    }
  }

}