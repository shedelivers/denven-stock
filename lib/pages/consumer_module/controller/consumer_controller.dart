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
  RxBool isLoadingMore = false.obs;

  static const int _pageSize = 10;
  int _currentPage = 1;
  int _total = 0;
  bool _isFetching = false;
  bool _reachedEnd = false;
  int _requestId = 0;

  bool get hasMoreData => !_reachedEnd && consumerList.length < _total;


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
    _currentPage = 1;
    _total = 0;
    _reachedEnd = false;
    _isFetching = false;
    isLoadingMore.value = false;
    await _fetchConsumerPage(page: 1);
  }

  Future<void> loadMoreCustomers() async {
    if (_isFetching || isLoading.value || !hasMoreData) return;
    await _fetchConsumerPage(page: _currentPage + 1);
  }

  Future<void> _fetchConsumerPage({required int page}) async {
    if (!await Utils.hasNetwork()) return;
    final isFirstPage = page == 1;
    final requestId = ++_requestId;
    _isFetching = true;
    if (isFirstPage) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try {
      DataResponse<PaginationResponseModal<ConsumerModal>> response =
          await _productApiProvider.getConsumer(page: page, pageSize: _pageSize);
      if (requestId != _requestId) return;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else if (response.response != null) {
        final model = response.response;
        final items = model?.data ?? [];
        consumerList.addAll(items);
        _currentPage = page;
        _total = model?.total ?? consumerList.length;
        if (items.isEmpty || (model?.total == null && items.length < _pageSize)) {
          _reachedEnd = true;
        }
        update();
      } else {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      }
    } finally {
      if (requestId == _requestId) {
        _isFetching = false;
        isLoading.value = false;
        isLoadingMore.value = false;
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