import 'dart:ffi';

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/product_module/controller/choose_storage_controller.dart';

Future<Supplier?> chooseStorageDialog({required Supplier selectedItem,Storage? filterItem, List<int>? disabledList, bool? boolValue}) {
  return Get.dialog<Supplier?>(
    Container(
      alignment: Alignment.center,
      child: Container(
          height: Get.height * 0.8,
          width: Get.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: margin_10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius_20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextView(
                    "Choose Your Storage",
                    style: black_17_700()?.copyWith(color: primaryColor),
                  ).marginSymmetric(vertical: margin_15, horizontal: margin_15),
                  const Spacer(),
                  IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close))
                ],
              ).marginSymmetric(horizontal: 10.0),
              Expanded(child: ChooseStorageView(
                selectedItem: selectedItem,
                disabledList: disabledList,
                filterItem: filterItem,
                boolValue: boolValue,
              )),
            ],
          )),
    ),
  );
}

class ChooseStorageView extends GetView<ChooseStorageController> {
  final Supplier selectedItem;
  final Storage? filterItem;
  final List<int>? disabledList;
  final bool? boolValue;

  ChooseStorageView({Key? key, required this.selectedItem,this.filterItem ,required this.disabledList, this.boolValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseStorageController(supplierList: selectedItem,filteredItem: filterItem, boolValue: boolValue));
    return GetBuilder<ChooseStorageController>(
        builder: (controller) {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            _searchFieldView(context: context, boolValue: boolValue),
            controller.supplierList.isEmpty ? Expanded(child: Utils.noDataFound(message: "No storage found")) : Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: margin_0),
                  itemCount: controller.supplierList.length,
                  itemBuilder: (context, index) {
                    Supplier? item = controller.supplierList[index];
                    return Row(
                      children: [
                        Checkbox(
                            activeColor: disabledList?.contains(item.id)??false? primaryColor.withOpacity(0.5) : primaryColor,
                            value: disabledList == null? false: controller.selectedSkillList?.id == item.id || disabledList!.contains(item.id),
                            onChanged: (bool? value) {
                              if (!(disabledList?.contains(item.id) ?? false)) {
                                if (value ?? false) {
                                  controller.selectedSkillList = item;
                                }
                              }
                              // if(!disabledList!.contains(item.id)){
                              //   if(value ?? false){
                              //     controller.selectedSkillList = item;
                              //   }
                              // }
                              setState(() {});
                              controller.update();
                            }),
                        TextView(item.name ?? "",style: TextStyle(color: disabledList?.contains(item.id)??false ? Colors.grey : Colors.black),).paddingSymmetric(horizontal: 10.0, vertical: 8.0),
                      ],
                    ).marginSymmetric(horizontal: 16);
                  }),
            ),
            AppButton(
                buttonText: "Select",
                buttonColor: primaryColor,
                onTap: () {
                  Supplier supplier = controller.supplierList.firstWhere((element) => element.id == controller.selectedSkillList?.id);
                  Get.back(result: supplier);
                }).marginSymmetric(horizontal: margin_20)
          ],
        );
      });
    });
  }

  _searchFieldView({required BuildContext context, bool? boolValue}) {
    return CustomTextFieldV3(
      hintText: "Search Storage",
      controller: controller.searchController,
      focusNode: controller.searchFocusNode,
      onFieldSubmitted: (String? value) =>
          FocusScope.of(Get.context!).unfocus(),
      onChanged: (value) {
        // controller.currentPage.value = 0;
        // if (controller.debounce?.isActive ?? false) {
        //   controller.debounce?.cancel();
        // }
        // controller.debounce =
        //     Timer(const Duration(milliseconds: 500), () {
        //       controller.getImplantStockData();
        //     });
      },
      suffix: IconButton(
        onPressed: () {
          controller.hitapi(boolValue);
        },
        icon: imageAsset(search, height: 16.0),
      ),
    ).marginSymmetric(horizontal: margin_20, vertical: margin_10);
  }
}