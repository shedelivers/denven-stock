import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/settings_module/controller/user_profile_controller.dart';

class UserProfileScreen extends GetView<UserProfileController>{
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBar(
            showLogo: false,
            centerLogo: true,
            title: "User Profile",
          ),
          body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return Column(
      children: [
        vGap(20.0),
        Utils.textFieldLabel(label: "Name"),
        vGap(10.0),
        CustomTextField(
          hintText: Strings.name,
          readOnly: true,
          controller: controller.nameController,
          focusNode: controller.nameFocusNode,
          suffix: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)).paddingOnly(right: 10.0),
          // validator: (value) => value?.isEmptyFieldAndGraterZero(messageTitle: Strings.quantity,value: value),
          onFieldSubmitted: (String? value) =>  FocusScope.of(Get.context!).requestFocus(controller.emailFocusNode),
        ),
        vGap(20.0),
        Utils.textFieldLabel(label: "Email"),
        vGap(10.0),
        CustomTextField(
          hintText: Strings.email,
          readOnly: true,
          controller: controller.emailController,
          focusNode: controller.emailFocusNode,
          suffix: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)).paddingOnly(right: 10.0),
          // validator: (value) => value?.isEmptyFieldAndGraterZero(messageTitle: Strings.quantity,value: value),
          onFieldSubmitted: (String? value) =>  FocusScope.of(Get.context!).requestFocus(controller.phoneNumberFocusNode),
        ),
        vGap(20.0),
        Utils.textFieldLabel(label: "Phone Number"),
        vGap(10.0),
        CustomTextField(
          hintText: Strings.phoneNumber,
          readOnly: true,
          controller: controller.phoneNumberController,
          focusNode: controller.phoneNumberFocusNode,
          suffix: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)).paddingOnly(right: 10.0),
          // validator: (value) => value?.isEmptyFieldAndGraterZero(messageTitle: Strings.quantity,value: value),
          onFieldSubmitted: (String? value) =>  FocusScope.of(Get.context!).unfocus(),
        ),
        const Spacer(),
        SafeArea(
          child: Obx(
                ()=> Container(
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius_10),
                border: Border.all(width: 1,color: Colors.grey),
              ),
              child: Center(child: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.black,) : Text("Deactivate Account",style: whiteColor_18_700()?.copyWith( color: Colors.black,),)),
            ).onTap(() {
              controller.isLoading.value = true;
              Future.delayed(const Duration(seconds: 2), () {
                controller.isLoading.value = false;
                Get.offAllNamed(AppRoutes.logIn);
                Utils.showSnackBar("Your account will be deactivated by admin within 48 Hours");
              });
            }),
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 20.0);
  }
}