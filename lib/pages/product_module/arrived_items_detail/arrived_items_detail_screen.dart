

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/extra_item_model.dart';
import 'package:denvin_stock/pages/product_module/choose_storage_view.dart';
import 'package:denvin_stock/pages/product_module/controller/arrived_items_detail_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ArrivedItemsDetailScreen extends GetView<ArrivedItemsDetailController>{
  ArrivedItemsDetailScreen({super.key}){
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(
              showBack: true,
              showLogo: false,
              title: "Arrived Item Detail",
              centerLogo: true,
              showOcrButton: Obx(() => controller.itemsPayload.isNotEmpty ? Row(
                children: [
                  Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? Colors.grey :  Colors.red),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(child: Text(controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? "Undo" : "Return",style: TextStyle(color: controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? Colors.grey :  Colors.red,fontWeight: FontWeight.w500),))).onTap(() {
                    ItemDTO itemPayload =  controller.itemsPayload.removeAt(controller.currentPageIndex.value);
                    if(itemPayload.status == "return"){
                      itemPayload.status = "confirm";
                    } else {
                      itemPayload.status = "return";
                    }
                    controller.itemsPayload.insert(controller.currentPageIndex.value, itemPayload);
                    controller.update();
                  }),
                ],
              ).marginSymmetric(horizontal: 20.0) : const SizedBox()),
          ),

          // body: GetBuilder<ArrivedItemsDetailController>(
          //   builder: (_) {
          //     return controller.isLoading == false
          //         ? Utils.circularLoader()
          //         : _mainBody();
          //   },
          // ),
          body: Obx(() => controller.isLoading.value ? Utils.circularLoader() : _mainBody())
      ),
    );
  }

  _mainBody() {
    return Column(
      children: [

        CustomTextFieldV3(
          hintText: Strings.searchProduct,
          focusNode: controller.searchFocusNode,
          controller: controller.searchController,
          onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
          onChanged: (value) {controller.searchingFilter(value);},
          prefix: IconButton(
            onPressed: () {controller.isFocus.value = true;},
            icon: imageAsset(search, height: 16.0),
          ),
          onTap: (){
            controller.searchingFilter('');
            controller.isFocus.value = true;},
          suffix: IconButton(icon: const Icon(CupertinoIcons.multiply),onPressed: (){
            controller.searchValue.value = "";
            controller.searchController.clear();
            controller.isFocus.value = false;
            controller.searchFocusNode.unfocus();
            },),
        ).marginOnly(right: 20.0, left: 20.0),

        Expanded(
          child: Visibility(
            visible: controller.searchValue.isEmpty && !controller.isFocus.value,
            replacement: _searchItem (),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: CarouselSlider(
                    carouselController: controller.sliderController,
                    options: CarouselOptions(
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      height: Get.height - 200,
                      autoPlay: false,
                      disableCenter: false,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        print('index ==> ${index}');
                        controller.currentPageIndex.value = index;
                      },
                    ),
                    items: [
                      ...List.generate(
                          controller.items.length,
                              (index) {
                            return Form(key: controller.formKeys[index], child: _pageBody());
                          }
                      ),
                    ],
                  ),
                ),

                // Expanded(
                //   child: PageView.builder(
                //     itemCount: controller.items.length,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemBuilder: (context, index){
                //         return Form(key: controller.formKeys[index], child: _pageBody());
                //       }),
                // ),

                vGap(10),
                Obx(
                      ()=> LinearPercentIndicator(
                    barRadius: const Radius.circular(10),
                    width: Get.width,
                    lineHeight: 20.0,
                    percent: controller.progressPercent.value,
                    center: Text(controller.progressValue.toString(),style: black_14_600()?.copyWith(color: Colors.white),),
                    progressColor: primaryColor,
                    backgroundColor: Colors.grey.withOpacity(0.8),
                  ),
                ),
                vGap(10),
                KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: isKeyboardVisible ? 0 : null,
                        child: isKeyboardVisible ? null :  Column(
                          children: [
                            if(controller.itemsPayload.length == controller.currentPageIndex.value + 1)
                              AppButton(onTap: () {
                              if(controller.formKeys[controller.currentPageIndex.value].currentState!.validate()) {
                                controller.submit();
                              }
                            },
                            buttonText: "Done",).marginSymmetric(horizontal: 20.0),
                            Obx(()=> Row(
                              children: [
                                Expanded(
                                  child: controller.currentPageIndex.value != 0 ? AppButton(onTap: (){
                                    controller.currentPageIndex.value--;
                                    controller.sliderController.previousPage();
                                   // controller.sliderController.animateToPage(controller.currentPageIndex.value--);
                                  }, textColor: primaryColor,backgroundColor: Colors.white,rippleColor: Colors.grey.withOpacity(0.2), borderColor: primaryColor,borderWidth: 1,
                                    buttonText: "Previous Product"): const SizedBox(),
                                ),
                                hGap(10),
                                Expanded(
                                  child: (controller.currentPageIndex.value + 1) != controller.itemsPayload.length ?
                                  AppButton(
                                      onTap: () {

                                      //  print('valll => ${controller.itemsPayload[controller.currentPageIndex.value].quantity}');


                                        print('totalPage => ${controller.itemsPayload.length}');
                                        print('currentPagePage => ${controller.currentPageIndex.value}');
                                        print('items length => ${controller.items.length}');
                                        print('formKeys length => ${controller.formKeys.length}');

                                        // if (controller.formKeys[controller.currentPageIndex.value].currentState?.validate() ?? false) {
                                        //   controller.sliderController.nextPage();
                                        // }
                                        //




                                        controller.sliderController.nextPage();

                                        // if(controller.formKeys[controller.currentPageIndex.value].currentState!.validate()){
                                        //  // controller.currentPageIndex.value++;
                                        //   controller.sliderController.nextPage();
                                        //
                                        //
                                        //     print('plus one => ${controller.currentPageIndex.value}');
                                        // }


                                       // controller.sliderController.nextPage();
                                       // controller.sliderController.animateToPage(controller.currentPageIndex.value++);

                                      }, textColor: primaryColor,backgroundColor: Colors.white,rippleColor: Colors.grey.withOpacity(0.2), borderColor: primaryColor,borderWidth: 1,
                                      buttonText: "Next Product") :
                                  AppButton(
                                      onTap: () async{
                                        if(controller.formKeys[controller.currentPageIndex.value].currentState!.validate()){
                                          var value = await addExtraDialog();
                                          print('Data ==> ${controller.selectedItem.toString()}');
                                        }
                                      },
                                      textColor: primaryColor,backgroundColor: Colors.white,rippleColor: Colors.grey.withOpacity(0.2), borderColor: primaryColor,borderWidth: 1,
                                      buttonText: "Add Extra Item"),
                                ),
                                /*Expanded(
                                  child: (controller.currentPageIndex.value + 1) != controller.itemsPayload.length ?
                                  AppButton(
                                      onTap: () {

                                        print('valll => ${controller.itemsPayload[controller.currentPageIndex.value].quantity}');

                                        if(controller.formKeys[controller.currentPageIndex.value].currentState!.validate()){
                                          controller.sliderController.nextPage();
                                        }
                                      }, textColor: primaryColor,backgroundColor: Colors.white,rippleColor: Colors.grey.withOpacity(0.2), borderColor: primaryColor,borderWidth: 1,
                                      buttonText: "Next Product") : const SizedBox(),
                                ),*/
                              ],
                            ).marginSymmetric(horizontal: 20.0),),
                            vGap(10.0)
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),

      ],
    );
  }


  _pageBody(){
    controller.calculateProgress(controller.itemsPayload.length, controller.currentPageIndex.value);
    return SingleChildScrollView(
      child: Column(
        children: [
          _returnBanner(),
          _enterProductName(),
          _moreInfo(),
          _storageQty(),
          _addQrAndBarCode(),
        ],
      ),
    );
  }


  _returnBanner(){
      return Obx(() => controller.itemsPayload[controller.currentPageIndex.value].status == "return" ?
      Container(
        width: Get.width,
        height: 24,
        color: Colors.redAccent,
        child: const Center(child: Text("Marked as returned item",style: TextStyle(color: Colors.white),)),
      ) : vGap(20));
  }

  _enterProductName() {
    return Container(
      height: 70.0,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      color: const Color(0xfff2f2f2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            Strings.product,
            style: black_14_600()?.copyWith(color: const Color(0xff707070)),
          ),
          vGap(4.0),
          TextView(controller.items[controller.currentPageIndex.value].productName ?? Strings.nA, style: black_14_600()?.copyWith(color: black, fontSize: 15)),
        ],
      ),
    );
  }

  _moreInfo(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.unitPrice,
                      style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView("£${controller.items[controller.currentPageIndex.value].price}",
                        style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
            Container(
              height: 60.0,
              width: 1,
              color: const Color(0xffe3e3e3),
            ),
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.supplierCode,
                      style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(controller.items[controller.currentPageIndex.value].supplierCode.toString(), style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            )
          ],
        ),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.orderQty,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView("${controller.items[controller.currentPageIndex.value].quanitity}",
                        style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
            Container(
              height: 60.0,
              width: 1,
              color: const Color(0xffe3e3e3),
            ),
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.receivedQty,
                      style: black_14_600()?.copyWith(color: const Color(0xff707070)),
                    ).paddingSymmetric(horizontal: 16.0),
                    vGap(2.0),
                    _counterBar(),
                    // TextView(controller.items[controller.currentPageIndex.value].supplierCode.toString(), style: black_14_600()?.copyWith(color: black, fontSize: 15)),
                  ],
                ).paddingSymmetric(horizontal: 14),
              ),
            )
          ],
        ),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
      ],
    );
  }

  _storageQty(){
    return GetBuilder<ArrivedItemsDetailController>(
      builder: (controller) {
        return  Column(
          children: [
            vGap(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextView(
                      "Add Storage",
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
                controller.addNewExpAndQuantity();
              }),
            ).marginSymmetric(horizontal: 20),
            vGap(10.0),
            ...List.generate(controller.dynamicQuantityDateController[controller.currentPageIndex.value].value?.length ?? 0, (index) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                            readOnly: true,
                            hintText: Strings.selectStorage,
                         // validator: (value) => controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? null : value?.isEmptyField(messageTitle: Strings.storage),
                            validator: (value) {
                              controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? null : value?.isEmptyField(messageTitle: Strings.storage);
                              if(controller.itemsPayload[controller.currentPageIndex.value].quantity != 0){
                                if(controller.itemsPayload[controller.currentPageIndex.value].status != "return"){
                                  return value?.isEmptyField(messageTitle: Strings.storage);
                                }
                              }
                              return null;
                            },
                            onTap: (){
                              Supplier supplier = Supplier(
                                id: controller.itemsPayload[controller.currentPageIndex.value].storages![index].sId,
                              );
                              chooseStorageDialog(selectedItem: supplier,disabledList: controller.itemsPayload[controller.currentPageIndex.value].storages?.map((e) => e.sId ?? 0).toList()).then((value) {
                                Storages tempStorage = controller.itemsPayload[controller.currentPageIndex.value].storages?.removeAt(index) ?? Storages();
                                controller.itemsPayload[controller.currentPageIndex.value].storages?.insert(index, Storages(
                                  sId: value?.id,
                                  qty: tempStorage.qty,
                                  expiredAt: tempStorage.expiredAt,
                                ));
                                controller.storageController[controller.currentPageIndex.value].value![index].text = value?.name ?? "";
                              });
                            },
                            inputFormatters: [DateFormatter()],
                            controller: controller.storageController[controller.currentPageIndex.value].value![index],
                            textInputType: TextInputType.datetime,
                            suffix: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: greyIconColor,
                            ),
                            focusNode: controller.storageDateFocusNode[controller.currentPageIndex.value].value![index],
                            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()
                        ),
                      ),
                      hGap(10.0),
                      Expanded(
                        child: CustomTextField(
                            hintText: Strings.quantity,
                            controller: controller.dynamicQuantityDateController[controller.currentPageIndex.value].value![index],
                            textInputType: TextInputType.number,
                            onTap: (){
                              controller.update();
                              try{
                                FocusScope.of(Get.context!).requestFocus(controller.dynamicQuantityDateFocusNode[controller.currentPageIndex.value].value![index]);
                              } catch (e){
                                FocusScope.of(Get.context!).requestFocus(controller.dynamicQuantityDateFocusNode[controller.currentPageIndex.value].value![index]);
                              }
                            },
                            onChanged: (qtyValue){
                              Storages tempStorage = controller.itemsPayload[controller.currentPageIndex.value].storages?.removeAt(index) ?? Storages();
                              controller.itemsPayload[controller.currentPageIndex.value].storages?.insert(index, Storages(
                                sId: tempStorage.sId,
                                qty: int.tryParse(qtyValue) ?? 0,
                                expiredAt: tempStorage.expiredAt,
                              ));
                              print(controller.itemsPayload);
                            },
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            // validator: (value)=> controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? null : _validateForm(value, controller.itemsPayload[controller.currentPageIndex.value].quantity ?? 0, controller.dynamicQuantityDateController[controller.currentPageIndex.value].value!),
                            validator: (value) {
                              controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? null : value?.isEmptyField(messageTitle: Strings.storage);
                              if(controller.itemsPayload[controller.currentPageIndex.value].quantity != 0){
                                if(controller.itemsPayload[controller.currentPageIndex.value].status != "return"){
                                  return _validateForm(value, controller.itemsPayload[controller.currentPageIndex.value].quantity ?? 0, controller.dynamicQuantityDateController[controller.currentPageIndex.value].value!);
                                }
                              }
                              return null;
                            },
                            focusNode: controller.dynamicQuantityDateFocusNode[controller.currentPageIndex.value].value![index],
                            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()),
                      ),
                      if (index != 0)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                                controller.deleteExpAndQuantity(index);
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
                  ).marginOnly(bottom: 10,right: 20.0,left: 20.0),
                  CustomTextField(
                      //readOnly: true,
                      maxLength: 10,
                      hintText: "Expiry Date",
                      // onTap: (){
                      //   controller.getExpiryDate(index);
                      // },
                      onChanged: (date){

                      },
                    inputFormatters: [DateFormatter()],
                      controller: controller.expiryDateController[controller.currentPageIndex.value].value![index],
                      textInputType: TextInputType.datetime,
                      validator: (value) {
                        /*if (controller.isDuplicateDate(index)){
                          return 'Please enter different dates';
                        }
                        return null;*/
                        if(value!.isNotEmpty){
                          if (controller.isDateBeforeToday(value)) {
                            return 'Please enter future date';
                          } else if (controller.isDuplicateDate(index)){
                            return 'Please enter different dates';
                          }
                        }

                        return null;
                      },
                      suffix: Icon(
                        Icons.calendar_month,
                        color: greyIconColor,
                      ).onTap(() {
                        controller.getExpiryDate(index);
                      }),
                      focusNode: controller.expiryDateFocusNode[controller.currentPageIndex.value].value![index],
                      // onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()
                  ).marginOnly(right: 20.0,left: 20.0),
                  if(index + 1 != controller.dynamicQuantityDateController[controller.currentPageIndex.value].value?.length) Column(
                    children: [
                      vGap(10.0),
                      Container(height: 1,width: Get.width,color: textFieldBorderColor,),
                      vGap(10.0),
                    ],
                  )
                ],
              );
            }),
            vGap(20.0),
          ],
        );
      },
    );
  }

  String? _validateForm(String? value, int totalQuantity, List<TextEditingController> controllers) {
    QuantityValidator validator = QuantityValidator(totalQuantity: totalQuantity, controllers: controllers);
    return validator.validate();
  }

  _addQrAndBarCode() {
    return Obx(
          () => Column(
        children: [
          Container(
            height: 1.0,
            width: Get.width,
            color: const Color(0xffe3e3e3),
          ),
          vGap(20.0),
          Row(
            children: [
              TextView(
                Strings.qrBarCode,
                style: black_15_700()?.copyWith(color: greyIconColor),
              ),
              const Spacer(),
              if(controller.itemsPayload[controller.currentPageIndex.value].barcodes?.isNotEmpty ?? false) Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(6.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextView(
                        "Add More Barcode",
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
                  controller.getBarCode();
                }),
              )
            ],
          ).marginSymmetric(horizontal: 20.0),

          if (controller.itemsPayload.isNotEmpty) ...List.generate([...controller.itemsPayload[controller.currentPageIndex.value].barcodes ?? [],].length, (index) {
            return Row(
              children: [
                IconButton(onPressed: () {}, icon: imageAsset(barIcon, color: black, height: 20)),
                hGap(10.0),
                Expanded(
                  child: TextView(
                    controller.itemsPayload[controller.currentPageIndex.value].barcodes?[index].barcode ?? "",
                    style: black_14_600()?.copyWith(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                hGap(10.0),
                IconButton(
                    onPressed: () {
                      ItemDTO tempItem  = controller.itemsPayload.removeAt(controller.currentPageIndex.value);
                      List<BarcodeDTO> newBars = tempItem.barcodes ?? [];
                      newBars.removeAt(index);
                      tempItem.barcodes = newBars;
                      controller.itemsPayload.insert(controller.currentPageIndex.value, tempItem);
                      controller.update();
                    },
                    icon: const Icon(Icons.close)),
              ],
            ).marginOnly(left: 20.0,right: 20.0,top: 0.0);
          }),

          _getAddBarcodeButton()
        ],
      ),
    );
  }

  _counterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: primaryColor,
          onTap: (){
            controller.minusCount();
          },
          child: TextView("-", style: black_20_700()?.copyWith(fontSize: 14)).paddingSymmetric(horizontal: 22.0),
        ),
        hGap(6),
        Obx(()=> TextView((controller.itemsPayload[controller.currentPageIndex.value].quantity ?? 0).toString(), style: black_14_600()?.copyWith(color: black, fontSize: 15))),
        hGap(6),
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: primaryColor,
          onTap:(){
            controller.addCount();
          },
          child: TextView("+", style: black_20_700()?.copyWith(fontSize: 14)).paddingSymmetric(horizontal: 22.0),
        ),
      ],
    );
  }

  _getAddBarcodeButton(){
    if(controller.itemsPayload.isNotEmpty){
      if(controller.currentPageIndex.value >= 0 && controller.currentPageIndex.value < controller.itemsPayload.length){
        if(controller.itemsPayload[controller.currentPageIndex.value].barcodes?.isEmpty ?? true){
          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    controller.getBarCode();
                  },
                  icon: imageAsset(scanIcon, color: hintTextColor, height: 20)),
              const Spacer(),
              TextView(
                Strings.addQrBarcode,
                style: black_14_600()?.copyWith(color: hintTextColor),
              ).onTap(() {
                controller.getBarCode();
              }),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    controller.getBarCode();
                  },
                  icon: Icon(Icons.add,color: hintTextColor,)),
            ],
          ).marginSymmetric(horizontal: 20.0);
        }
      }
    }
    return SizedBox();
  }


  Widget _searchItem () {
    return Visibility(
      visible: controller.searchItems.isNotEmpty,
      replacement: const Center(child: Text('No Item Found'),),
      child: ListView.separated(
        itemCount: controller.searchItems.length,
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, i) => const Divider(),
        itemBuilder: (context, index){
          return ListTile(
            onTap: (){
              ItemDTO temp = controller.itemsPayload[index];

              //
              // controller.itemsPayload[index] = temp;
              // controller.currentPageIndex.value = index;

              for (int i = 0; i < controller.itemsPayload.length; i++) {
                if (controller.itemsPayload[i].id == controller.searchItems[index].id) {
                  temp = controller.itemsPayload[i];
                  controller.currentPageIndex.value = i;
                  controller.itemsPayload[index] = controller.itemsPayload[i];
                }
              }




              controller.searchValue.value = "";
              controller.isFocus.value = false;
              controller.searchFocusNode.unfocus();

              // ItemDTO temp = controller.itemsPayload[0];
              // controller.itemsPayload[0] = controller.itemsPayload[index];
              // controller.itemsPayload[index] = temp;
              // controller.currentPageIndex.value = 0;
              //
              //
              // controller.searchValue.value = "";
              // controller.isFocus.value = false;
              // controller.searchFocusNode.unfocus();
            },
            title: Text(controller.searchItems[index].productName??""),
            subtitle: Text("${Strings.supplierCode}: ${controller.searchItems[index].supplierCode??""}"),
          );
        },
      ),
    );
  }




  Future<dynamic> addExtraDialog() {
    return Get.dialog(
      Container(
        alignment: Alignment.center,
        child: GetBuilder<ArrivedItemsDetailController>(
            builder: (controllerArrivedItemsDetailController) {
            return StatefulBuilder(
                builder: (context, setState) {
                return Container(
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
                              "Add Extra Item",
                              style: black_17_700()?.copyWith(color: primaryColor),
                            ).marginSymmetric(vertical: margin_15, horizontal: margin_15),
                            const Spacer(),
                            IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close))
                          ],
                        ).marginSymmetric(horizontal: 10.0),
                        Expanded(
                            child: Column(
                              children: [
                                TextView("Have you received any extra items that you had not ordered? Add such products.",style: const TextStyle(color: Colors.grey),maxLine: 3,).paddingSymmetric(horizontal: 20.0),

                                CustomTextFieldV3(
                                  hintText: "Name/Product Code/Manufacture",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  onFieldSubmitted: (String? value) =>
                                      FocusScope.of(Get.context!).unfocus(),
                                  onChanged: (value) {
                                    if(value.isNotEmpty){
                                      controllerArrivedItemsDetailController.getExtraItems(value);
                                    }
                                  },
                                  suffix: IconButton(
                                    onPressed: () {},
                                    icon: imageAsset(search, height: 16.0),
                                  ),
                                ).marginSymmetric(horizontal: margin_20, vertical: margin_10),

                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: margin_0),
                                      itemCount: controllerArrivedItemsDetailController.extraItems.value?.data?.length??0,
                                      itemBuilder: (context, index) {
                                        final data = controllerArrivedItemsDetailController.extraItems.value?.data?[index];
                                        return ListTile(
                                          onTap: ()async{

                                            Get.back();
                                          var value = await  extraProduct(
                                              id: data?.externalProductId??0,
                                              supplierCode: data?.supplierCode??"",
                                              supplierName: data?.name??"",);

                                         // Get.back(result: value);
                                          print('Data 2 ==> ${value.toString()}');


                                          },
                                          title: Text(data?.name??""),
                                          trailing: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(6)
                                              ),
                                              child: Text("Add", style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500),)),
                                        );
                                      }),
                                ),
                              ],
                            )),
                      ],
                    ));
              }
            );
          }
        ),
      ),
    );
  }


  Future<dynamic> extraProduct({required String supplierCode, required String supplierName, required int id}) {
    TextEditingController supplierCodeController = TextEditingController(text: supplierCode);
    TextEditingController supplierNameController = TextEditingController(text: supplierName);
    TextEditingController unitPriceController = TextEditingController();
    TextEditingController orderedQuantityController = TextEditingController();
    return Get.dialog(
      Container(
        alignment: Alignment.center,
        child: GetBuilder<ArrivedItemsDetailController>(
            builder: (controllerArrivedItemsDetailController) {
              return StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                        height: Get.height * 0.6,
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
                                  "Extra Products",
                                  style: black_17_700()?.copyWith(color: primaryColor),
                                ).marginSymmetric(vertical: margin_15, horizontal: margin_15),
                                const Spacer(),
                                IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close))
                              ],
                            ).marginSymmetric(horizontal: 10.0),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView("Supplier Code",style: const TextStyle(color: Colors.grey),maxLine: 3,).paddingSymmetric(horizontal: 20.0),
                                CustomTextFieldV3(
                                  controller: supplierCodeController,
                                  hintText: "EnterSupplier Code",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  onFieldSubmitted: (String? value) =>
                                      FocusScope.of(Get.context!).unfocus(),
                                ).marginSymmetric(horizontal: margin_20, vertical: margin_10),

                                TextView("Supplier Name",style: const TextStyle(color: Colors.grey),maxLine: 3,).paddingSymmetric(horizontal: 20.0),
                                CustomTextFieldV3(
                                  controller: supplierNameController,
                                  hintText: "Enter Supplier Name",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  onFieldSubmitted: (String? value) =>
                                      FocusScope.of(Get.context!).unfocus(),
                                ).marginSymmetric(horizontal: margin_20, vertical: margin_10),

                                TextView("Unit Price",style: const TextStyle(color: Colors.grey),maxLine: 3,).paddingSymmetric(horizontal: 20.0),

                                CustomTextFieldV3(
                                  controller: unitPriceController,
                                  hintText: "Enter Unit Price",
                                  textInputType: TextInputType.number,
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  onFieldSubmitted: (String? value) =>
                                      FocusScope.of(Get.context!).unfocus(),
                                ).marginSymmetric(horizontal: margin_20, vertical: margin_10),


                                TextView("Ordered Quantity",style: const TextStyle(color: Colors.grey),maxLine: 3,).paddingSymmetric(horizontal: 20.0),

                                CustomTextFieldV3(
                                  controller: orderedQuantityController,
                                  hintText: "Enter Ordered Quantity",
                                  textInputType: TextInputType.number,
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  onFieldSubmitted: (String? value) =>
                                      FocusScope.of(Get.context!).unfocus(),
                                ).marginSymmetric(horizontal: margin_20, vertical: margin_10),


                                const SizedBox(height: margin_20,),

                                AppButton(
                                    buttonText: "Add",
                                    isLoading: controller.isLoading.value,
                                    buttonColor: primaryColor,
                                    onTap: () {
                                      Map<String, dynamic> data = {
                                        "id": id,
                                        "name": supplierNameController.text,
                                        "supplierCode": supplierCodeController.text,
                                        "unitPrice":double.parse(unitPriceController.text),
                                        "orderedQuantity": int.parse(orderedQuantityController.text),
                                        "quantity": int.parse(orderedQuantityController.text),
                                      };
                                      controller.selectedItem = data;
                                      controller.update();
                                      print('controller.selectedItem.value=> ${controller.selectedItem}');

                                      controller.isLoading.value = true;
                                      Future.delayed(const Duration(seconds: 1), () async {
                                       // controller.extraItems.value!.data = [];
                                        controller.addItem(
                                          isNew: true,
                                          id: controller.selectedItem['id'],
                                          name:  controller.selectedItem['name'],
                                          supplierCode:  controller.selectedItem['supplierCode'],
                                          unitPrice:  controller.selectedItem['unitPrice'],
                                          orderedQuantity:  controller.selectedItem['orderedQuantity'],
                                          quantity:  controller.selectedItem['quantity'],);
                                      });


                                      // controller.isLoading.value = true;
                                      // Future.delayed(const Duration(seconds: 1), () async {
                                      //   controller.extraItems.value!.data = [];
                                      //   controller.addItem(
                                      //       isNew: true,
                                      //       id: id,
                                      //       name: supplierNameController.text,
                                      //       supplierCode: supplierCodeController.text,
                                      //       unitPrice: double.parse(unitPriceController.text),
                                      //       orderedQuantity: int.parse(orderedQuantityController.text),
                                      //       quantity: int.parse(orderedQuantityController.text),);
                                      // });

                                    }).marginSymmetric(horizontal: margin_20)
                              ],
                            ),
                          ],
                        ));
                  }
              );
            }
        ),
      ),
    );
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

    if (total > totalQuantity || total < totalQuantity) {
      return "Storing Quantity should be equal to the total Received Qty";
    }

    return null; // No errors
  }
}



