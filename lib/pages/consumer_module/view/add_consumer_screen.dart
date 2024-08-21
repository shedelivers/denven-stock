
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/consumer_module/controller/consumer_controller.dart';

class AddConsumerScreen extends GetView<ConsumerController>{

  AddConsumerScreen({super.key}){
    if(controller.isEdit.value){
        controller.addDefaultValues();
    } else{
      controller.cleanState();
    }
  }
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBar(showLogo: false,centerLogo: true,title: "${controller.isEdit.value ? "Edit" : "Add"} Dentist",titleColor: primaryColor),
          body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          vGap(10.0),
          _form(),
          vGap(40.0),
          KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isKeyboardVisible ? 0 : null,
                  child: isKeyboardVisible ? null :  Column(
                    children: [
                      _submitButton(),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  _form() {
    return Form(
     key: formGlobalKey,
      child: Column(
        children: [
          Utils.textFieldLabel(isRequired: true, label: Strings.title),
          vGap(10.0),
          Container(
            decoration: BoxDecoration(
                color: textFieldFillColor,
                border: Border(bottom: BorderSide(color: textFieldBorderColor, width: 1))),
            child: ButtonTheme(
              alignedDropdown: true,
              child: Obx(
                    () => DropdownButton<ConsumerTitle>(
                  isExpanded: true,
                  value: controller.selectedTitle.value,
                  hint: TextView(
                    "Select Title",
                    style: TextStyle(color: hintTextColor, fontSize: 14, fontWeight: FontWeight.w400),),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black, size: 22),
                  iconSize: 24,
                  style: const TextStyle(color: Colors.black,),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (ConsumerTitle? newValue) {
                    controller.selectedTitle.value = newValue;
                    controller.update();
                  },
                  elevation: 1,
                  items: controller.consumerTitle.map<DropdownMenuItem<ConsumerTitle>>((ConsumerTitle value) {
                    return DropdownMenuItem<ConsumerTitle>(
                      value: value,
                      child: Text(
                        value.name ?? Strings.nA,
                        style: TextStyle(color: black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          vGap(20.0),
          Utils.textFieldLabel(isRequired: true, label: Strings.firstName),
          vGap(10.0),
          CustomTextField(
            hintText:Strings.firstName,
            controller: controller.firstNameController,
            validator: (value) => value?.isEmptyField(messageTitle: Strings.firstName),
            focusNode: controller.firstNameFocusNode,
            onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.lastNameFocusNode)
          ),
          vGap(20.0),
          Utils.textFieldLabel(isRequired: true, label: Strings.lastName),
          vGap(10.0),
          CustomTextField(
              hintText:Strings.lastName,
              controller: controller.lastNameController,
              validator: (value) => value?.isEmptyField(messageTitle: Strings.lastName),
              focusNode: controller.lastNameFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).requestFocus(controller.descriptionFocusNode)
          ),
          vGap(20.0),
          Utils.textFieldLabel(isRequired: false, label: Strings.description),
          vGap(10.0),
          CustomTextField(
              hintText:Strings.description,
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
              onFieldSubmitted: (String? value) => FocusScope.of(Get.context!).unfocus()
          ),

        ],
      ).marginSymmetric(horizontal: 20.0),
    );
  }

  _submitButton(){
    return Obx(
        ()=> AppButton(
          isLoading: controller.isLoading.value,
          onTap: (){
        if(controller.selectedTitle.value == null) {
          Utils.showSnackBar("Please select title");
          return;
        }
        if(formGlobalKey.currentState!.validate()){
          controller.addConsumer();
        }
      }, buttonText: Strings.create,).marginSymmetric(horizontal: 20.0),
    );
  }
}