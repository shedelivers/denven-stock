import 'dart:collection';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/api_provider/settings_api_provider.dart';

class ConsumerTitle {
  String? name;
  int value;
  ConsumerTitle({required this.value,this.name});
}

class ConsumerController extends GetxController {

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController descriptionController;

  late FocusNode firstNameFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode descriptionFocusNode;

  late ProductApiProvider _productApiProvider;
  late SettingApiProvider _settingsApiProvider;

  RxBool isEdit = false.obs;
  Rxn<ConsumerModal> editingConsumer  = Rxn();

  RxList<ConsumerModal> consumerList = <ConsumerModal>[].obs;
  RxList<ConsumerTitle> consumerTitle = <ConsumerTitle>[
    ConsumerTitle(value: 1, name: "Dr"),
    ConsumerTitle(value: 2, name: "Mr"),
    ConsumerTitle(value: 3, name: "Mrs"),
  ].obs;
  Rxn<ConsumerTitle> selectedTitle = Rxn<ConsumerTitle>();
  RxBool isLoading = false.obs;


  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    descriptionController = TextEditingController();

    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();

    _settingsApiProvider = SettingApiProvider();
    _productApiProvider  = ProductApiProvider();
    getCustomer();
    super.onInit();
  }

  addDefaultValues() {
    if(editingConsumer.value != null){
      firstNameController.text = editingConsumer.value?.firstname ?? "";
      lastNameController.text = editingConsumer.value?.lastname ?? "";
      descriptionController.text = editingConsumer.value?.description ?? "";
      selectedTitle.value = consumerTitle.where((p0) => p0.value == editingConsumer.value?.title).firstOrNull;
      print(selectedTitle.value);
    }
  }

  getCustomer() async {
    consumerList.clear();
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<PaginationResponseModal<ConsumerModal>> response = await _productApiProvider.getConsumer();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          consumerList.addAll(model?.data ??[]);
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }


  cleanState(){
    firstNameController.clear();
    lastNameController.clear();
    descriptionController.clear();
    selectedTitle.value = null;
  }

  Future addConsumer() async{
    if (await Utils.hasNetwork()) {
     Map<String,dynamic> payload =  HashMap();
     payload[ApiConstants.Title] = selectedTitle.value?.value;
     payload[ApiConstants.Firstname] = firstNameController.text;
     payload[ApiConstants.Lastname] = lastNameController.text;
     if(descriptionController.text.isNotEmpty) {
       payload[ApiConstants.Description] = descriptionController.text;
     }
     isLoading.value = true;
     DataResponse<UniversalModel?> response = await _settingsApiProvider.addConsumer(payload,isEdit: isEdit.value,consumerId: editingConsumer.value?.id.toString());
     isLoading.value = false;
     if (response.successful == false) {
       Utils.showSnackBar(response.error ?? "Unable to add data");
     } else {
       if (response.response != null) {
         var model = response.response;
         cleanState();
         Get.back(result: isEdit.value ? "EDITED" : "ADDED");
         if(isEdit.value){
           Utils.showSnackBar("Dentist edited successfully",isSuccess: true);
         } else{
           Utils.showSnackBar("Dentist added successfully", isSuccess: true);
         }
       } else {
         Utils.showSnackBar(response.error ?? "Unable to add data");
       }
     }
    }
  }

  Future deleteConsumer(String consumerId) async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      ComanResponseModal? response = await _settingsApiProvider.deleteConsumer(consumerId);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to add data");
      } else {
        if (response.response != null) {
          var model = response.response;
          if(model){
            getCustomer();
            Utils.showSnackBar("Dentist deleted successfully",isSuccess: true);
          }
        } else {
          Utils.showSnackBar(response.error ?? "Unable to add data");
        }
      }
    }
  }

}