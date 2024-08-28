import 'package:denvin_stock/exports.dart';


class UpdateQuantityScreen extends GetView<UpdateQuantityController> {
  final formGlobalKey = GlobalKey<FormState>();

  UpdateQuantityScreen({super.key}){
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(centerLogo: false, showBack: true, showLogo: false, title: Strings.updateQuantity),
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
                ...List.generate(controller.numberOfFoams.value, (index) => Theme(
                  data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(bottom: 16, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black.withOpacity(0.02),
                        border: Border.all(width: 1, color: textFieldBorderColor)),
                    child: ExpansionTile(
                      initiallyExpanded: index == 0 ? true : false,
                      key: Key(index.toString()),
                      tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      childrenPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 0),
                      title: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomProductBoxView(
                                  title: 'Unit Price',
                                  subtitle:
                                  controller.products.value!.expiriesWithPrice![index].price.toString() == "null"? Strings.nA:controller.products.value!.expiriesWithPrice![index].price.toString()??"",


                                ),
                              ),


                              Expanded(
                                child: CustomProductBoxView(
                                  title: 'Quantity',
                                  subtitle: controller.products.value?.expiriesWithPrice?[index].qty.toString() ??  Strings.nA,
                                ),
                              ),
                              hGap(4),
                              /*Expanded(
                                child: CustomProductBoxView(
                                  title: 'Expiry Date',
                                  subtitle: controller.products.value?.expiries?[index].at ?? Strings.nA,
                                ),
                              ),*/

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




                            ],
                          ),
                          vGap(10.0),
                          Divider(height: 1,thickness: 1,color: textFieldBorderColor,)
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
          },buttonText: Strings.update,),
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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(Strings.updatedQuantity, style: black_14_600()?.copyWith(color: const Color(0xff707070)),),
                  vGap(10.0),
                  CustomTextFieldV2(
                    hintText: "0",
                    readOnly: true,
                    controller: controller.textQuantityController[index],
                    borderColor: Colors.black,
                    onChanged: (val){
                      controller.counter[index] = int.tryParse(val) ?? 0;
                    },
                    validator: (value) => value?.isEmptyField(messageTitle: "new quantity"),
                    border: UnderlineInputBorder(borderSide: BorderSide(width: 0.4,color: Colors.black.withOpacity(0.1))),
                    hintStyle: black_14_400()?.copyWith(color: hintTextColor),
                    focusNode: controller.textQuantityFocusNodes[index],
                    textInputType: TextInputType.number,
                    onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
                  ),
                ],
              ),
            ),
            Expanded(child: _counterBar(index)),
          ],
        ),
        // vGap(10.0),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           TextView(Strings.expiryDate, style: black_14_600()?.copyWith(color: const Color(0xff707070)),),
        //           vGap(10.0),
        //           CustomTextFieldV2(
        //             hintText: controller.products.value?.expiries?[index].at ?? "DD-MM-YYYY",
        //             controller: controller.textExpireController[index],
        //             borderColor: Colors.black,
        //             onTap: (){controller.getExpiryDate(index);},
        //             validator: (value) {
        //               if(controller.products.value?.expiries?.isNotEmpty ?? false){
        //                 if(controller.products.value!.expiries?.any((element) => element.at == value) ?? false){
        //                   if(controller.products.value?.expiries?[index].at == value){
        //                     return null;
        //                   } else {
        //                     return "You cant add the same date again";
        //                   }
        //                 }
        //                 else {
        //                   return null;
        //                 }
        //               }
        //               return null;
        //             },
        //             readOnly: true,
        //             // validator: (value) => value?.isEmptyField(messageTitle: Strings.expiryDate),
        //             border: UnderlineInputBorder(borderSide: BorderSide(width: 0.4,color: Colors.black.withOpacity(0.1))),
        //             hintStyle: black_14_400()?.copyWith(color: hintTextColor),
        //             focusNode: controller.textExpireFocusNodes[index],
        //             textInputType: TextInputType.number,
        //             onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Expanded(child: IconButton(onPressed:(){controller.getExpiryDate(index);}, icon: const Icon(Icons.calendar_month)))
        //   ],
        // ),
      ],
    ).paddingSymmetric(horizontal: 0.0,vertical: 20.0);
  }

  _counterBar(int index){
    return Obx(
      ()=> Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              TextView(controller.counter[index].toString(), style: black_24_700()),
              hGap(10.0),
              Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    splashColor: primaryColor,
                    onTap: (){
                      controller.addCount(index);
                    },
                    child: const Icon(Icons.keyboard_arrow_up,color: Colors.black,)
                  ),
                  InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      splashColor: primaryColor,
                      onTap: (){
                        controller.minusCount(index);
                      },
                      child: const Icon(Icons.keyboard_arrow_down_sharp,color: Colors.black,)
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  
  // _productQtyBar(int index){
  //   return Container(
  //     height: 60.0,
  //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextView(Strings.productQuantity, style: black_14_600()?.copyWith(color: const Color(0xff707070)),),
  //         TextView("${controller.products.value?.expiries?[index].qty ?? Strings.nA}", style: black_14_400()?.copyWith()),
  //       ],
  //     ),
  //   );
  // }
}