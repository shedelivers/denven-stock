

import 'package:denvin_stock/exports.dart';

class ChooseStorageController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  PaginationResponseModal<Supplier>? allSkillResponseModal;
  List<Supplier> supplierList = [];
  Supplier? selectedSkillList;
  Storage? filteredItemStorage;

  late ProductApiProvider _productApiProvider;
  bool? boolValue;

  ChooseStorageController({required Supplier supplierList, Storage? filteredItem, bool? boolValue}) {
    selectedSkillList = supplierList;
    filteredItemStorage = filteredItem;
    boolValue = boolValue;
    hitapi(boolValue);
  }

  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    super.onInit();
  }

  hitapi(bool? boolValue) async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      supplierList = [];
      DataResponse<PaginationResponseModal<Supplier>> response =
      await _productApiProvider.getStorage(search: searchController.text, boolValue: boolValue);
      customLoader.hide();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          supplierList.addAll(model?.data ?? []);
          if(filteredItemStorage != null){
            supplierList.removeWhere((element) => element.id == filteredItemStorage?.id);
          }
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }
}