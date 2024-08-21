import 'package:denvin_stock/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends GetView<LoginController>{

  LoginScreen({super.key});
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
         appBar: myAppBar(showBack: false),
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
              // _forgotPassword(),
            ],
          ).marginSymmetric(horizontal: 20.0),
        ),
        KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isKeyboardVisible ? 0 : null,
                child: isKeyboardVisible ? null :  Column(
                  children: [
                    _termsLinks(),
                    vGap(10.0),
                    _submitButton(),
                    _newHere(),
                    vGap(30.0),
                  ],
                ),
              );
            }),
      ],
    );
  }

  _welcomeHeading(){
    return Column(
      children: [
        TextView(Strings.welcomeBack,style: black_22_700()),
        TextView(Strings.loginToYourAcc,style: greyColor_16_600()),
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
              controller: controller.loginEmailController,
              validator: (value) => value?.isValidEmail(),
              focusNode: controller.loginEmailFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.loginPasswordFocusNode)
          ),
          vGap(24),
          Obx(
            ()=> CustomTextField(
              hintText: Strings.password,
              maxLines: 1,
              controller: controller.loginPasswordController,
              obsecureText: controller.securePassword.value,
              // validator: (value) {
              //   return value?.validatePassword();
              // },
              suffix: IconButton(
                  onPressed: ()=> controller.showOrHideLoginPasswordVisibility(),
                  splashRadius: 10.0,
                  icon: Icon(controller.securePassword.value ? Icons.visibility_off : Icons.visibility, color: darkGreyColor,)),
              focusNode: controller.loginPasswordFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
            ),
          ),
        ],
      ),
    );
  }

  _forgotPassword(){
    return TextView(Strings.forgotPassword,style: primaryColor_16_700()).onTap(()=> Utils.showSnackBar("Coming Soon"));
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
          controller.logIn();
        }
      },
      buttonText: Strings.signin,
    ).marginSymmetric(horizontal: 20.0),
    );
  }

  _newHere(){
    return RichText(text: TextSpan(
        text: Strings.newHere,
        style: black_15_500(),
        children: [
          TextSpan(
            text: Strings.createAccount,
            style: black_15_500()?.copyWith(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = ()=> Get.toNamed(AppRoutes.signUp),
          ),
        ]
    ));
  }
}