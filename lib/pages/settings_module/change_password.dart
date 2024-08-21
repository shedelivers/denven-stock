import 'package:denvin_stock/exports.dart';
import 'controller/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  ChangePasswordScreen({super.key});

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(centerLogo: false,
              showBack: true,
              showLogo: false,
              title: Strings.changePassword),
          body: _mainBody()
      ),
    );
  }

  _mainBody() {
    return Obx(()=>Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                vGap(20.0),
                _form(),
                vGap(20.0),
              ],
            ),
          ),
          // _resetPassword(),
          vGap(10.0),
          SafeArea(
              child: AppButton(
                isLoading: controller.isLoading.value,
                onTap: () {
                if(formGlobalKey.currentState!.validate()){
                  if(controller.newPasswordController.text.toString() != controller.confirmPasswordController.text.toString()){
                    Utils.showSnackBar("Mismatch password");
                  }else{
                    controller.changePassword();
                  }
                }
              },buttonText: Strings.changePassword))
              .marginSymmetric(horizontal: 20.0)
        ],
      ),
    );
  }

  _form(){
    return Form(
      key: formGlobalKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: Strings.oldPassword,
            controller: controller.oldPasswordController,
            validator: (value) => value?.validatePassword(),
             focusNode: controller.oldPasswordFocusNode,
            obsecureText: controller.oldPassword.value,
            suffix: IconButton(
                onPressed: ()=> controller.showOrHideOldPasswordVisibility(),
                splashRadius: 10.0,
                icon: Icon(controller.oldPassword.value ? Icons.visibility_off : Icons.visibility, color: darkGreyColor,)),

             onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.newPasswordFocusNode),
          ),
          vGap(24),
          CustomTextField(
            hintText: Strings.newPassword,
            obsecureText: controller.newPassword.value,
             controller: controller.newPasswordController,
            validator: (value) => value?.validatePassword(),
             focusNode: controller.newPasswordFocusNode,
            suffix: IconButton(
                onPressed: ()=> controller.showOrHideNewPasswordVisibility(),
                splashRadius: 10.0,
                icon: Icon(controller.newPassword.value ? Icons.visibility_off : Icons.visibility, color: darkGreyColor,)),

             onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.confirmPasswordFocusNode),
          ),
          vGap(24),
          CustomTextField(
            hintText: Strings.confirmNewPassword,
            obsecureText: controller.confirmPassword.value,
             controller: controller.confirmPasswordController,
            validator: (value) => value?.validatePassword(),
             focusNode: controller.confirmPasswordFocusNode,
            suffix: IconButton(
                onPressed: ()=> controller.showOrHideConfirmPasswordVisibility(),
                splashRadius: 10.0,
                icon: Icon(controller.confirmPassword.value ? Icons.visibility_off : Icons.visibility, color: darkGreyColor,)),

            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
          ),
        ],
      ).marginSymmetric(horizontal: 20.0),
    );
  }
}
