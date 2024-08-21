import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/settings_module/controller/clinic_selection_controller.dart';

class ClinicSelectionScreen extends GetView<ClinicSelectionController>{
  
  ClinicSelectionScreen({super.key}){
    controller.getUserProfile();  

  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBar(
              showLogo: false,
              centerLogo: true,
              title: "Clinics",

              // showOcrButton: IconButton(onPressed: () {
              //   Get.toNamed(AppRoutes.addClinicView)?.then((value) {
              //     if(value == "ADDED") {
              //       controller.getUserProfile();
              //     }
              //   });
              // },
              // icon: const Icon(Icons.add)).marginOnly(right: 20.0),
          ),
          body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return Obx(
        ()=> controller.isLoading.value ? Utils.screenLoading()  : controller.selectedList.isEmpty ? Utils.noDataFound() : Column(
          children: [
            Expanded(
              child:ListView(
                  children: [
                    vGap(20.0),
                    ...List.generate(controller.selectedList.length ?? 0, (index){
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: textFieldBorderColor, width: 1)),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: controller.selectedList[index].isSelected ?? false ? primaryColor : whiteColor,
                                  border: controller.selectedList[index].isSelected ?? false ? null : Border.all(color: greyColor, width: 1)),
                              child: controller.selectedList[index].isSelected ?? false ? Icon(
                                Icons.check,
                                color: whiteColor,
                                size: 14,
                              ) : const SizedBox(),
                            ),
                            hGap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(controller.selectedList[index].clinicDetails?.name ?? "N/A",style: primaryColor_18_600()?.copyWith(color: primaryColor) ),
                                TextView(controller.selectedList[index].clinicDetails?.addressLine1 ?? "N/A" , style: black_16_400()?.copyWith()),
                              ],
                            ),
                            // const Spacer(),
                            // IconButton(onPressed: (){
                            //   Get.toNamed(AppRoutes.addClinicView,arguments: {
                            //     RoutesArgument.isEdit : true,
                            //     RoutesArgument.clinicDetails : controller.selectedList[index].clinicDetails,
                            //   })?.then((value) {
                            //     if(value == "EDITED"){
                            //       controller.getUserProfile();
                            //     }
                            //   });
                            // }, icon: const Icon(Icons.edit))
                          ],
                        ),
                      ).onTap(() {
                        controller.selectClinicId(index);
                      });
                    })
                  ],
                ).marginSymmetric(horizontal: 20.0),
            ),
            KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isKeyboardVisible ? 0 : null,
                    child: isKeyboardVisible ? null : SafeArea(child:_submitButton()),
                  );
                }),
          ],
        ),
    );
  }

  _divider(){
    return const Divider(
      thickness: 1,
      color: Color(0xffDDDDDD),
      height: 20,
      endIndent: 20.0,
      indent: 20.0,
    );
  }

  _submitButton() {
    return  Obx(()=> AppButton(
      isLoading: controller.isLoading.value,
      onTap: (){
          if(controller.selectedClinicId.value?.key == null){
            Utils.showSnackBar("Please Select any Clinic");
            return;
          }
          controller.submitClinicId();
      },
      buttonText: Strings.select,
    ).marginSymmetric(horizontal: 20.0),
    );
  }

}