import 'package:denvin_stock/exports.dart';


class AuthClinicSelectionScreen extends GetView<AuthClinicSelectionController>{

  AuthClinicSelectionScreen({super.key}){
    controller.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBar(showLogo: false,centerLogo: true,title: "Select Clinic",titleColor: primaryColor,showBack: false),
          body: _mainBody()
      ),
    );
  }
  _mainBody(){
    return  Column(
      children: [
        Expanded(
          child: Obx(
                ()=> ListView(
              children: [
                vGap(20.0),
                ...List.generate(controller.userProfile.value?.clinicDetails?.length ?? 0, (index){
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
                            TextView(controller.selectedList[index].clinicDetails?.name ?? "",style: primaryColor_18_600()?.copyWith(color: primaryColor) ),
                            TextView(controller.selectedList[index].clinicDetails?.addressLine1 ?? "" , style: black_16_400()?.copyWith()),
                          ],
                        ),
                      ],
                    ),
                  ).onTap(() {
                    controller.selectClinicId(index);
                  });
                })
              ],
            ).marginSymmetric(horizontal: 20.0),
          ),
        ),
        KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isKeyboardVisible ? 0 : null,
                child: isKeyboardVisible ? null :   SafeArea(child:_submitButton()),
              );
            }),
      ],
    );
  }

  _submitButton(){
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