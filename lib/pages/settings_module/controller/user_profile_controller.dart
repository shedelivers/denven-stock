import 'package:denvin_stock/exports.dart';

class UserProfileController extends GetxController {

  late TextEditingController firstNameController;
  late TextEditingController lastNameNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  RxBool isLoading = false.obs;
  RxBool isUpdatingProfile = false.obs;
  late FocusNode firstNameFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneNumberFocusNode;
  StorageHelper helper = StorageHelper();
  late AuthApiProvider _authApiProvider;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    phoneNumberFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    initialValues();
    super.onInit();
  }

  initialValues(){
    firstNameController.text = helper.getUserFirstName()??"";
    lastNameNameController.text = helper.getUserLastName()??"";
    emailController.text = helper.getUserModel()?.email ?? "";
    phoneNumberController.text = helper.getUserPhoneNumber()??"";
    _authApiProvider = AuthApiProvider();
  }


  Future<void> updateUserProfile () async{

    Map<String, dynamic> data = {
      "id": helper.getUserModel()?.id??0,
      "firstname": firstNameController.text,
      "lastname": lastNameNameController.text,
      "email": emailController.text,
      "securityId": helper.getUserModel()?.securityId,
      "emailConfirmed": true,
      "phoneNumberConfirmed": phoneNumberController.text.isNotEmpty,
      "status": 1
    };

    data.addAllIf(phoneNumberController.text.isNotEmpty, {"phoneNumber": phoneNumberController.text});


      if (await Utils.hasNetwork()) {
        String firstName = firstNameController.text;
        String lastName = lastNameNameController.text;
        String phoneNumber = phoneNumberController.text;

        isUpdatingProfile.value = true;
        ComanResponseModal? dataResponse = await _authApiProvider.updateProfile(userId: helper.getUserModel()?.id.toString()??"0", data: data);
        isUpdatingProfile.value = false;
        if (dataResponse.successful == false) {
          Utils.showSnackBar(dataResponse.error ?? "Something went wrong");
        } else {
          if (dataResponse.response != null){
            Utils.showSnackBar("Update Successfully");
            helper.saveUserFirstName(firstName);
            helper.saveUserLastName(lastName);
            helper.saveUserPhoneNumber(phoneNumber);

          } else {
            Utils.showSnackBar(dataResponse.error ?? "Something went wrong");
          }
        }
      }
  }
}