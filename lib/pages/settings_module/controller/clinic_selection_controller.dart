
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/api_provider/settings_api_provider.dart';

class ClinicSelectionController extends GetxController {

  RxBool isLoading = false.obs;
  Rxn<UserModal> userProfile = Rxn<UserModal>();
  RxList<SelectClinic> selectedList = <SelectClinic>[].obs;
  RxList<int> ids = <int>[].obs;
  Rxn<ClinicDetails> selectedClinicId = Rxn<ClinicDetails>();
  late StorageHelper helper;
  late SettingApiProvider _settingsApiProvider;
  late AuthApiProvider _authApiProvider;
  @override
  void onInit() {
    helper =  StorageHelper();
    _authApiProvider = AuthApiProvider();
    _settingsApiProvider = SettingApiProvider();
    super.onInit();
  }


  getUserProfile(){
    String? clinicId = "";
    if(helper.getClinicId() != null){
      clinicId = helper.getClinicId();
    }
    if(helper.getUserModel() != null){
      userProfile.value = helper.getUserModel();
      selectedClinicId.value = userProfile.value?.clinicDetails?.firstWhereOrNull((element) => element.key == clinicId) ?? helper.getClinicModel();
      List<SelectClinic>.generate(userProfile.value?.clinicDetails?.length ?? 0, (index) {
        ids.add(userProfile.value?.clinicDetails?[index].id ?? 0);
        return SelectClinic(
        isSelected: clinicId == userProfile.value?.clinicDetails?[index].key ? true : false,
        clinicDetails: userProfile.value?.clinicDetails?[index]
      );
      });
      getClinic();
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

  Future getClinic() async {
    if (await Utils.hasNetwork()) {
      String? clinicId = "";
      if(helper.getClinicId() != null){
        clinicId = helper.getClinicId();
      }
      isLoading.value = true;
      DataResponse<UserModal?> response = await _authApiProvider.getMyProfile();
      // DataResponse<PaginationResponseModal<ClinicDetails>> response = await _settingsApiProvider.getClinics();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          selectedList.value = List<SelectClinic>.generate(model?.clinicDetails?.length ?? 0, (index) {
            return SelectClinic(
                isSelected: clinicId == model?.clinicDetails?[index].key ? true : false,
                clinicDetails: model?.clinicDetails?[index]
            );
          });
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }
}

class SelectClinic {
  ClinicDetails? clinicDetails;
  bool? isSelected;
  SelectClinic({required this.clinicDetails, required this.isSelected});
}