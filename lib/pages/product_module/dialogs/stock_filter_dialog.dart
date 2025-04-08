import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/filter_modal.dart';
import 'package:denvin_stock/pages/product_module/dialogs/choose_storage_dialog.dart';
import 'package:denvin_stock/pages/product_module/dialogs/choose_supplier_dialog.dart';

Future stockBottomSheet() {
  return showModalBottomSheet(
    context: Get.context!,
    useRootNavigator: false,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext bc) => ConsumptionReportFilterDialog(),
  );
}

class ConsumptionReportFilterDialog extends GetView<ConsumptionFilterController> {
  ConsumptionReportFilterDialog({super.key});
  final consumptionFilterController = Get.put(ConsumptionFilterController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsumptionFilterController>(builder: (controller) {
      return GestureDetector(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 27),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15,),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          vGap(10.0),
                          TextView(Strings.filter, style: black_20_700()?.copyWith(color: primaryColor)),
                          const SizedBox(
                            height: 10.0,
                          ),

                          selectDatesView(categoryDropdown: controller.datesList.map((e) => DropdownMenuItem<ExpiryFilterDTO>(value: e, child: Text(e.title,),),).toList()),
                          const SizedBox(
                            height: 20.0,
                          ),

                          selectBarCodeView(categoryDropdown: controller.barCode.map((e) => DropdownMenuItem<ExpiryFilterDTO>(value: e, child: Text(e.title,),),).toList()),
                          const SizedBox(
                            height: 20.0,
                          ),

                          showHiddenView(hiddenList: controller.hiddenList.map((e) => DropdownMenuItem<ExpiryFilterDTO>(value: e, child: Text(e.title,),),).toList()),
                          const SizedBox(
                            height: 20.0,
                          ),

                          showOpenProductsView(openProductsList: controller.openProductsList.map((e) => DropdownMenuItem<ExpiryFilterDTO>(value: e, child: Text(e.title,),),).toList()),
                          const SizedBox(
                            height: 20.0,
                          ),



                          chooseSupplierView(),
                          const SizedBox(
                            height: 10.0,
                          ),

                          chooseStorageView(),
                          const SizedBox(
                            height: 10.0,
                          ),


                          /*Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  controller.showHiddenProduct = !controller.showHiddenProduct;
                                  controller.filterModal.showHiddenProduct = controller.showHiddenProduct;
                                  controller.update();},
                                child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                                    margin: const EdgeInsets.only(bottom: 10.0, right: 10),
                                    decoration: BoxDecoration(border: Border.all(width: 2,color: controller.showHiddenProduct? primaryColor:greyText), borderRadius: BorderRadius.circular(30.0)),
                                    child: TextView("Show hidden product",)),
                              ),
                            ],
                          ),*/

                          const SizedBox(
                            height: 10.0,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                    buttonText: "Apply",
                                    buttonColor: primaryColor,
                                    onTap: () {
                                      Get.back();
                                      Get.find<InventoryController>().myFilterModal.value  = controller.filterModal;
                                      Get.find<InventoryController>().getInventoryData();
                                    }),
                              ),
                              hGap(height_10),
                              Expanded(
                                child: AppButton(
                                    buttonColor: Colors.grey,
                                    textColor: Colors.white,
                                    buttonText: "Reset",
                                    onTap: () {
                                      controller.resetButton();
                                      Get.find<InventoryController>().myFilterModal.value = null;
                                      Get.find<InventoryController>().getInventoryData();
                                      Get.back();
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ).marginSymmetric(horizontal: margin_20),
                    ),
                  ],
                ),

                Positioned(
                  right: 16,
                  top: 0,
                  child: Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(Get.context!).requestFocus(FocusScopeNode());
        },
      );
    });
  }


  Widget selectDatesView({required List<DropdownMenuItem<ExpiryFilterDTO>> categoryDropdown}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Expiry Date"),
        vGap(10.0),
         Container(
            decoration: BoxDecoration(
                color: textFieldFillColor,
                border: Border(
                    bottom: BorderSide(color: textFieldBorderColor, width: 1))),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<ExpiryFilterDTO>(
                  isExpanded: true,
                  value: controller.selectedDatesCalendar,
                  hint: TextView(
                    "Select Dates",
                    style: TextStyle(
                        color: hintTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  padding: const EdgeInsets.symmetric( vertical: 4.0),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
                  iconSize: 24,
                  style: const TextStyle(color: Colors.black,),
                  underline: Container(height: 0, color: Colors.transparent,),
                onChanged: (value) async {
                  controller.selectedDatesCalendar = value;
                  controller.filterModal.expiryState = value?.id ?? "";
                  controller.update();
                },
                  elevation: 1,
                  items: categoryDropdown,
                ),
            ),
          ),
      ],
    );
  }


  Widget selectBarCodeView({required List<DropdownMenuItem<ExpiryFilterDTO>> categoryDropdown}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Barcode"),
        vGap(10.0),
         Container(
            decoration: BoxDecoration(
                color: textFieldFillColor,
                border: Border(
                    bottom: BorderSide(color: textFieldBorderColor, width: 1))),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<ExpiryFilterDTO>(
                  isExpanded: true,
                  value: controller.selectedBarCodeCalendar,
                  hint: TextView(
                    "Select",
                    style: TextStyle(
                        color: hintTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
                  iconSize: 24,
                  style: const TextStyle(color: Colors.black,),
                  underline: Container(height: 0, color: Colors.transparent,),
                onChanged: (value) async {
                  controller.selectedBarCodeCalendar = value;
                  controller.filterModal.barcodeStatus = value?.id ?? "";
                  controller.update();
                },
                  elevation: 1,
                  items: categoryDropdown,
                ),
            ),
          ),
      ],
    );
  }


  Widget chooseSupplierView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Suppliers"),
        vGap(10.0),
        CustomTextField(
            hintText: "Choose Supplier",
            readOnly: true,
            focusNode: controller.selectedSupplierFocusNode,
            onTap: (){
              chooseSupplierDialog(selectedItem: controller.filterModal.selectedItem ?? []).then((value) {
                controller.filterModal.selectedItem = value ?? [];
                controller.selectedSupplierFocusNode.unfocus();
                controller.update();
              });
            },
        ),
        vGap(12.0),
        Wrap(
          children: [
            if ((controller.filterModal.selectedItem ?? []).isEmpty) isAllItem(),
            for (Supplier i in (controller.filterModal.selectedItem ?? []))
              skillItemView(enumDatModal: i, onDeleteTap: (){
                (controller.filterModal.selectedItem ?? []).remove(i);controller.update();
               }
             )
          ],
        ),
      ],
    );
  }


  Widget chooseStorageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Storage"),
        vGap(10.0),
        CustomTextField(
          hintText: "Choose Storage",
          readOnly: true,
          focusNode: controller.selectedStorageFocusNode,
          onTap: (){
            chooseStorageDialogV2(selectedItem: controller.filterModal.selectedStorageItem ?? []).then((value) {
              controller.filterModal.selectedStorageItem = value ?? [];
              controller.selectedStorageFocusNode.unfocus();
              controller.update();
            });
          },
        ),
        vGap(12),
        Wrap(
          children: [
            if ((controller.filterModal.selectedStorageItem ?? []).isEmpty) isAllItem(),
            for (Supplier i in (controller.filterModal.selectedStorageItem ?? []))
                skillItemView(enumDatModal: i,onDeleteTap: (){(controller.filterModal.selectedStorageItem ?? []).remove(i);
                controller.update();
              })
          ],
        ),
      ],
    );
  }


  Widget showHiddenView({required List<DropdownMenuItem<ExpiryFilterDTO>> hiddenList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Hidden Products"),
        vGap(10.0),
        Container(
          decoration: BoxDecoration(
              color: textFieldFillColor,
              border: Border(
                  bottom: BorderSide(color: textFieldBorderColor, width: 1))),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<ExpiryFilterDTO>(
              isExpanded: true,
              value: controller.selectedHiddenProduct,
              hint: TextView(
                "Show Hidden Products",
                style: TextStyle(
                    color: hintTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
              ),
              padding: const EdgeInsets.symmetric( vertical: 4.0),
              icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
              iconSize: 24,
              style: const TextStyle(color: Colors.black,),
              underline: Container(height: 0, color: Colors.transparent,),
              onChanged: (value) async {
                controller.selectedHiddenProduct = value;
                controller.filterModal.showHiddenProduct = value?.id;
                controller.update();
              },
              elevation: 1,
              items: hiddenList,
            ),
          ),
        ),
      ],
    );
  }


  Widget showOpenProductsView({required List<DropdownMenuItem<ExpiryFilterDTO>> openProductsList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.textFieldLabel(label: "Opened Products"),
        vGap(10.0),
        Container(
          decoration: BoxDecoration(
              color: textFieldFillColor,
              border: Border(
                  bottom: BorderSide(color: textFieldBorderColor, width: 1))),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<ExpiryFilterDTO>(
              isExpanded: true,
              value: controller.selectedOpenProducts,
              hint: TextView(
                "Opened Products",
                style: TextStyle(
                    color: hintTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),
              ),
              padding: const EdgeInsets.symmetric( vertical: 4.0),
              icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
              iconSize: 24,
              style: const TextStyle(color: Colors.black,),
              underline: Container(height: 0, color: Colors.transparent,),
              onChanged: (value) async {
                controller.selectedOpenProducts = value;
                controller.filterModal.openProducts = value?.id;
                controller.update();
              },
              elevation: 1,
              items: openProductsList,
            ),
          ),
        ),
      ],
    );
  }


  skillItemView({required Supplier enumDatModal,required GestureTapCallback onDeleteTap}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4.0),
        margin: const EdgeInsets.only(bottom: 10.0,right: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 2,color: primaryColor),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text((enumDatModal.name ?? ""),),
            hGap(4.0),
            Icon(
              Icons.close,
              size: height_15,
            ).onTap(onDeleteTap),
          ],
        ));
  }


  consumerItemView({required ConsumerModal enumDatModal,required GestureTapCallback onDeleteTap}) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.all(margin_5),
            margin:
                const EdgeInsets.symmetric(horizontal: margin_5, vertical: margin_10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: appColor,
                  width: width_1,
                ),
                borderRadius: BorderRadius.circular(radius_10)),
            child: Text(
              (enumDatModal.firstname ?? ""),
              // style: getTextStyleBodyMediumText(),
            )),
        Positioned(
          right: 0,
          child: InkWell(
            onTap: onDeleteTap,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: appGreenColor),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: height_15,
              ),
            ),
          ),
        )
      ],
    );
  }


  isAllItem() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
        margin: const EdgeInsets.only(bottom: 10.0, right: 10),
        decoration: BoxDecoration(border: Border.all(width: 2,color: primaryColor), borderRadius: BorderRadius.circular(30.0)),
        child: TextView("All",));
  }

}

class ConsumptionFilterController extends GetxController {

  ExpiryFilterDTO? selectedDatesCalendar;
  ExpiryFilterDTO? selectedHiddenProduct;
  ExpiryFilterDTO? selectedOpenProducts;
  ExpiryFilterDTO? selectedBarCodeCalendar;
  FilterModal filterModal = FilterModal();

  List<ExpiryFilterDTO> datesList = <ExpiryFilterDTO>[
    ExpiryFilterDTO(
        title: "Expired products",
        id: "1"
    ),

    ExpiryFilterDTO(
        title: "Expires in 3 months",
        id: "2"
    ),

    ExpiryFilterDTO(
        title: "Expires in 6 months ",
        id: "3"
    ),
  ];

  List<ExpiryFilterDTO> barCode = <ExpiryFilterDTO>[
    ExpiryFilterDTO(
        title: "All",
        id: "0"
    ),

    ExpiryFilterDTO(
        title: "Scanned Product",
        id: "1"
    ),

    ExpiryFilterDTO(
        title: "Products to Scan",
        id: "2"
    ),
  ];


  List<ExpiryFilterDTO> hiddenList = <ExpiryFilterDTO>[
    ExpiryFilterDTO(
        title: "Show Hidden Products",
        id: "0"
    ),

    ExpiryFilterDTO(
        title: "Hide Hidden Products",
        id: "1"
    ),

  ];

  List<ExpiryFilterDTO> openProductsList = <ExpiryFilterDTO>[
    ExpiryFilterDTO(
        title: "All",
        id: "1"
    ),

    ExpiryFilterDTO(
        title: "Packages",
        id: "2"
    ),

    ExpiryFilterDTO(
        title: "Open products",
        id: "3"
    ),
  ];


  FocusNode selectedSupplierFocusNode = FocusNode();
  FocusNode selectedStorageFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  resetButton() {
    selectedDatesCalendar = null;
    selectedBarCodeCalendar = null;
    selectedHiddenProduct = null;
    selectedOpenProducts = null;
    filterModal = FilterModal();
    update();
  }

  filterButton() {}
}


class ExpiryFilterDTO {
  String title;
  String id;
  ExpiryFilterDTO({required this.title,required this.id});
}

