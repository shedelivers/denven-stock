import 'package:denvin_stock/exports.dart';

class ChooseDentistController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  PaginationResponseModal<Supplier>? allSkillResponseModal;
  List<ConsumerModal> consumerList = [];
  ConsumerModal? selectedSkillList;
  Storage? filteredItemStorage;
  RxBool isLoading = false.obs;

  late ProductApiProvider _productApiProvider;

  ChooseDentistController({required ConsumerModal supplierList, Storage? filteredItem}) {
    selectedSkillList = supplierList;
    filteredItemStorage = filteredItem;
  }

  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    hitapi();
    super.onInit();
  }

  hitapi() async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      consumerList = [];
      isLoading.value = true;
      DataResponse<PaginationResponseModal<ConsumerModal>> response = await _productApiProvider.getConsumer();
      isLoading.value = false;
      customLoader.hide();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          consumerList.addAll(model?.data ?? []);
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }
}