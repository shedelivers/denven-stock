import 'dart:collection';
import 'package:denvin_stock/exports.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
class SignUpController extends GetxController{

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late FocusNode fullNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  RxBool isGoogleLoading = false.obs;
  RxBool securePassword = true.obs;
  RxBool isLoading = false.obs;

  RxString practiceName = "".obs;
  RxString firsName = "".obs;
  RxString lastName = "".obs;
  RxString jobTitle = "".obs;

  late AuthApiProvider _authApiProvider;

  @override
  void onInit() {
    initializeVariables();
    super.onInit();
  }
  initializeVariables() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    fullNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    _authApiProvider = AuthApiProvider();
  }

  getArguments(){
    if(Get.arguments != null){
      practiceName.value = Get.arguments[RoutesArgument.practiceName];
      firsName.value = Get.arguments[RoutesArgument.firstName];
      lastName.value = Get.arguments[RoutesArgument.lastName];
      jobTitle.value = Get.arguments[RoutesArgument.jobTitle];
    }
  }

  showOrHideLoginPasswordVisibility(){
    securePassword.value = !securePassword.value;
    update();
  }

  signUp()async{
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> queries = HashMap();
      queries[ApiConstants.name] = practiceName.value;
      queries[ApiConstants.Firstname] = firsName.value;
      queries[ApiConstants.Lastname] = lastName.value;
      queries[ApiConstants.email] = emailController.text.trim();
      queries[ApiConstants.terms] = false;
      queries[ApiConstants.password] = passwordController.text;
      queries[ApiConstants.ConfirmPassword] = passwordController.text;
      queries[ApiConstants.JobTitle] = jobTitle.value;
      queries[ApiConstants.appType] = Platform.isIOS ? 1 : 2;
      isLoading.value = true;
      DataResponse dataResponse = await _authApiProvider.signUp(queries);
      isLoading.value = false;
      if (dataResponse.successful == false) {
        Utils.showSnackBar(dataResponse.error ?? Strings.somethingWentWrong);
      } else {
        if (dataResponse.response != null) {
          showEmailDialog();
        } else {
          Utils.showSnackBar(dataResponse.error ?? Strings.somethingWentWrong);
        }
      }
    }
  }

  Future signInWithGoogle() async {
    Utils.showSnackBar("Coming Soon");
    // if (await Utils.hasNetwork()) {
    //   isGoogleLoading.value = true;
    //   GoogleLogin.signInWithGoogle(context: Get.context!).then((value) {
    //     isGoogleLoading.value = false;
    //     if(value != null) {
    //       Map<String, dynamic> socialPayload = HashMap();
    //       socialPayload[ApiConstants.email] = value.user?.email;
    //       socialPayload[ApiConstants.socialRegisterToken] = value.googleSignInAuthentication.accessToken;
    //       socialPayload[ApiConstants.remeberMe] = true;
    //       socialPayload[ApiConstants.name] = value.user?.displayName;
    //       socialPayload[ApiConstants.registerType] = ApiConstants.loginTypeSocial;
    //       // signIn(isSocial: true, socialPayload: socialPayload);
    //     }
    //   });
    // }
  }

  Future signInWithApple(BuildContext context) async {
    Utils.showSnackBar("Coming Soon");
    // getAppleLogin(context: context).then((value) {
    //   if (value != null) {
    //     log.d("==id token==>${value.authorizationCredentialAppleID.identityToken}");
    //     Map<String, dynamic> socialPayload = HashMap();
    //     // socialPayload[ApiConstants.email] = value.user?.email;
    //     // socialPayload[ApiConstants.socialRegisterToken] = value.googleSignInAuthentication.accessToken;
    //     // socialPayload[ApiConstants.remeberMe] = true;
    //     // socialPayload[ApiConstants.name] = value.user?.displayName;
    //     // socialPayload[ApiConstants.roleKey] = ApiConstants.role;
    //     // socialPayload[ApiConstants.registerType] = ApiConstants.loginTypeSocial;
    //   } else {
    //     Utils.showSnackBar("Login Cancelled",);
    //   }
    // }).onError((error, stackTrace) {
    //   Utils.showSnackBar(error.toString());
    // });
  }

  void showEmailDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap(20.0),
              TextView("Final Step", style: black_17_600(),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              Divider(
                color: textFieldBorderColor,
              ),
              vGap(10.0),
              TextView("You will shortly receive an activation email. Please activate your account using the link provided to complete registration.",textAlign: TextAlign.center, maxLine: 3, style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                    borderRadius: BorderRadius.circular(6.0),
                    onTap: (){
                      Get.back();
                      Get.offAllNamed(AppRoutes.logIn);
                    },
                    child: Material(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(6.0),
                        child: Text("Ok", style: primaryColor_16_700()?.copyWith(color: Colors.white)).paddingSymmetric(horizontal: 20.0,vertical: 6.0))),
              ).marginSymmetric(horizontal: 10.0),
              vGap(10.0),
            ],
          ),
        );
      },
    );
  }

}