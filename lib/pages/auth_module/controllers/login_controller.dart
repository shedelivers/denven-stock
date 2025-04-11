import 'dart:collection';
import 'package:denvin_stock/exports.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/get_app_access_popup.dart';

class LoginController extends GetxController {
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  late FocusNode loginEmailFocusNode;
  late FocusNode loginPasswordFocusNode;

  RxBool securePassword = true.obs;
  RxBool isLoading = false.obs;

  late AuthApiProvider _authApiProvider;

  RxString appVersion = ''.obs;

  @override
  void onInit() {
    initializeVariables();
    getAppVersion ();
    super.onInit();
  }
  void getAppVersion ()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "${packageInfo.version} (${packageInfo.buildNumber})";
    refresh();
  }


  initializeVariables() {
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    loginEmailFocusNode = FocusNode();
    loginPasswordFocusNode = FocusNode();
    _authApiProvider = AuthApiProvider();

    ///TODO: Remove this please
    // addDefaultLoginPass();
  }

  addDefaultLoginPass() {
    loginEmailController.text = "sachindevtest@yopmail.com";
    loginPasswordController.text = "Kas@123456";
  }

  showOrHideLoginPasswordVisibility() {
    securePassword.value = !securePassword.value;
    update();
  }

  Future logIn({bool isSocial = false, Map<String, dynamic>? socialPayload}) async {
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> payload = HashMap();
      payload[ApiConstants.username] = loginEmailController.text.trim();
      payload[ApiConstants.password] = loginPasswordController.text;
      isLoading.value = true;
      DataResponse<UniversalModel?> dataResponse = await _authApiProvider.signIn(payload);
      isLoading.value = false;
      if (dataResponse.successful == false) {
        isLoading.value = false;
        Utils.showSnackBar(dataResponse.error ?? dataResponse.error);
      } else {
        if (dataResponse.response != null) {
          TextInput.finishAutofillContext();
          UniversalModel loginModel = dataResponse.response!;
          StorageHelper storageHelper = StorageHelper();
          storageHelper.saveUserToken(loginModel.token);
          storageHelper.saveIsLoggedIn(true);
          storageHelper.saveRefreshToken(loginModel.refreshToken);
          getProfile();
        } else {
          isLoading.value = false;
          Utils.showSnackBar(dataResponse.error ?? dataResponse.error);
        }
      }
    }
  }

  Future getProfile() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<UserModal?> dataResponse = await _authApiProvider.getMyProfile();
      isLoading.value = false;
      if (dataResponse.successful == false) {
        Utils.showSnackBar(dataResponse.error ?? "Something went wrong");
      } else {
        if (dataResponse.response != null) {
          if(dataResponse.response?.hasStockAccess == false){
            getAppAccessPopUp();
          } else {
            var model = dataResponse.response;
            StorageHelper storageHelper = StorageHelper();
            storageHelper.saveUserModel(model);
            storageHelper.saveUserId(model?.id);
            storageHelper.saveUserFirstName(model?.firstname);
            storageHelper.saveUserLastName(model?.lastname);
            storageHelper.saveUserPhoneNumber(model?.phoneNumber);
            // storageHelper.saveSubscriptionPlan(model?.subscriptionDetails);
            if (storageHelper.getClinicId() == null) {
              if(model?.clinicDetails?.length == 1){
                storageHelper.saveClinicId(model?.clinicDetails?.first.key);
                storageHelper.saveClinicCode(model?.clinicDetails?.first.id);
                storageHelper.saveClinicModel(model?.clinicDetails?.first);
                Get.offAllNamed(AppRoutes.dashboard);
              } else {
                Get.offAllNamed(AppRoutes.authClinicSelection, arguments: {RoutesArgument.selectClinic: 1});
              }
            } else {
              Get.offAllNamed(AppRoutes.dashboard);
            }
          }

        } else {
          Utils.showSnackBar(dataResponse.error ?? "Something went wrong");
        }
      }
    }
  }
}
