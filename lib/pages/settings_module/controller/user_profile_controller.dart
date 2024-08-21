import 'package:denvin_stock/exports.dart';

class UserProfileController extends GetxController {

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  RxBool isLoading = false.obs;
  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneNumberFocusNode;

  @override
  void onInit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    phoneNumberFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    initialValues();
    super.onInit();
  }

  initialValues(){
    StorageHelper helper = StorageHelper();
    nameController.text = "${helper.getUserModel()?.firstname} ${helper.getUserModel()?.lastname}";
    emailController.text = helper.getUserModel()?.email ?? "";
    phoneNumberController.text = helper.getUserModel()?.phoneNumber ?? "";
  }

}