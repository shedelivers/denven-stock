import 'dart:io';

import 'package:denvin_stock/components/get_ink_well.dart';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/auth_module/controllers/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';


class SignUpScreen extends GetView<SignUpController>{

  SignUpScreen({super.key}) {
    controller.getArguments();
  }
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBarV2(centerLogo: true),
          body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return  Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              vGap(20.h),
              _welcomeHeading(),
              vGap(20.h),
              _form(),
              vGap(10.h),
            ]
          ).marginSymmetric(horizontal: 20.0),
        ),
        KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isKeyboardVisible ? 0 : null,
                child: isKeyboardVisible ? null :   SafeArea(child: Column(
                  children: [
                    vGap(10.0),
                    _submitButton(),
                    // _socialLogins(Get.context!),
                    _newHere(),
                    vGap(30.0),
                  ],
                ),
                ),
              );
            }),
      ],
    );
  }

  _welcomeHeading(){
    return Column(
      children: [
        TextView(Strings.createAnAccount,style: black_22_700()),
        TextView(Strings.getStartedForFree,style: greyColor_16_600()),
      ],
    );
  }

  _form() {
    return Form(
      key: formGlobalKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
              hintText:Strings.email,
              textInputType: TextInputType.emailAddress,
              controller: controller.emailController,
              validator: (value) => value?.isValidEmail(),
              focusNode: controller.emailFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.passwordFocusNode)
          ),
          vGap(24),
          Obx(()=> CustomTextField(
              hintText: Strings.password,
              maxLines: 1,
              controller: controller.passwordController,
              obsecureText: controller.securePassword.value,
              // validator: (value) {
              //   return value?.validatePassword();
              // },
              suffix: IconButton(
                  onPressed: ()=> controller.showOrHideLoginPasswordVisibility(),
                  splashRadius: 10.0,
                  icon: Icon(controller.securePassword.value ? Icons.visibility_off : Icons.visibility, color: darkGreyColor,)),
              focusNode: controller.passwordFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
            ),
          ),
          vGap(24),
          _termsLinks()
        ],
      ),
    );
  }


  _termsLinks(){
    return Column(
      children: [
        TextView(Strings.byUsingTheApp,style:black_15_500(),),
        RichText(text: TextSpan(
            text: "",
            style: black_15_500(),
            children: [
              TextSpan(
                text: Strings.termsAndCondition,
                style: black_15_500()?.copyWith(color: primaryColor),
                recognizer: TapGestureRecognizer()..onTap = ()async{
                  if (!await launchUrl(Uri.parse("https://live.denven.com/Terms?h=669"))) {
                    throw Exception('Something went wrong');
                  }
                },
              ),

              TextSpan(
                text: Strings.and,
                style: black_15_500(),
              ),

              TextSpan(
                text: Strings.privacyPolicy,
                style: black_15_500()?.copyWith(color: primaryColor),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  if (!await launchUrl(Uri.parse("https://live.denven.com/Privacy?h=669"))) {
                    throw Exception('Something went wrong');
                  }
                },
              ),
            ]
        )),
      ],
    );
  }

  _submitButton(){
    return Obx(()=> AppButton(
      isLoading: controller.isLoading.value,
      onTap: (){
        if (formGlobalKey.currentState!.validate()) {
          controller.isLoading.value = true;
          Future.delayed(const Duration(seconds: 2), () {
            controller.isLoading.value = false;
            Get.offAllNamed(AppRoutes.logIn);
            Utils.showSnackBar("Your account will be activated by admin within 48 Hours");
          });
        }
      },
      buttonText: Strings.signup,
      ).marginSymmetric(horizontal: 20.0),
    );
  }

  _newHere(){
    return  RichText(text: TextSpan(
        text: Strings.alreadyHaveAccount,
        style: black_15_500(),
        children: [
          TextSpan(
            text: Strings.login,
            style: black_16_400()?.copyWith(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = ()=> Get.offAllNamed(AppRoutes.logIn),
          ),
        ]
    ));
  }


  _socialLogins(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: textFieldBorderColor,
              ),
            ),
            hGap(10.0),
            TextView("OR", style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700).copyWith(fontWeight: FontWeight.w400,color: hintTextColor.withOpacity(0.70)),),
            hGap(10.0),
            Expanded(
              child: Container(
                height: 1,
                color: textFieldBorderColor,
              ),
            ),
          ],
        ).marginSymmetric(horizontal: 20.0),

        vGap(15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 46.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetInkWell(
                onTap: (){
                  controller.signInWithGoogle();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                        color: blackColor.withOpacity(0.2)
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: Image.asset(
                          googleLogo,
                        ),
                      ),
                      hGap(10.0),
                      TextView("Sign up with Google", style: TextStyle(color: blackColor, fontWeight: FontWeight.w600, height: 0),)
                    ],
                  ).paddingSymmetric(vertical: 12.0),
                ),
              ),
              vGap(20),
              if(Platform.isIOS) GetInkWell(
                onTap: (){
                  controller.signInWithApple(Get.context!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: blackColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: Image.asset(
                          appleLogo,
                          color: Colors.white,
                        ),
                      ),
                      hGap(10.0),
                      TextView("Sign up with Apple", style: TextStyle(color: whiteColor,
                          fontWeight: FontWeight.w600,
                          height: 0),
                      )
                    ],
                  ).paddingSymmetric(vertical: 12.0),
                ),
              ),
            ],
          ),
        ),
        vGap(25),
      ],
    );
  }

  Widget socialLoading(){
    return SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(color: blackSimilar,strokeWidth: 4.0,));
  }

}