import 'package:denvin_stock/exports.dart';


class AuthClinicSelectionController extends GetxController {

  RxBool isLoading = false.obs;
  Rxn<UserModal> userProfile = Rxn<UserModal>();
  RxList<SelectClinic> selectedList = <SelectClinic>[].obs;
  Rxn<ClinicDetails> selectedClinicId = Rxn<ClinicDetails>();
  late StorageHelper helper;

  @override
  void onInit() {
    helper =  StorageHelper();

    super.onInit();
  }

  getUserProfile(){
    String? clinicId = "";
    if(helper.getClinicId() != null){
      clinicId = helper.getClinicId();
    }
    if(helper.getUserModel() != null){
      userProfile.value = helper.getUserModel();
      selectedList.value = List<SelectClinic>.generate(userProfile.value?.clinicDetails?.length ?? 0, (index) => SelectClinic(
          isSelected: clinicId == userProfile.value?.clinicDetails?[index].key ? true : false,
          clinicDetails: userProfile.value?.clinicDetails?[index]
      ));
    }
  }

  selectClinicId(int index){
    for (int i = 0; i < selectedList.length; i++) {
      if (i == index) {
        selectedList[i].isSelected = true;
      } else {
        selectedList[i].isSelected = false;
      }
    }
    selectedClinicId.value = selectedList[index].clinicDetails;
    selectedList.refresh();
    update();
  }

  submitClinicId(){
    helper.saveClinicId(selectedClinicId.value?.key);
    helper.saveClinicCode(selectedClinicId.value?.id);
    helper.saveClinicModel(selectedClinicId.value);
    // if(helper.getSubscriptionPlan() != null){
      Get.offAllNamed(AppRoutes.dashboard);
    // } else {
    //   Get.offAllNamed(AppRoutes.subscriptionScreen);
    // }
  }






}

class SelectClinic {
  ClinicDetails? clinicDetails;
  bool? isSelected;
  SelectClinic({required this.clinicDetails, required this.isSelected});
}