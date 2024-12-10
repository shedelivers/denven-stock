import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/product_module/choose_storage_view.dart';

class MoveStorageScreen extends GetView<MoveStorageController> {
  final formGlobalKey = GlobalKey<FormState>();

  MoveStorageScreen({super.key}){
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(centerLogo: false, showBack: true, showLogo: false, title: "Move to storage"),
          body: _mainBody()),
    );
  }
  _mainBody(){
    return Column(
      children: [
        Expanded(
          child: Form(
            key: formGlobalKey,
            child: ListView(
              children: [
                vGap(10.0),
                CustomProductBoxView(
                  title: 'Current Storage',
                  subtitle: controller.selectedStorage.value?.name ?? "" ??  Strings.nA,
                ).marginSymmetric(horizontal: 20.0),
                // Text(controller.selectedStorage.value?.name ?? "", style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),).marginSymmetric(horizontal: 20.0),
                vGap(10.0),
                ...List.generate(controller.numberOfFoams.value, (index) => Theme(
                  data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(bottom: 16, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1, color: textFieldBorderColor)),
                    child: ExpansionTile(
                      initiallyExpanded: index == 0 ? true : false,
                      key: Key(index.toString()),
                      tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      childrenPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 0),
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomProductBoxView(
                                  title: 'Quantity',
                                  subtitle: controller.products.value?.expiries?[index].qty.toString() ??  Strings.nA,
                                ),
                              ),
                              hGap(4),

                              Expanded(
                                child:Column(
                                  children: [
                                    TextView('Expiry Date', style: black_14_500(),),

                                    controller.products.value?.expiriesWithPrice?[index].date  != null && controller.products.value!.expiriesWithPrice![index].date!.isNotEmpty ?? false?
                                    Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                                        margin: const EdgeInsets.only(bottom: 6.0),
                                        decoration: BoxDecoration(
                                            color: controller.products.value?.expiriesWithPrice != null ? controller.getExpiryColor(index: index, list: controller.products.value!.expiriesWithPrice ?? []) : Colors.grey,
                                            borderRadius: BorderRadius.circular(6.0)
                                        ),
                                        child: SelectableText(controller.products.value?.expiriesWithPrice?[index].date ?? Strings.nA, style: greyColor_16_600()?.copyWith(color: Colors.white, fontSize: 14))):
                                    Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                                        margin: const EdgeInsets.only(bottom: 6.0),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(6.0)
                                        ),
                                        child: SelectableText(Strings.nA, style: greyColor_16_600()?.copyWith(color: Colors.white, fontSize: 14)))
                                  ],
                                ),
                              ),

                             /* Expanded(
                                child: CustomProductBoxView(
                                  title: 'Expiry Date',
                                  subtitle: controller.products.value?.expiries?[index].at?.isEmpty ?? true ? "N/A" : controller.products.value?.expiries?[index].at ?? Strings.nA,
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                      children: <Widget>[
                        _counter(index)
                      ],
                    ),
                  ),
                )),

              ],
            ),
          ),
        ),
        SafeArea(child:
        Obx(()=> AppButton(
            isLoading: controller.isLoading.value,
            onTap:(){
            if (formGlobalKey.currentState!.validate()) {
              controller.submit();
            }
          },buttonText: 'Move to storage',),
        )
        ).paddingSymmetric(horizontal: 20.0),
      ],
    );
  }

  _counter(int index){
    return _productNewQtyBar(index);
  }
  
  _productNewQtyBar(int index){
    return Column(
      children: [
        Divider(color: textFieldBorderColor,thickness: 1,height: 1,),
        vGap(10.0),
        _storageQty(index),
      ],
    );
  }

  _storageQty(int index){
    return GetBuilder<MoveStorageController>(
      builder: (controller) {
        return  Column(
          children: [
            vGap(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextView(
                      "Add New Storage ",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13),
                    ),
                    hGap(6.0),
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ).onTap(() {
                controller.addNewExpAndQuantity(index, controller.products.value?.expiries?[index].at ?? "");
              }),
            ),
            vGap(10.0),
            ...List.generate(controller.quantityController[index].value?.length ?? 0, (subIndex) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                            readOnly: true,
                            hintText: Strings.selectStorage,
                            validator: (value) => value?.isEmptyField(messageTitle: Strings.storage),
                            onTap: (){
                              List<int> disableList = [];
                              for(Moves move in controller.movesMainLists[index].value ?? []){
                                if(move.expiry == controller.products.value?.expiries?[index].at){
                                  disableList.add(move.storageId ?? 0);
                                }
                              }
                              Supplier selectedSupplier = Supplier(
                                id: controller.movesMainLists[index].value![subIndex].storageId,
                              );
                              chooseStorageDialog(filterItem: controller.selectedStorage.value,selectedItem: selectedSupplier,disabledList: disableList, boolValue: true).then((value) {
                                Moves move = controller.movesMainLists[index].value?.removeAt(subIndex) ?? Moves();
                                move.storageId = value?.id;
                                controller.movesMainLists[index].value?.insert(subIndex, move);
                                controller.storageFocusNode[index].value![subIndex].unfocus();
                                if(value?.name != null){
                                  controller.storageController[index].value![subIndex].text = value?.name ?? "";
                                } else {
                                  controller.storageController[index].value![subIndex].clear();
                                }
                              });
                              },
                            inputFormatters: [DateFormatter()],
                            controller: controller.storageController[index].value![subIndex],
                            textInputType: TextInputType.datetime,
                            suffix: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: greyIconColor,
                            ),
                            focusNode: controller.storageFocusNode[index].value![subIndex],
                            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()
                        ),
                      ),
                      hGap(10.0),
                      Expanded(
                        child: CustomTextField(
                            hintText: Strings.quantity,
                            controller: controller.quantityController[index].value![subIndex],
                            textInputType: TextInputType.number,
                            onChanged: (qtyValue) {
                              Moves move = controller.movesMainLists[index].value?.removeAt(subIndex) ?? Moves();
                              move.qty = int.tryParse(qtyValue);
                              controller.movesMainLists[index]. value?.insert(subIndex, move);

                            },
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            validator: (value) => _validateForm(value, controller.products.value?.expiries?[index].qty ?? 0, controller.quantityController[index].value!),
                            focusNode: controller.quantityFocusNode[index].value![subIndex],
                            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()),
                      ),
                      if (subIndex != 0)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              controller.deleteExpAndQuantity(index,subIndex,controller.products.value?.expiries?[index].at ?? "");
                            },
                            child: const SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ).marginOnly(top: 14)
                    ],
                  ).marginOnly(bottom: 10,),
                ],
              );
            }),
            vGap(20.0),
          ],
        );
      },
    );
  }

  // _counterBar(int index){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       InkWell(
  //         borderRadius: BorderRadius.circular(10.0),
  //         splashColor: primaryColor,
  //         onTap: (){
  //           controller.minusCount(index,);
  //         },
  //         child: TextView("-", style: black_20_700()).paddingSymmetric(horizontal: 20.0),
  //       ),
  //       hGap(6),
  //       Obx(()=> TextView(controller.counter[index].toString(), style: black_24_700())),
  //       hGap(6),
  //       InkWell(
  //         borderRadius: BorderRadius.circular(10.0),
  //         splashColor: primaryColor,
  //         onTap:(){
  //           controller.addCount(index);
  //         },
  //         child: TextView("+", style: black_20_700()).paddingSymmetric(horizontal: 20.0),
  //       ),
  //     ],
  //   );
  // }
  
  _productQtyBar(int index){
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(Strings.productQuantity, style: black_14_600()?.copyWith(color: const Color(0xff707070)),),
          TextView("${controller.products.value?.expiries?[index].qty ?? Strings.nA}", style: black_14_400()?.copyWith()),
        ],
      ),
    );
  }

  String? _validateForm(String? value, int totalQuantity, List<TextEditingController> controllers) {
    QuantityValidator validator = QuantityValidator(totalQuantity: totalQuantity, controllers: controllers);
    return validator.validate();
  }

}


class QuantityValidator {
  final int totalQuantity;
  final List<TextEditingController> controllers;

  QuantityValidator({required this.totalQuantity, required this.controllers});

  String? validate() {
    if (controllers.isEmpty) {
      return "At least one field is required.";
    }

    int total = 0;
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return "All fields must be filled.";
      }
      int? value = int.tryParse(controller.text);
      if (value == null || value < 0) {
        return "All fields must contain a non-negative integer.";
      }
      total += value;
    }

    if (total > totalQuantity) {
      return "The total quantity must not exceed $totalQuantity.";
    }

    return null; // No errors
  }
}