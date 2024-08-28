import 'package:denvin_stock/components/conformation_popup.dart';
import 'package:denvin_stock/components/dashed_rect.dart';
import 'package:denvin_stock/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'controller/add_product_controller.dart';



class ManualAddProductScreen extends GetView<AddProductController> {
  final GlobalKey dropdownKey = GlobalKey();
  final formGlobalKey = GlobalKey<FormState>();

  ManualAddProductScreen({super.key}) {
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(builder: (controller) {
      return MyAnnotatedRegion(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: myAppBar(
              centerLogo: true,
              showBack: true,
              showLogo: false,
              // showOcrButton: IconButton(onPressed: () {
              //   Get.toNamed(AppRoutes.dataAddOcrScreen);
              // },
              //     icon: const Icon(Icons.add)).marginOnly(right: 10.0),
              title: controller.isEdit.value ? Strings.editDetails : Strings.addDetails,
            ),
            body: _mainBody()),
      );
    });
  }

  _mainBody() {
    return SingleChildScrollView(
      child: Obx(
        () => Form(
          key: formGlobalKey,
          autovalidateMode: controller.autoValidate.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _addImage(),
              _enterProductName(),
              _otherDetails(),
              _showMoreFields(),
              _tags(),
              _addQrAndBarCode(),
              vGap(20.0),
              SafeArea(
                  child: Obx(() => AppButton(
                    isLoading: controller.dummyLoading.value,
                    onTap: () {
                      if (formGlobalKey.currentState!.validate()) {
                        if(controller.isStorageListEmpty.value) {
                          Utils.showSnackBar("Please add storage from web");
                          return;
                        }
                        if (controller.selectedStorage.value == null) {
                          Utils.showSnackBar("Please Select Storage");
                          return;
                        }
                        if (controller.selectedSupplier.value == null) {
                          Utils.showSnackBar("Please Select Supplier");
                          return;
                        }
                        if (controller.isEdit.value) {
                          controller.editProduct();
                        } else {
                          controller.addProduct();
                        }
                      } else {
                        controller.autoValidate.value = AutovalidateMode.always;
                      }
                    }).marginSymmetric(horizontal: 20.0),
              )),
              vGap(10.0),
            ],
          ),
        ),
      ),
    );
  }

  _addImage() {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          if (controller.imagePath.value.isNotEmpty && controller.myFile.value != null)
            FullScreenWidget(isOpen: (isOpen){

            },disposeLevel: DisposeLevel.High, child: imageFile(controller.myFile.value!, height: 140, width: Get.width, fit: BoxFit.cover).paddingSymmetric(horizontal: 20.0, vertical: 20.0)),
          if (controller.imagePath.value.isNotEmpty)
            Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 16,
                  child: const Icon(Icons.delete_rounded,size: 21,),
                ).onTap(() {
                  showAlertDialog(onYes: (){
                    controller.imagePath.value = "";
                    controller.myFile.value = null;
                    controller.imageUrlToEdit.value = null;
                  });
                })),
          if (controller.imagePath.value.isEmpty)
            Container(
              height: 140,
              width: Get.width,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: DashedRect(
                 strokeWidth: 2,
                gap: 4.0,
                color: Colors.grey.withOpacity(0.8),
              ),
            ).onTap(() {
              controller.addBannerImage();
            }).paddingSymmetric(horizontal: 20.0),
          if (controller.imagePath.value.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.imageLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : imageAsset(addPhotoIcon, height: 30.0),
                vGap(8.0),
                TextView(
                  Strings.addPhotos,
                  style: black_15_300()?.copyWith(color: hintTextColor),
                )
              ],
            ).onTap(() {
              controller.addBannerImage();
            }).paddingSymmetric(horizontal: 20.0),
          if (controller.isEdit.value) _getEditImage(),
          if (controller.isEdit.value)
            controller.imageUrlToEdit.value != null ? Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 16,
                      child: const Icon(Icons.delete_rounded,size: 21,),
                    ).onTap(() {
                      showAlertDialog(onYes: (){
                        controller.imagePath.value = "";
                        controller.imageUrlToEdit.value = null;
                        controller.myFile.value = null;
                      });
                    }))
                : const SizedBox(),
        ],
      ),
    );
  }


  void showAlertDialog({required VoidCallback onYes}) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap(20.0),
              TextView("Are you sure?", style: black_17_600(),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              TextView("You want to delete this image.",maxLine: 3, style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                        },
                        child: Text("No", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                          onYes();
                        },
                        child: Text("Yes", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                  ],
                ),
              ).marginSymmetric(horizontal: 10.0),
              vGap(10.0),
            ],
          ),
        );
      },
    );
  }


  _getEditImage() {
    if (controller.imagePath.value.isEmpty) {
      if (controller.imageUrlToEdit.value != null) {
        return FullScreenWidget(
          isOpen: (isOpen){},
          disposeLevel: DisposeLevel.High,
          child: ShimmerImage(
            url: controller.imageUrlToEdit.value ?? "",
            width: Get.width,
            height: 140,
            fit: BoxFit.cover,
          ).paddingSymmetric(horizontal: 20.0).marginSymmetric(vertical: 20),
        );
      } else {
        return const SizedBox();
      }
    } else {
      return const SizedBox();
    }
  }

  _enterProductName() {
    return Container(
      height: 80.0,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      color: const Color(0xfff2f2f2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.textFieldLabel(isRequired: true, label: Strings.product),
          CustomTextFieldV2(
              hintText: Strings.enterProductName,
              hintStyle: black_14_400()?.copyWith(color: hintTextColor),
              controller: controller.productNameController,
              focusNode: controller.productNameFocusNode,
              readOnly: controller.isEdit.value || controller.productType == ProductType.edit,
              suffix: controller.isEdit.value || controller.productType == ProductType.edit ?
              Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)) :
              const Icon(Icons.document_scanner_rounded,size: 20,).onTap(() {
                Get.toNamed(AppRoutes.dataAddOcrScreen, arguments: {"FIELD" : Strings.product,
                })?.then((value) {
                  if(value != null){
                    controller.productNameController.text = value;
                  }
                });
              }),
              validator: (value) => value?.isEmptyField(messageTitle: Strings.productName),
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.quantityFocusNode)),
        ],
      ),
    );
  }

  _otherDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.totalPrice,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    CustomTextFieldV2(
                        readOnly: true,
                        suffix: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)),
                        hintText: Strings.enterPrice,
                        hintStyle:
                            black_14_400()?.copyWith(color: hintTextColor),
                        textInputType: TextInputType.number,
                        prefix: const Text("£ ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        controller: controller.priceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("^0"))
                        ],
                        focusNode: controller.priceFocusNode,
                        //validator: (value) => value?.isEmptyField(messageTitle: Strings.price),
                        onFieldSubmitted: (String? value) =>
                            FocusScope.of(Get.context!)
                                .requestFocus(controller.totalPriceFocusNode)
                    ),
                  ],
                ).paddingSymmetric(horizontal: 30),
              ),
            ),
            Container(
              height: 80.0,
              width: 1,
              color: const Color(0xffe3e3e3),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      Strings.minimumLevel,
                      style: black_14_600()
                          ?.copyWith(color: const Color(0xff707070)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldV2(
                             // readOnly: true,
                            //  suffix: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)),
                              hintText: Strings.enterMinimumLevel,
                              hintStyle: black_14_400()?.copyWith(color: hintTextColor),
                              onChanged: (value) {
                                controller.minimumLevelCount.value = int.tryParse(value) ?? 0;
                              },
                              textInputType: TextInputType.number,
                              controller: controller.minimumLevelController,
                              focusNode: controller.minimumLevelFocusNode,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                return value?.isEmptyField(messageTitle: Strings.minimumLevel);
                              },
                              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.priceFocusNode)),
                        ),
                        // Row(
                        //   children: [
                        //     const Text(
                        //       "-",
                        //       style: TextStyle(fontSize: 24),
                        //     ).onTap(() {
                        //       controller.subMinimumLevel();
                        //     }),
                        //     hGap(20),
                        //     const Text(
                        //       "+",
                        //       style: TextStyle(fontSize: 24),
                        //     ).onTap(() {
                        //       controller.addMinimumLevel();
                        //     }),
                        //   ],
                        // )
                      ],
                    ),
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
        vGap(10),
        if (!controller.isEdit.value)
        // if(controller.expiryDateController.isNotEmpty)
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
                    "Add More Expiry Date",
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
        // if (!controller.isEdit.value)
          vGap(10),
        // if (!controller.isEdit.value)
          Obx(() => Column(
              children: _getExpiryList(controller.expiryDateController),
            ),
          ).marginSymmetric(horizontal: 20),
        // vGap(10),
        controller.isEdit.value ? const SizedBox() : Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        controller.isEdit.value ? const SizedBox() : vGap(10),
      ],
    );
  }

  _getExpiryList(List<TextEditingController> expiryList){
    List<Widget> tempList = [];
    for(int i=0; i < expiryList.length; i++){
      tempList.add(Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.black.withOpacity(0.02),
            border: Border.all(width: 1, color: textFieldBorderColor)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                      hintText: Strings.unitPrice,
                      readOnly: controller.isEdit.value,
                      suffix: controller.isEdit.value ? Icon(Icons.lock, color: Colors.grey.withOpacity(0.7), size: 18,) : null,
                      controller: controller.dynamicPriceController[i],
                      textInputType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => value?.priceyValidation(messageTitle: Strings.unitPrice,value: value),
                      focusNode: controller.dynamicPriceFocusNode[i],
                      onFieldSubmitted: (String? value) =>
                          FocusScope.of(Get.context!).unfocus()),
                ),
                hGap(10.0),
                Expanded(
                  child: CustomTextField(
                      hintText: Strings.quantity,
                      readOnly: controller.isEdit.value,
                      suffix: controller.isEdit.value ? Icon(Icons.lock, color: Colors.grey.withOpacity(0.7), size: 18,) : null,
                      controller: controller.dynamicQuantityDateController[i],
                      textInputType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if(controller.isOldExpiryData[i] == false){
                          value?.quantityValidation(messageTitle: Strings.quantity,value: value);
                        }else{
                          return null;
                        }

                      },
                      focusNode: controller.dynamicQuantityDateFocusNode[i],
                      onFieldSubmitted: (String? value) =>
                          FocusScope.of(Get.context!).unfocus()),
                ),

              ],
            ),

            vGap(10.0),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      hintText: Strings.expiryDate,
                      validator: (value) {
                        if(controller.isOldExpiryData[i] == false){
                          if (value!.isEmpty) {
                            if(i == 0){
                              return null;
                            } else {
                              return 'Please enter a date';
                            }
                          } else if (!controller.isValidDate(value)) {
                            return 'Please enter valid date';
                          } else if (controller.isDateBeforeToday(value)) {
                            return 'Please enter future date';
                          } else if (controller.isDuplicateDate(i)){
                            return 'Please enter different dates';
                          }
                        }

                        return null;
                      },
                      inputFormatters: [DateFormatter()],
                      controller: controller.expiryDateController[i],
                      textInputType: TextInputType.number,
                      maxLength: 10,
                      suffix: Icon(
                        Icons.calendar_month,
                        color: greyIconColor,
                      ).onTap(() {
                        controller.getExpiryDate(i);
                      }),
                      focusNode: controller.expiryDateFocusNode[i],
                      onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()),
                ),
                if (i != 0)
                  !controller.isEdit.value ? Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {

                        confirmPopUp(
                            title: 'Are you sure?',
                            subtitle: 'You want to delete this expiry date.',
                            onConfirm: (){
                              controller.isOldExpiryData.removeAt(i);
                              controller.expiryDateController.removeAt(i);
                              controller.dynamicQuantityDateController.removeAt(i);
                              controller.expiryDateFocusNode.removeAt(i);
                              controller.dynamicQuantityDateFocusNode.removeAt(i);
                              controller.dynamicPriceFocusNode.removeAt(i);
                              controller.dynamicPriceController.removeAt(i);
                            }
                        );
                      },
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        margin: const EdgeInsets.only(left: 10),
                        child: const Center(
                          child: Icon(
                            Icons.delete,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ).marginOnly(top: 14) : const SizedBox()
              ],
            )
          ],
        ).marginOnly(bottom: 10),
      ));
    }
    return tempList;
  }

  _tags(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vGap(10.0),
        Container(
          height: 1.0,
          width: Get.width,
          color: const Color(0xffe3e3e3),
        ),
        vGap(10.0),
        Row(
          children: [
            Utils.textFieldLabel(label: "Tags"),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(6.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextView(
                      "Add Tag",
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
                controller.addTagView();
              }),
            )
          ],
        ).marginSymmetric(horizontal: 20.0),
        vGap(10.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 6,
            children: [
              ...List.generate(controller.mySelectedTags.length ?? 0, (index) {
                TagModal myTag = controller.mySelectedTags[index] ?? TagModal();
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(myTag.name ?? "",style: const TextStyle(fontSize: 12),maxLines: 2,),
                      hGap(2.0),
                      const Icon(Icons.close, size: 18,).onTap(() {
                        controller.mySelectedTags.remove(myTag);
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        ).marginSymmetric(horizontal: 20.0),
        if(controller.mySelectedTags.isNotEmpty) vGap(10.0),
      ],
    );
  }

  _showMoreFields() {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: Obx(
        () => ExpansionTile(
          collapsedIconColor: Colors.transparent,
          iconColor: Colors.transparent,
          initiallyExpanded: controller.isExpandedMoreFields.value,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
              ),
              hGap(8.0),
              Text(
                Strings.showMoreFields,
                style: black_15_700()?.copyWith(color: primaryColor),
              ),
            ],
          ),
          children: <Widget>[
            Utils.textFieldLabel(isRequired: true, label: Strings.storage),
            vGap(10.0),
            Container(
              decoration: BoxDecoration(
                  color: textFieldFillColor,
                  border: Border(bottom: BorderSide(color: textFieldBorderColor, width: 1))),
              child: ButtonTheme(
                alignedDropdown: true,
                child: Obx(
                  () => SizedBox(
                    height: 55.0,
                    child: Center(
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: controller.selectedStorage.value,
                        hint: TextView(
                          "Storage",
                          style: TextStyle(
                              color: hintTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        icon: controller.isEdit.value ?  Icon(Icons.lock, color: Colors.grey.withOpacity(0.7), size: 18,) : const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
                        iconSize: 24,
                        style: const TextStyle(color: Colors.black,),
                        // underline: Container(height: 0, color: Colors.transparent,),
                        onChanged: controller.isEdit.value ? null : (int? newValue) {controller.selectedStorage.value = newValue;controller.update();},
                        elevation: 1,
                        decoration: const InputDecoration(
                          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: controller.storageList.map<DropdownMenuItem<int>>((Supplier value) {
                          return DropdownMenuItem<int>(
                            enabled: value.id == null ? false : true,
                            value: value.id,
                            child: Text(value.name ?? Strings.nA, style: TextStyle(color: value.id == null ? greyIconColor : black),),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            vGap(24),
            Utils.textFieldLabel(isRequired: true, label: Strings.supplierCode),
            vGap(10.0),
            Obx(
              () => CustomTextField(
                  hintText: Strings.supplierCode,
                  readOnly: controller.dontHaveCode.value || controller.productType == ProductType.edit ? true : false,
                  fillColor: controller.dontHaveCode.value ? Colors.grey.withOpacity(0.3) : null,
                  suffix: controller.dontHaveCode.value || controller.productType == ProductType.edit ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey.withOpacity(0.7),
                          )) : null,
                  controller: controller.supplierCodeController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r"\s")),
                  ],
                  validator: (value) => controller.dontHaveCode.value ? null : value?.isEmptyField(messageTitle: Strings.supplierCode),
                  focusNode: controller.supplierCodeFocusNode,
                  onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.supplierFocusNode)),
            ),
            if (!controller.isEdit.value) vGap(24),
            if (!(controller.isEdit.value ||
                controller.productType == ProductType.edit))
              Row(
                children: [
                  Obx(
                    () => Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: controller.dontHaveCode.value ? primaryColor : whiteColor,
                          border: controller.dontHaveCode.value ? null : Border.all(color: greyColor, width: 1)),
                      child: controller.dontHaveCode.value ? Icon(
                              Icons.check,
                              color: whiteColor,
                              size: 14,
                            ) : const SizedBox(),
                    ).onTap(() {
                      controller.checkRememberMe();
                    }),
                  ),
                  hGap(10.0),
                  TextView(Strings.iDontSupportCode,
                          style: black_14_400()?.copyWith(color: greyColor))
                      .onTap(() {
                    controller.checkRememberMe();
                  }),
                ],
              ),
            // if(!controller.isEdit.value)
            vGap(24),
            // if(!controller.isEdit.value)
            Row(
              children: [
                Utils.textFieldLabel(isRequired: true, label: Strings.supplier),
              ],
            ),
            // if(!controller.isEdit.value)

            // if(!controller.isEdit.value)
            vGap(10.0),
            Container(
              decoration: BoxDecoration(
                  color: textFieldFillColor,
                  border: Border(
                      bottom: BorderSide(color: textFieldBorderColor, width: 1))),
              child: StatefulBuilder(builder: (context, setState) {
                return ButtonTheme(
                  alignedDropdown: true,
                  child: Obx(
                    () => controller.showSupplierMenu.value
                        ? DropdownMenu(
                            key: dropdownKey,
                            hintText: "Supplier",
                            enableFilter: true,
                            menuHeight: Get.height * 0.4,
                            enableSearch: true,
                            enabled: (!(controller.isEdit.value || controller.productType == ProductType.edit)),
                            requestFocusOnTap: false,
                            trailingIcon: controller.productType == ProductType.edit ? Icon(Icons.lock,color: Colors.grey.withOpacity(0.7),size: 18,) : null,
                            controller: controller.supplierController,
                            initialSelection: controller.selectedSupplier.value,
                            width: Get.width - 40,
                            inputDecorationTheme: InputDecorationTheme(
                              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1)),
                              border: UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1)),
                              hintStyle: TextStyle(
                                  color: hintTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
                            ),
                            textStyle: TextStyle(
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            onSelected: (int? newValue) {
                              controller.selectedSupplier.value = newValue;
                              controller.update();
                              setState(() {});
                            },
                            dropdownMenuEntries: controller.supplierList.map<DropdownMenuEntry<int>>((Supplier value) {
                              return DropdownMenuEntry<int>(
                                enabled: value.id == null ? false : true,
                                value: value.id ?? 0,
                                labelWidget: value.id == null
                                    ? Row(
                                        children: [
                                          Text(
                                            value.name ?? Strings.nA,
                                            style: TextStyle(color: value.id == null ? greyIconColor : black),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 2.0),
                                            decoration: BoxDecoration(
                                                // color: primaryColor,
                                                border: Border.all(color: primaryColor, width: 1),
                                                borderRadius: BorderRadius.circular(6.0)),
                                            child: TextView("Add Supplier",
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13),
                                            ),
                                          ).onTap(() {
                                            controller.showSupplierMenu.value = false;
                                            Get.toNamed(AppRoutes.addSupplier)?.then((value) {
                                              controller.showSupplierMenu.value = true;
                                              if (value != null) {
                                                controller.getSupplier(supplierModal: value);
                                              }
                                            });
                                          }),
                                        ],
                                      )
                                    : Text(
                                        value.name ?? Strings.nA,
                                        style: TextStyle(
                                            color: value.id == null
                                                ? greyIconColor
                                                : black),
                                      ),
                                label: value.name ?? Strings.nA,
                              );
                            }).toList(),
                          )
                        : SizedBox(),
                  ),
                );
              }),
            ),
            if(!controller.isEdit.value)
            vGap(24),
            if(!controller.isEdit.value)
            CustomTextField(
                hintText: Strings.orderDate,
                controller: controller.dateController,
                // validator: (value) => value?.isEmptyField(messageTitle: Strings.date),
                suffix: IconButton(
                  onPressed: () {
                      controller.getDate();
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: greyIconColor,
                  ),
                ),
                inputFormatters: [DateFormatter()],
                textInputType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  } else if (!controller.isValidDate(value)) {
                    return 'Please enter valid date';
                  }
                  return null;
                },
                onTap: () {
                  // if (!controller.isEdit.value)
                  //   if  (!(controller.isEdit.value ||
                  //       controller.productType == ProductType.edit))
                  // {
                  //   controller.getDate();
                  // }
                },
                // readOnly: true,
                focusNode: controller.dateFocusNode,
                onFieldSubmitted: (String? value) => FocusScope.of(Get.context!)
                    .requestFocus(controller.manufactureFocusNode)),
            vGap(24),
            CustomTextField(
                hintText: Strings.manufacturer,
                controller: controller.manufactureController,
                suffix: controller.productType == ProductType.edit ? IconButton(onPressed: () {}, icon: Icon(Icons.lock, color: Colors.grey.withOpacity(0.7),)) : null,
                // validator: (value) => value?.isEmptyField(messageTitle: Strings.manufacture),
                focusNode: controller.manufactureFocusNode,
                readOnly: (controller.productType == ProductType.edit),
                onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()),
            // vGap(24),
            // if(controller.isEdit.value) CustomTextField(
            //     hintText: Strings.note,
            //     controller: controller.notesController,
            //     focusNode: controller.notesFocusNode,
            //     readOnly: (controller.productType == ProductType.edit),
            //     onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()),
          ],
        ),
      ),
    );
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
          vGap(10.0),
          Row(
            children: [
              TextView(
                Strings.qrBarCode,
                style: black_15_700()?.copyWith(color: greyIconColor),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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

          ...List.generate([...controller.barcodes ?? [],].length, (index) {
            return Row(
              children: [
                IconButton(onPressed: () {}, icon: imageAsset(barIcon, color: black, height: 20)),
                hGap(10.0),
                Expanded(
                  child: TextView(
                    controller.barcodes[index].barcode ?? "",
                    style: black_14_600()?.copyWith(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                hGap(10.0),
                IconButton(
                    onPressed: () {
                      if (controller.isEdit.value) {

                        confirmPopUp(
                            title: 'Are you sure?',
                            subtitle: 'You want to delete this barcode.',
                            onConfirm: (){
                              if (controller.barcodes.length == 1) {
                                controller.deleteAllBarCode(
                                    barcodeUniqueId: controller.products.value?.localMappingId ?? -1,
                                    onSuccess: () {
                                      controller.barcodes.removeAt(index);
                                      controller.update();
                                    });
                              } else {
                                DeleteBarCodeDto deleteBarCodeDto = DeleteBarCodeDto(
                                  id: controller.products.value?.localMappingId ?? -1,
                                );
                                deleteBarCodeDto.barcodes = [
                                  DeletedBarcodesDto(
                                    barcode: controller.barcodes[index].barcode,
                                    type: controller.barcodes[index].symbology,
                                  )
                                ];
                                controller.deleteOneBarCode(
                                    deleteBarCodeDto: deleteBarCodeDto,
                                    onSuccess: () {
                                      controller.barcodes.removeAt(index);
                                      controller.update();
                                    });
                              }
                            }
                        );
                      }
                    },
                    icon: const Icon(Icons.close)),
              ],
            ).marginSymmetric(horizontal: 20.0);
          }),
          ...List.generate([...controller.addBarcodes ?? []].length, (index) {
            return Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: imageAsset(barIcon, color: black, height: 20)),
                hGap(10.0),
                Expanded(
                  child: TextView(
                    controller.addBarcodes[index].barcode ?? "",
                    style: black_14_600()?.copyWith(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                hGap(10.0),
                IconButton(
                    onPressed: () {
                      confirmPopUp(
                          title: 'Are you sure?',
                          subtitle: 'You want to delete this barcode.',
                          onConfirm: (){
                            controller.addBarcodes.removeAt(index);
                            controller.update();
                          }
                      );

                    },
                    icon: const Icon(Icons.close)),
              ],
            );
          }),
          if (controller.barcodes.isEmpty)
            Row(
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
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
        ],
      ),
    );
  }
}


class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;
    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;
    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}