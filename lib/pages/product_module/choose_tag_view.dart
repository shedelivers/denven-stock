import 'dart:ffi';
import 'dart:math';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/product_module/controller/choose_tag_controller.dart';

Future<List<TagModal>?> chooseTagDialog({List<TagModal>? selectedTags}) {
  return Get.dialog<List<TagModal>?>(
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
                    "Choose Tags",
                    style: black_17_700()?.copyWith(color: primaryColor),
                  ).marginSymmetric(vertical: margin_15, horizontal: margin_15),
                  const Spacer(),
                  IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close)),
                ],
              ).marginSymmetric(horizontal: 10.0),
              Expanded(child: ChooseTagView(
                selectedTags: selectedTags,
              )),
            ],
          )),
    ),
  );
}

class ChooseTagView extends GetView<ChooseTagController> {
  final List<TagModal>? selectedTags;
  final formKey = GlobalKey<FormState>();

  ChooseTagView({Key? key, required this.selectedTags}) : super(key: key);


  getLength(){
    int length = (controller.suggestionTagList.length / 2).round();
    return length;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseTagController(selectedTags: selectedTags));
    return GetBuilder<ChooseTagController>(builder: (controller) {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            _searchFieldView(context: context),
            vGap(10.0),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  ()=> Column(
                    children: [
                      controller.isTextFieldFocused.value ? controller.isLoading.value ? const SizedBox() : controller.suggestionTagList.isEmpty ? Utils.noDataFound(message: "No such tag found") : Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          runAlignment: WrapAlignment.start,
                          runSpacing: 10,
                          spacing: 4,
                          children: [
                            ...List.generate(controller.suggestionTagList.length, (index) {
                              String? myTag = controller.suggestionTagList[index];
                              return myTag.isEmpty ? SizedBox() :  Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: controller.selectedTag.any((element) => element.name == myTag) ? primaryColor : Colors.grey,  width: 2)
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(myTag ?? "",style: const TextStyle(fontSize: 14),maxLines: 2,),
                                    if(controller.selectedTag.any((element) => element.name == myTag)) hGap(2.0),
                                    if(controller.selectedTag.any((element) => element.name == myTag)) const Icon(Icons.close, size: 18,).onTap(() {
                                      controller.selectedTag.removeWhere((element) => element.name == myTag);
                                    }),
                                  ],
                                ),
                              ).onTap(() {
                                if(controller.selectedTag.any((element) => element.name == myTag,)){
                                  controller.selectedTag.removeWhere((element) => element.name == myTag);
                                  return;
                                } else {
                                  if(controller.selectedTag.length < 2){
                                    Random random = Random();
                                    int randomNumber = 100000 + random.nextInt(900000);
                                    controller.selectedTag.add(TagModal(id: randomNumber, name: myTag));
                                    controller.update();
                                  } else {
                                    Utils.showSnackBar("Each product has a maximum of 2 tags.");
                                  }
                                }
                              });
                            }),
                          ],
                        ).marginSymmetric(horizontal: 12.0),
                      ) : SizedBox(),
                      if(controller.tagList.isNotEmpty) !controller.isTextFieldFocused.value ? Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          runSpacing: 10,
                          spacing: 4,
                          children: [
                            ...List.generate(controller.tagList.length + 1, (index) {
                              TagModal myTag = TagModal();
                              if(index != controller.tagList.length){
                                myTag = controller.tagList[index];
                              }
                              if(index == controller.tagList.length) {
                                if(controller.tagList.isNotEmpty) {
                                  if((controller.getTotalPage() - 1) >= controller.currentPage.value){
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: primaryColor,
                                          border: Border.all(color: primaryColor,  width: 2)
                                      ),
                                      child: TextView("Show More", style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w700),).onTap(() {
                                        controller.currentPage.value = (controller.tagResponse?.response?.page ?? 0) + 1;
                                        controller.hitApiLoadMore();
                                      }),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(color: controller.selectedTag.any((element) => element.name == myTag.name) ? primaryColor : Colors.grey,  width: 2)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(myTag.name ?? "",style: const TextStyle(fontSize: 14),maxLines: 2,),
                                      if(controller.selectedTag.any((element) => element.name == myTag.name)) hGap(2.0),
                                      if(controller.selectedTag.any((element) => element.name == myTag.name)) const Icon(Icons.close, size: 18,).onTap(() {
                                        controller.selectedTag.removeWhere((element) => element.name == myTag.name);
                                      }),
                                    ],
                                  ),
                                ).onTap(() {
                                  if(controller.selectedTag.any((element) => element.name == myTag.name,)){
                                    controller.selectedTag.removeWhere((element) => element.name == myTag.name);
                                    return;
                                  } else {
                                    if(controller.selectedTag.length < 2){
                                      Random random = Random();
                                      int randomNumber = 100000 + random.nextInt(900000);
                                      controller.selectedTag.add(TagModal(id: randomNumber, name: myTag.name));
                                      controller.update();
                                    } else {
                                      Utils.showSnackBar("Each product has a maximum of 2 tags.");
                                    }
                                  }
                                });
                              }
                            }),
                          ],
                        ).marginSymmetric(horizontal: 20.0),
                      ) : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
           Obx(
             ()=> controller.selectedTag.isEmpty ? const SizedBox() : Column(
               children: [
                 Container(
                   width: Get.width,
                   height: 1,
                   color: Colors.grey.withOpacity(0.5),
                 ),
                 vGap(6.0),
                 Utils.textFieldLabel(label: "Selected Tags:").marginSymmetric(horizontal: 20.0),
                 vGap(6.0),
                 Align(
                   alignment: Alignment.centerLeft,
                   child: Wrap(
                     spacing: 4,
                     runSpacing: 10,
                     children: [
                       ...List.generate(controller.selectedTag.length, (index) {
                         return Container(
                           padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20.0),
                               border: Border.all(color: controller.selectedTag.any((element) => element.name == controller.selectedTag[index].name) ? primaryColor : Colors.grey,  width: 2)
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Text(controller.selectedTag[index].name ?? "",style: const TextStyle(fontSize: 12),maxLines: 2,),
                               if(controller.selectedTag.any((element) => element.name == controller.selectedTag[index].name)) hGap(2.0),
                               if(controller.selectedTag.any((element) => element.name == controller.selectedTag[index].name)) const Icon(Icons.close, size: 18,).onTap(() {
                                 controller.selectedTag.removeWhere((element) => element.name == controller.selectedTag[index].name);
                               }),
                             ],
                           ),
                         );
                       })
                     ],
                   ).marginSymmetric(horizontal: 20.0),
                 ),
               ],
             ),
           ),
            vGap(10.0),
            AppButton(
                buttonText: "Select",
                buttonColor: primaryColor,
                onTap: () {
                  Get.back();
                }).marginSymmetric(horizontal: margin_20)
          ],
        );
      });
    });
  }
//Stack(
//                         children: [
//
//                           controller.isTextFieldFocused.value ? Align(
//                             alignment: Alignment.center,
//                             child: Container(
//                               width: Get.width / 1.3,
//                               padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
//                               decoration: BoxDecoration(
//                                 color: controller.suggestionTagList.isEmpty ? Colors.transparent : Colors.grey.shade100,
//                                 border: controller.suggestionTagList.isNotEmpty? Border.all(color: textFieldBorderColor, width: 1): null,
//                                 borderRadius: BorderRadius.circular(20.0)
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ...List.generate(controller.suggestionTagList.length, (index) {
//                                     return Text(controller.suggestionTagList[index], style: black_12_400(),).marginOnly(top: 20.0).onTap(() {
//                                       if(formKey.currentState!.validate()){
//                                         Random random = Random();
//                                         int randomNumber = 100000 + random.nextInt(900000);
//                                         String tagName = controller.suggestionTagList[index];
//                                         controller.tagList.insert(0,TagModal(name: tagName,id: randomNumber,value: tagName));
//                                         controller.update();
//                                         if(controller.selectedTag.length < 2){
//                                           controller.selectedTag.add(TagModal(name: tagName,id: randomNumber,value: tagName));
//                                           controller.update();
//                                         }
//                                         controller.searchFocusNode.unfocus();
//                                         controller.suggestionTagList.value = [];
//                                         controller.searchController.clear();
//                                       }
//                                     });
//                                   })
//                                 ],
//                               ),
//                             ),
//                           ): const SizedBox()
//                         ],
//                       ),
  _searchFieldView({required BuildContext context}) {
    return Form(
      key: formKey,
      child: CustomTextFieldV3(
        hintText: "Search",
        controller: controller.searchController,
        focusNode: controller.searchFocusNode,
        onChanged: (search){
          controller.searchKeyWord.value = search;
          if (controller.debounce?.isActive ?? false) {controller.debounce?.cancel();}
          controller.debounce = Timer(const Duration(milliseconds: 500), () {controller.hitApiGetSuggestions(search);});
        },
        onTap: (){

        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (value.length > 30) {
            return 'Text must be less than 30 characters long';
          }
          return null;
        },
        onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus(),
        suffix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            ()=> Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                controller.isLoading.value ? const SizedBox(width: 22,height: 22 ,child: CircularProgressIndicator(color: Colors.black,strokeWidth: 3,)) :  controller.isTextFieldFocused.value ? const Icon(Icons.clear,size: 24,color: Colors.black,).onTap(() {
                  controller.searchFocusNode.unfocus();
                  controller.searchController.clear();
                  controller.suggestionTagList.value = [""];
                }) : Icon(Icons.search,
                  size: 20,
                  color: Colors.grey.withOpacity(0.8),
                ),
                hGap(10.0),
                Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(6.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextView(
                        "Add New",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12
                        ),
                      ),
                      hGap(2.0),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      )
                    ],
                  ),
                ).onTap(() {
                  if(formKey.currentState!.validate()){
                    controller.searchFocusNode.unfocus();
                    controller.suggestionTagList.value = [];
                    Random random = Random();
                    int randomNumber = 100000 + random.nextInt(900000);
                    String tagName = controller.searchController.text;
                    controller.tagList.insert(0,TagModal(name: tagName,id: randomNumber,value: tagName));
                    controller.update();
                    if(controller.selectedTag.length < 2){
                      controller.selectedTag.add(TagModal(name: tagName,id: randomNumber,value: tagName));
                      controller.update();
                    }
                    controller.searchController.clear();
                    controller.searchFocusNode.unfocus();
                  }
                }),
              ],
            ),
          ),
        ),
      ).marginSymmetric(horizontal: margin_20, vertical: margin_10),
    );
  }
}






class LoaderMoreButton extends StatelessWidget {

  final GestureTapCallback onTap;

  const LoaderMoreButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: margin_20),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(6.0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  "Load more",
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
            )));
  }
}