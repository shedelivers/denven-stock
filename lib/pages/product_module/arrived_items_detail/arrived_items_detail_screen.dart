import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/extra_item_model.dart';
import 'package:denvin_stock/pages/product_module/choose_storage_view.dart';
import 'package:denvin_stock/pages/product_module/controller/arrived_items_detail_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../components/utils/print_value.dart';

class ArrivedItemsDetailScreen extends GetView<ArrivedItemsDetailController> {
  ArrivedItemsDetailScreen({super.key}) {
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
            showOcrButton: Obx(() => controller.itemsPayload.isNotEmpty
                ? Row(
                    children: [
                      /* Container(
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
                  }),*/

                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(controller
                                        .itemsPayload[
                                            controller.currentPageIndex.value]
                                        .status ==
                                    "return"
                                ? "Undo"
                                : "Return"),
                            onTap: () {
                              ItemDTO itemPayload = controller.itemsPayload
                                  .removeAt(controller.currentPageIndex.value);
                              if (itemPayload.status == "return") {
                                itemPayload.status = "confirm";
                              } else {
                                itemPayload.status = "return";
                              }
                              controller.itemsPayload.insert(
                                  controller.currentPageIndex.value,
                                  itemPayload);
                              controller.lastIndexIsValid();
                              controller.update();
                            },
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: const Text("Save Draft"),
                            onTap: () {
                              controller.addToDraft();
                            },
                          ),
                        ],
                        offset: const Offset(0, 50),
                        color: whiteColor,
                        elevation: 2,
                      ),
                    ],
                  ).marginSymmetric(horizontal: 20.0)
                : const SizedBox()),
          ),
          body: Obx(() => controller.isLoading.value
              ? Utils.circularLoader()
              : _mainBody())),
    );
  }

  _mainBody() {
    return Column(
      children: [
        CustomTextFieldV3(
          hintText: Strings.searchProduct,
          focusNode: controller.searchFocusNode,
          controller: controller.searchController,
          onFieldSubmitted: (String? value) =>
              FocusScope.of(Get.context!).unfocus(),
          onChanged: (value) {
            controller.searchingFilter(value);
          },
          prefix: IconButton(
            onPressed: () {
              controller.isFocus.value = true;
            },
            icon: imageAsset(search, height: 16.0),
          ),
          onTap: () {
            controller.searchingFilter('');
            controller.isFocus.value = true;
          },
          suffix: IconButton(
            icon: const Icon(CupertinoIcons.multiply),
            onPressed: () {
              controller.searchValue.value = "";
              controller.isFocus.value = false;
              controller.searchFocusNode.unfocus();
              Future.delayed(const Duration(milliseconds: 200), () {
                controller.pageController
                    .jumpToPage(controller.currentPageIndex.value);
              });
            },
          ),
        ).marginOnly(right: 20.0, left: 20.0),
        Expanded(
          child: Visibility(
            visible:
                controller.searchValue.isEmpty && !controller.isFocus.value,
            replacement: _searchItem(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Expanded(
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
                ),*/

                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    onPageChanged: (int index) {
                      controller.currentPageIndex.value = index;
                      controller.calculateProgress(
                          controller.itemsPayload.length, index);
                      controller.lastIndexIsValid();
                      controller.pageController.notifyListeners();
                    },
                    children: [
                      ...List.generate(
                          //controller.items.length,
                          controller.itemsPayload.length, (index) {
                        return Form(
                            key: controller.formKeys[index],
                            child: _pageBody());
                      }),
                    ],
                  ),
                ),
                vGap(10),
                LinearPercentIndicator(
                    barRadius: const Radius.circular(10),
                    width: Get.width,
                    lineHeight: 20.0,
                    percent: controller.progressPercent.value,
                    center: Text(
                      controller.progressValue.toString(),
                      style: black_14_600()?.copyWith(color: Colors.white),
                    ),
                    progressColor: primaryColor,
                    backgroundColor: Colors.grey.withOpacity(0.8),
                  ),
                vGap(10),
                KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isKeyboardVisible ? 0 : null,
                    child: isKeyboardVisible
                        ? null
                        : Column(
                              children: [
                                if (controller.itemsPayload.length ==
                                        controller.currentPageIndex.value + 1 &&
                                    controller.isLastIndexIsValid)
                                  Visibility(
                                      visible: controller.isLastIndexIsValid,
                                      child: AppButton(
                                        onTap: () {
                                          if (controller
                                              .formKeys[controller
                                                  .currentPageIndex.value]
                                              .currentState!
                                              .validate()) {
                                            controller.submit();
                                          }
                                        },
                                        buttonText: "Done",
                                      ).marginSymmetric(horizontal: 20.0),
                                    ),

                                Row(
                                    children: [
                                      Expanded(
                                        child: controller.currentPageIndex.value != 0
                                            ? AppButton(
                                                onTap: () {controller.pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);},
                                                textColor: primaryColor,
                                                backgroundColor: Colors.white,
                                                rippleColor:
                                                    Colors.grey.withOpacity(0.2),
                                                borderColor: primaryColor,
                                                borderWidth: 1,
                                                buttonText: "Previous Product")
                                            : const SizedBox(),
                                      ),
                                      hGap(10),
                                      Expanded(
                                        child: (controller.currentPageIndex.value + 1) != controller.itemsPayload.length
                                            ? AppButton(
                                                onTap: () {
                                                  if (controller.formKeys[controller.currentPageIndex.value].currentState!.validate()) {
                                                    controller.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                                  }
                                                },
                                                textColor: primaryColor,
                                                backgroundColor: Colors.white,
                                                rippleColor: Colors.grey.withOpacity(0.2),
                                                borderColor: primaryColor,
                                                borderWidth: 1,
                                                buttonText: "Next Product")
                                            : Visibility(
                                          visible: controller.isLastIndexIsValid,
                                              child: AppButton(
                                                  onTap: () async {
                                                    if (controller
                                                        .formKeys[controller
                                                            .currentPageIndex.value]
                                                        .currentState!
                                                        .validate()) {
                                                      addExtraDialog();
                                                    }
                                                  },
                                                  textColor: primaryColor,
                                                  backgroundColor: Colors.white,
                                                  rippleColor:
                                                      Colors.grey.withOpacity(0.2),
                                                  borderColor: primaryColor,
                                                  borderWidth: 1,
                                                  buttonText: "Add Extra Item"),
                                            ),
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
                                  ).marginSymmetric(horizontal: 20.0),
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

  _pageBody() {
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

  _returnBanner() {
    return Obx(() =>
        controller.itemsPayload[controller.currentPageIndex.value].status ==
                "return"
            ? Container(
                width: Get.width,
                height: 24,
                color: Colors.redAccent,
                child: const Center(
                    child: Text(
                  "Marked as returned item",
                  style: TextStyle(color: Colors.white),
                )),
              )
            : vGap(20));
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
          TextView(
              controller.itemsPayload[controller.currentPageIndex.value].name ??
                  Strings.nA,
              style: black_14_600()?.copyWith(color: black, fontSize: 15)),
        ],
      ),
    );
  }

  _moreInfo() {
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
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        "£${controller.itemsPayload[controller.currentPageIndex.value].unitPrice}",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
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
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    vGap(4.0),
                    TextView(
                        controller
                            .itemsPayload[controller.currentPageIndex.value]
                            .supplierCode
                            .toString(),
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
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
                    TextView(
                        "${controller.itemsPayload[controller.currentPageIndex.value].orderedQuantity}",
                        style: black_14_600()
                            ?.copyWith(color: black, fontSize: 15)),
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
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
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

  _storageQty() {
    return GetBuilder<ArrivedItemsDetailController>(
      builder: (storageController) {
        return Column(
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
                storageController.addNewExpAndQuantity();
                controller.lastIndexIsValid();
              }),
            ).marginSymmetric(horizontal: 20),
            vGap(10.0),
            ...List.generate(
                storageController
                        .dynamicQuantityDateController[
                            storageController.currentPageIndex.value]
                        .value
                        ?.length ??
                    0, (index) {
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
                              storageController
                                          .itemsPayload[storageController
                                              .currentPageIndex.value]
                                          .status ==
                                      "return"
                                  ? null
                                  : value?.isEmptyField(
                                      messageTitle: Strings.storage);
                              if (storageController
                                      .itemsPayload[storageController
                                          .currentPageIndex.value]
                                      .quantity !=
                                  0) {
                                if (storageController
                                        .itemsPayload[storageController
                                            .currentPageIndex.value]
                                        .status !=
                                    "return") {
                                  return value?.isEmptyField(
                                      messageTitle: Strings.storage);
                                }
                              }
                              return null;
                            },
                            onTap: () async {
                              Supplier supplier = Supplier(
                                id: storageController
                                        .itemsPayload[storageController
                                            .currentPageIndex.value]
                                        .storages?[index]
                                        .sId ??
                                    0,
                                name: storageController
                                        .itemsPayload[storageController
                                            .currentPageIndex.value]
                                        .storages?[index]
                                        .name ??
                                    "",
                              );

                              await chooseStorageDialog(
                                      selectedItem: supplier,
                                      disabledList: storageController
                                          .itemsPayload[storageController
                                              .currentPageIndex.value]
                                          .storages
                                          ?.map((e) => e.sId ?? 0)
                                          .toList())
                                  .then((value) {
                                if (value != null) {
                                  Storages tempStorage = storageController
                                          .itemsPayload[storageController
                                              .currentPageIndex.value]
                                          .storages
                                          ?.removeAt(index) ??
                                      Storages();
                                  storageController
                                      .itemsPayload[storageController
                                          .currentPageIndex.value]
                                      .storages
                                      ?.insert(
                                          index,
                                          Storages(
                                              sId: value.id,
                                              qty: tempStorage.qty,
                                              expiredAt: tempStorage.expiredAt,
                                              name: value.name));

                                  storageController
                                      .storageController[storageController
                                          .currentPageIndex.value]
                                      .value?[index]
                                      .text = storageController
                                          .itemsPayload[storageController
                                              .currentPageIndex.value]
                                          .storages?[index]
                                          .name ??
                                      "";
                                  controller.lastIndexIsValid();
                                }
                              });
                            },
                            inputFormatters: [DateFormatter()],
                            controller: storageController
                                .storageController[
                                    storageController.currentPageIndex.value]
                                .value![index],
                            textInputType: TextInputType.datetime,
                            suffix: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: greyIconColor,
                            ),
                            focusNode: storageController
                                .storageDateFocusNode[
                                    storageController.currentPageIndex.value]
                                .value![index],
                            onFieldSubmitted: (String? value) =>
                                FocusScope.of(Get.context!).unfocus()),
                      ),
                      hGap(10.0),
                      Expanded(
                        child: CustomTextField(
                            hintText: Strings.quantity,
                            controller: storageController
                                .dynamicQuantityDateController[
                                    storageController.currentPageIndex.value]
                                .value![index],
                            textInputType: TextInputType.number,
                            onTap: () {
                              storageController.update();
                              try {
                                FocusScope.of(Get.context!).requestFocus(
                                    storageController
                                        .dynamicQuantityDateFocusNode[
                                            storageController
                                                .currentPageIndex.value]
                                        .value![index]);
                              } catch (e) {
                                FocusScope.of(Get.context!).requestFocus(
                                    storageController
                                        .dynamicQuantityDateFocusNode[
                                            storageController
                                                .currentPageIndex.value]
                                        .value![index]);
                              }
                            },
                            onChanged: (qtyValue) {
                              Storages tempStorage = storageController
                                      .itemsPayload[storageController
                                          .currentPageIndex.value]
                                      .storages
                                      ?.removeAt(index) ??
                                  Storages();
                              storageController
                                  .itemsPayload[
                                      storageController.currentPageIndex.value]
                                  .storages
                                  ?.insert(
                                      index,
                                      Storages(
                                        sId: tempStorage.sId,
                                        name: tempStorage.name,
                                        qty: int.tryParse(qtyValue) ?? 0,
                                        expiredAt: tempStorage.expiredAt,
                                      ));
                              controller.lastIndexIsValid();
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // validator: (value)=> controller.itemsPayload[controller.currentPageIndex.value].status == "return" ? null : _validateForm(value, controller.itemsPayload[controller.currentPageIndex.value].quantity ?? 0, controller.dynamicQuantityDateController[controller.currentPageIndex.value].value!),
                            validator: (value) {
                              storageController
                                          .itemsPayload[storageController
                                              .currentPageIndex.value]
                                          .status ==
                                      "return"
                                  ? null
                                  : value?.isEmptyField(
                                      messageTitle: Strings.storage);
                              if (storageController
                                      .itemsPayload[storageController
                                          .currentPageIndex.value]
                                      .quantity !=
                                  0) {
                                if (storageController
                                        .itemsPayload[storageController
                                            .currentPageIndex.value]
                                        .status !=
                                    "return") {
                                  if (value == "0") {
                                    return "Storing Quantity can't be zero.";
                                  }
                                  return _validateForm(
                                      value,
                                      storageController
                                              .itemsPayload[storageController
                                                  .currentPageIndex.value]
                                              .quantity ??
                                          0,
                                      storageController
                                          .dynamicQuantityDateController[
                                              storageController
                                                  .currentPageIndex.value]
                                          .value!);
                                }
                              }
                              return null;
                            },
                            focusNode: storageController
                                .dynamicQuantityDateFocusNode[
                                    storageController.currentPageIndex.value]
                                .value![index],
                            onFieldSubmitted: (String? value) =>
                                FocusScope.of(Get.context!).unfocus()),
                      ),
                      if (index != 0)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              storageController.deleteExpAndQuantity(index);
                              controller.lastIndexIsValid();
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
                  ).marginOnly(bottom: 10, right: 20.0, left: 20.0),
                  CustomTextField(
                    //readOnly: true,
                    maxLength: 10,
                    hintText: "Expiry Date",
                    // onTap: (){
                    //   controller.getExpiryDate(index);
                    // },
                    onChanged: (date) {
                      controller.lastIndexIsValid();
                    },
                    inputFormatters: [DateFormatter()],
                    textInputType: TextInputType.number,
                    controller: storageController
                        .expiryDateController[
                            storageController.currentPageIndex.value]
                        .value![index],
                    validator: (value) {
                      /*if (controller.isDuplicateDate(index)){
                          return 'Please enter different dates';
                        }
                        return null;*/
                      if (value!.isNotEmpty) {
                        if (storageController.isDateBeforeToday(value)) {
                          return 'Please enter future date';
                        } else if (storageController.isDuplicateDate(index)) {
                          return 'Please enter different dates';
                        }
                      }

                      return null;
                    },
                    suffix: Icon(
                      Icons.calendar_month,
                      color: greyIconColor,
                    ).onTap(() {
                      storageController.getExpiryDate(index);
                    }),
                    focusNode: storageController
                        .expiryDateFocusNode[
                            storageController.currentPageIndex.value]
                        .value![index],
                    // onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()
                  ).marginOnly(right: 20.0, left: 20.0),
                  if (index + 1 !=
                      storageController
                          .dynamicQuantityDateController[
                              storageController.currentPageIndex.value]
                          .value
                          ?.length)
                    Column(
                      children: [
                        vGap(10.0),
                        Container(
                          height: 1,
                          width: Get.width,
                          color: textFieldBorderColor,
                        ),
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

  String? _validateForm(String? value, int totalQuantity,
      List<TextEditingController> controllers) {
    QuantityValidator validator = QuantityValidator(
        totalQuantity: totalQuantity, controllers: controllers);
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
              if (controller.itemsPayload[controller.currentPageIndex.value]
                      .barcodes?.isNotEmpty ??
                  false)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(6.0)),
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
          if (controller.itemsPayload.isNotEmpty)
            ...List.generate(
                [
                  ...controller.itemsPayload[controller.currentPageIndex.value]
                          .barcodes ??
                      [],
                ].length, (index) {
              return Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: imageAsset(barIcon, color: black, height: 20)),
                  hGap(10.0),
                  Expanded(
                    child: TextView(
                      controller.itemsPayload[controller.currentPageIndex.value]
                              .barcodes?[index].barcode ??
                          "",
                      style: black_14_600()?.copyWith(color: black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  hGap(10.0),
                  IconButton(
                      onPressed: () {
                        ItemDTO tempItem = controller.itemsPayload
                            .removeAt(controller.currentPageIndex.value);
                        List<BarcodeDTO> newBars = tempItem.barcodes ?? [];
                        newBars.removeAt(index);
                        tempItem.barcodes = newBars;
                        controller.itemsPayload.insert(
                            controller.currentPageIndex.value, tempItem);
                        controller.update();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ).marginOnly(left: 20.0, right: 20.0, top: 0.0);
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
          onTap: () {
            controller.minusCount();
            controller.lastIndexIsValid();
          },
          child: TextView("-", style: black_20_700()?.copyWith(fontSize: 14))
              .paddingSymmetric(horizontal: 22.0),
        ),
        hGap(6),
        Obx(() => TextView(
            (controller.itemsPayload[controller.currentPageIndex.value]
                        .quantity ??
                    0)
                .toString(),
            style: black_14_600()?.copyWith(color: black, fontSize: 15))),
        hGap(6),
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: primaryColor,
          onTap: () {
            controller.addCount();
            controller.lastIndexIsValid();
          },
          child: TextView("+", style: black_20_700()?.copyWith(fontSize: 14))
              .paddingSymmetric(horizontal: 22.0),
        ),
      ],
    );
  }

  _getAddBarcodeButton() {
    if (controller.itemsPayload.isNotEmpty) {
      if (controller.currentPageIndex.value >= 0 &&
          controller.currentPageIndex.value < controller.itemsPayload.length) {
        if (controller.itemsPayload[controller.currentPageIndex.value].barcodes
                ?.isEmpty ??
            true) {
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
                  icon: Icon(
                    Icons.add,
                    color: hintTextColor,
                  )),
            ],
          ).marginSymmetric(horizontal: 20.0);
        }
      }
    }
    return const SizedBox();
  }

  Widget _searchItem() {
    return Visibility(
      visible: controller.searchItems.isNotEmpty,
      replacement: const Center(
        child: Text('No Item Found'),
      ),
      child: ListView.separated(
        itemCount: controller.searchItems.length,
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, i) => const Divider(),
        itemBuilder: (context, searchItemsIndex) {
          return ListTile(
            onTap: () {
              ItemDTO itemDTO = controller.searchItems[searchItemsIndex];

              List<ItemDTO> allCompleteItems = [];
              List<ItemDTO> allInCompleteItems = [];

              for (var element in controller.itemsPayload) {
                int sumOfQuantity = element.storages
                        ?.map((e) => e.qty ?? 0)
                        .reduce((value, element) => value + element) ??
                    0;

                bool isAnyStorageNameNull = element.storages?.any((storage) =>
                        storage.name == null || storage.name == '') ??
                    false;

                if (!isAnyStorageNameNull &&
                        sumOfQuantity == element.quantity ||
                    element.status == "return") {
                  allCompleteItems.add(element);
                } else {
                  allInCompleteItems.add(element);
                }
              }

              controller.itemsPayload.value =
                  allCompleteItems + allInCompleteItems;

              controller.update();

              if (allCompleteItems.contains(itemDTO)) {
                int index = controller.itemsPayload
                    .indexWhere((element) => element.id == itemDTO.id);
                Future.delayed(const Duration(milliseconds: 500), () {
                  controller.currentPageIndex.value = 0;
                  controller.pageController.jumpToPage(index);
                });
              } else {
                controller.itemsPayload.remove(itemDTO);
                controller.itemsPayload
                    .insert(allCompleteItems.length, itemDTO);

                for (int i = 0; i < controller.itemsPayload.length; i++) {
                  for (int k = 0;
                      k < controller.itemsPayload[i].storages!.length;
                      k++) {
                    controller.storageController[i].value?[k].text =
                        controller.itemsPayload[i].storages?[k].name ?? "";
                    controller.dynamicQuantityDateController[i].value?[k].text =
                        controller.itemsPayload[i].storages?[k].qty
                                .toString() ??
                            "";
                    controller.expiryDateController[i].value?[k].text =
                        (controller.itemsPayload[i].storages?[k].expiredAt
                                    ?.isEmpty ??
                                true
                            ? ""
                            : controller
                                .itemsPayload[i].storages?[k].expiredAt?[0])!;
                  }
                }

                Future.delayed(const Duration(milliseconds: 500), () {
                  int index = controller.itemsPayload
                      .indexWhere((element) => element.id == itemDTO.id);
                  controller.pageController.jumpToPage(index);
                });

                controller.update();
              }

/*
              // controller.itemsPayload.sort((a, b) {
              //   bool aMatches = a.storages?[0].name != null && a.quantity == a.storages?[0].qty;
              //   bool bMatches = b.storages?[0].name != null && b.quantity == b.storages?[0].qty;
              //
              //   if (aMatches && !bMatches) {
              //     return -1;
              //   } else if (!aMatches && bMatches) {
              //     return 1;
              //   } else {
              //     return 0;
              //   }
              // });

              bool itemComplete = (itemDTO.status == "return" ||
                  (itemDTO.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == itemDTO.quantity));

              controller.itemsPayload.sort((a, b) {

                bool aMatches = (a.status == "return" ||
                    (a.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == a.quantity));

                bool bMatches = (b.status == "return" ||
                    (b.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == b.quantity));


                // bool aMatches = (a.status == "return" ||
                //     (a.storages?[0].name != null && a.quantity == a.storages?[0].qty));
                //
                // bool bMatches = (b.status == "return" ||
                //     (b.storages?[0].name != null && b.quantity == b.storages?[0].qty));


                if (aMatches && !bMatches) {
                  return -1;
                } else if (!aMatches && bMatches) {
                  return 1;
                } else {
                  return 0;
                }
              });



              int? lastMatchIndex = controller.itemsPayload.lastIndexWhere((element) {
                return element.status == "return" ||
                    (element.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == element.quantity);
              });

              int jumpIndex = 0;

              print('itemComplete ==> ${itemComplete} $lastMatchIndex');
              if(itemComplete){
                // int index1 = lastMatchIndex;
                // // int index = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);
                // // controller.itemsPayload.removeAt(index);
                // // controller.itemsPayload.insert(index1, itemDTO);
                // int index = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);
                //
                // jumpIndex = index;

                controller.currentPageIndex.value = searchItemsIndex;
                 int index = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);

                controller.update();
                Future.delayed(const Duration(milliseconds: 500), (){
                  controller.pageController.jumpToPage(searchItemsIndex);
                });

              } else {
                int index = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);

                int index1 = lastMatchIndex;
                controller.itemsPayload.removeAt(index);
                controller.itemsPayload.insert(index1, itemDTO);
                jumpIndex = index;
                controller.update();

                controller.itemsPayload.sort((a, b) {

                  bool aMatches = (a.status == "return" ||
                      (a.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == a.quantity));

                  bool bMatches = (b.status == "return" ||
                      (b.storages?.map((e) => e.name != null && e.name!.isNotEmpty ? e.qty ?? 0 : 0).reduce((value, element) => value + element) == b.quantity));

                  if (aMatches && !bMatches) {
                    return -1;
                  } else if (!aMatches && bMatches) {
                    return 1;
                  } else {
                    return 0;
                  }
                });
                int index2 = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);


                Future.delayed(const Duration(milliseconds: 500), (){
                  controller.pageController.jumpToPage(index2);
                });

              }

              for (int i = 0; i < controller.itemsPayload.length ; i++) {
                for (int k = 0; k < controller.itemsPayload[i].storages!.length ; k++){

                  controller.storageController[i].value?[k].text = controller.itemsPayload[i].storages?[k].name??"";
                  controller.dynamicQuantityDateController[i].value?[k].text = controller.itemsPayload[i].storages?[k].qty.toString()??"";
                  controller.expiryDateController[i].value?[k].text = (controller.itemsPayload[i].storages?[k].expiredAt?.isEmpty??true? "":controller.itemsPayload[i].storages?[k].expiredAt?[0])!;
                }
              }*/

              // int index = controller.itemsPayload.indexWhere((element) => element.id == itemDTO.id);

              // Future.delayed(const Duration(milliseconds: 500), (){
              //   controller.pageController.jumpToPage(index);
              //   print('jumpIndex ==> $index');
              // });

              // controller.searchValue.value = "";
              // controller.isFocus.value = false;
              // controller.searchFocusNode.unfocus();

              // ItemDTO temp = controller.itemsPayload[0];
              // controller.itemsPayload[0] = controller.itemsPayload[index];
              // controller.itemsPayload[index] = temp;
              // controller.currentPageIndex.value = 0;
              //
              //
              controller.searchValue.value = "";
              controller.isFocus.value = false;
              controller.searchFocusNode.unfocus();
            },
            title: Text(controller.searchItems[searchItemsIndex].name ?? ""),
            subtitle: Text(
                "${Strings.supplierCode}: ${controller.searchItems[searchItemsIndex].supplierCode ?? ""}"),
          );
        },
      ),
    );
  }

  Future<dynamic> addExtraDialog() {
    if (controller.extraItems.value != null) {
      controller.extraItems.value!.data = [];
    }
    return Get.dialog(
      Container(
        alignment: Alignment.center,
        child: GetBuilder<ArrivedItemsDetailController>(
            builder: (controllerArrivedItemsDetailController) {
          return StatefulBuilder(builder: (context, setState) {
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
                        ).marginSymmetric(
                            vertical: margin_15, horizontal: margin_15),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close))
                      ],
                    ).marginSymmetric(horizontal: 10.0),
                    Expanded(
                        child: Column(
                      children: [
                        TextView(
                          "Have you received any extra items that you had not ordered? Add such products.",
                          style: const TextStyle(color: Colors.grey),
                          maxLine: 3,
                        ).paddingSymmetric(horizontal: 20.0),
                        CustomTextFieldV3(
                          hintText: "Name/Product Code/Manufacture",
                          controller: controllerArrivedItemsDetailController
                              .extraItemsController,
                          hintStyle: const TextStyle(color: Colors.grey),
                          onFieldSubmitted: (String? value) =>
                              FocusScope.of(Get.context!).unfocus(),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controllerArrivedItemsDetailController
                                  .getExtraItems(value);
                            }
                          },
                          suffix: IconButton(
                            onPressed: () {},
                            icon: imageAsset(search, height: 16.0),
                          ),
                        ).marginSymmetric(
                            horizontal: margin_20, vertical: margin_10),
                        Expanded(
                          child: Visibility(
                            visible: (controllerArrivedItemsDetailController
                                        .extraItems.value?.data?.isNotEmpty ??
                                    false) ||
                                controllerArrivedItemsDetailController
                                    .extraItemsController.text.isEmpty,
                            replacement:
                                const Center(child: Text('No Data found')),
                            child: Visibility(
                              visible: controllerArrivedItemsDetailController
                                  .extraItemsController.text.isNotEmpty,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: margin_0),
                                  itemCount:
                                      controllerArrivedItemsDetailController
                                              .extraItems.value?.data?.length ??
                                          0,
                                  itemBuilder: (context, index) {
                                    final data =
                                        controllerArrivedItemsDetailController
                                            .extraItems.value?.data?[index];
                                    return ListTile(
                                      onTap: () async {
                                        bool isAlreadyContainThisItem =
                                            controller.itemsPayload.any(
                                                (item) =>
                                                    item.id ==
                                                    data?.externalProductId);

                                        if (isAlreadyContainThisItem) {
                                          Utils.showSnackBar(
                                              'This product is already added.');
                                        } else {
                                          Get.back();
                                          controller.extraItemsController
                                              .clear();
                                          var value = await extraProduct(
                                            id: data?.externalProductId ?? 0,
                                            supplierCode:
                                                data?.supplierCode ?? "",
                                            supplierName: data?.name ?? "",
                                          );
                                        }
                                      },
                                      title: Text(data?.name ?? ""),
                                      trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Text(
                                            "Add",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ));
          });
        }),
      ),
    );
  }

  Future<dynamic> extraProduct(
      {required String supplierCode,
      required String supplierName,
      required int id}) {
    TextEditingController supplierCodeController =
        TextEditingController(text: supplierCode);
    TextEditingController supplierNameController =
        TextEditingController(text: supplierName);
    TextEditingController unitPriceController = TextEditingController();
    TextEditingController orderedQuantityController = TextEditingController();
    final extraProductFormValidation = GlobalKey<FormState>();
    return Get.dialog(
      Container(
        height: Get.height * 0.7,
        width: Get.width * 0.8,
        alignment: Alignment.center,
        child: GetBuilder<ArrivedItemsDetailController>(
            builder: (controllerArrivedItemsDetailController) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: Get.height * 0.7,
                width: Get.width * 0.8,
                padding: const EdgeInsets.symmetric(vertical: margin_10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius_20)),
                child: Form(
                  key: extraProductFormValidation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextView(
                            "Extra Products",
                            style:
                                black_17_700()?.copyWith(color: primaryColor),
                          ).marginSymmetric(
                              vertical: margin_15, horizontal: margin_15),
                          const Spacer(),
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.close))
                        ],
                      ).marginSymmetric(horizontal: 10.0),
                      TextView(
                        "Supplier Code",
                        style: const TextStyle(color: Colors.grey),
                        maxLine: 3,
                      ).paddingSymmetric(horizontal: 20.0),
                      CustomTextFieldV3(
                        controller: supplierCodeController,
                        hintText: "EnterSupplier Code",
                        hintStyle: const TextStyle(color: Colors.grey),
                        onFieldSubmitted: (String? value) =>
                            FocusScope.of(Get.context!).unfocus(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Supplier Code";
                          }
                          return null;
                        },
                      ).marginSymmetric(
                          horizontal: margin_20, vertical: margin_10),
                      TextView(
                        "Supplier Name",
                        style: const TextStyle(color: Colors.grey),
                        maxLine: 3,
                      ).paddingSymmetric(horizontal: 20.0),
                      CustomTextFieldV3(
                        controller: supplierNameController,
                        hintText: "Enter Supplier Name",
                        hintStyle: const TextStyle(color: Colors.grey),
                        onFieldSubmitted: (String? value) =>
                            FocusScope.of(Get.context!).unfocus(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Supplier Name";
                          }
                          return null;
                        },
                      ).marginSymmetric(
                          horizontal: margin_20, vertical: margin_10),
                      TextView(
                        "Unit Price",
                        style: const TextStyle(color: Colors.grey),
                        maxLine: 3,
                      ).paddingSymmetric(horizontal: 20.0),
                      CustomTextFieldV3(
                        controller: unitPriceController,
                        hintText: "Enter Unit Price",
                        textInputType: TextInputType.number,
                        hintStyle: const TextStyle(color: Colors.grey),
                        onFieldSubmitted: (String? value) =>
                            FocusScope.of(Get.context!).unfocus(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Unit Price";
                          }
                          return null;
                        },
                      ).marginSymmetric(
                          horizontal: margin_20, vertical: margin_10),
                      TextView(
                        "Ordered Quantity",
                        style: const TextStyle(color: Colors.grey),
                        maxLine: 3,
                      ).paddingSymmetric(horizontal: 20.0),
                      CustomTextFieldV3(
                        controller: orderedQuantityController,
                        hintText: "Enter Ordered Quantity",
                        textInputType: TextInputType.number,
                        hintStyle: const TextStyle(color: Colors.grey),
                        onFieldSubmitted: (String? value) =>
                            FocusScope.of(Get.context!).unfocus(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Ordered Quantity";
                          }
                          return null;
                        },
                      ).marginSymmetric(
                          horizontal: margin_20, vertical: margin_10),
                      const SizedBox(
                        height: margin_20,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AppButton(
                            buttonText: "Add",
                            isLoading: controller.isLoading.value,
                            buttonColor: primaryColor,
                            onTap: () {
                              if (extraProductFormValidation.currentState!
                                  .validate()) {
                                Map<String, dynamic> data = {
                                  "id": id,
                                  "name": supplierNameController.text,
                                  "supplierCode": supplierCodeController.text,
                                  "unitPrice":
                                      double.parse(unitPriceController.text),
                                  "orderedQuantity":
                                      int.parse(orderedQuantityController.text),
                                  "quantity":
                                      int.parse(orderedQuantityController.text),
                                };
                                controller.selectedItem = data;
                                controller.update();

                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                  controller.addItem(
                                    isNew: true,
                                    id: controller.selectedItem['id'],
                                    name: controller.selectedItem['name'],
                                    supplierCode:
                                        controller.selectedItem['supplierCode'],
                                    unitPrice:
                                        controller.selectedItem['unitPrice'],
                                    orderedQuantity: controller
                                        .selectedItem['orderedQuantity'],
                                    quantity:
                                        controller.selectedItem['quantity'],
                                  );
                                });
                              }
                            }).marginSymmetric(horizontal: margin_20),
                      )
                    ],
                  ),
                ));
          });
        }),
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
