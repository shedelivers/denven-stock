import 'package:denvin_stock/exports.dart';

Future<List<Supplier>?> chooseStorageDialogV2({required List<Supplier> selectedItem}) {
  return Get.dialog<List<Supplier>>(
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
              )),
            ],
          )),
    ),
  );
}

class ChooseStorageController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  PaginationResponseModal<Supplier>? allSkillResponseModal;
  List<Supplier> supplierList = [];
  List<Supplier> selectedSkillList = [];
  bool isSelectAll = true;
  RxBool isSearchFocused = false.obs;

  late ProductApiProvider _productApiProvider;
  ChooseStorageController({required List<Supplier> supplierList}) {
    selectedSkillList = [];
    if (supplierList.isNotEmpty) {
      isSelectAll = false;
    }
    selectedSkillList.addAll(supplierList );
    update();
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
      supplierList = [];
      DataResponse<PaginationResponseModal<Supplier>> response = await _productApiProvider.getStorage(search: searchController.text);
      customLoader.hide();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          supplierList.addAll(model?.data ?? []);
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }
}

class ChooseStorageView extends GetView<ChooseStorageController> {
  final List<Supplier> selectedItem;
  const ChooseStorageView({Key? key, required this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseStorageController(supplierList: selectedItem));

    return GetBuilder<ChooseStorageController>(builder: (controller) {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            _searchFieldView(context: context),
            Row(
              children: [
                Checkbox(
                    activeColor: primaryColor,
                    value: (controller.selectedSkillList ).isEmpty ||
                        controller.isSelectAll,
                    onChanged: (bool? value) {
                      if (value ?? false) {
                        controller.isSelectAll = true;
                        controller.selectedSkillList = [];
                      }
                      setState(() {});
                      controller.update();
                    }),
                TextView("All").paddingSymmetric(
                    horizontal: 10.0, vertical: 8.0),
              ],
            ).marginSymmetric(horizontal: 16),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: margin_0),
                  itemCount: controller.supplierList.length,
                  itemBuilder: (context, index) {
                    Supplier? item = controller.supplierList[index];
                    return Row(
                      children: [
                        Checkbox(
                            activeColor: primaryColor,
                            value: (controller.selectedSkillList ).firstWhereOrNull((element) => element.id == item.id,) != null,
                            onChanged: (bool? value) {
                              if (!(value ?? false)) {
                                controller.selectedSkillList.removeWhere((element) => element.id == item.id);
                                controller.update();
                              } else {
                                controller.selectedSkillList.add(item);
                                controller.isSelectAll = false;
                              }
                              setState(() {});
                              controller.update();
                            }),
                        TextView(item.name ?? "").paddingSymmetric(horizontal: 10.0, vertical: 8.0),
                      ],
                    ).marginSymmetric(horizontal: 16);
                  }),
            ),
            AppButton(
                buttonText: "Apply",
                buttonColor: primaryColor,
                onTap: () {
                  Get.back(result: controller.selectedSkillList);
                }).marginSymmetric(horizontal: margin_20)
          ],
        );
      });
    });
  }

  _searchFieldView({required BuildContext context}) {
    return CustomTextFieldV3(
      hintText: Strings.searchStorage,
      controller: controller.searchController,
      focusNode: controller.searchFocusNode,
      onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
      onChanged: (value) {},
      suffix: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          controller.isSearchFocused.value && controller.searchController.text.isNotEmpty ? IconButton(onPressed: (){
            controller.searchController.clear();
            controller.isSearchFocused.value = false;
            controller.hitapi();
          }, icon: const Icon(Icons.close,color: Colors.black,size: 16,)) : const SizedBox(),
          IconButton(
            onPressed: () {
              controller.hitapi();
              controller.isSearchFocused.value = true;
            },
            icon: imageAsset(search, height: 16.0,color: Colors.black),
          ),
        ],
      ),
    ).marginSymmetric(horizontal: margin_20, vertical: margin_10);
  }
}
