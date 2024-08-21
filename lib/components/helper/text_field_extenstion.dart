import "package:denvin_stock/exports.dart";

extension TextFieldValidator on String {

  String? isValidEmail() {
    if(isEmpty){
      return Strings.pleaseEnterEmail;
    }
   else if(length > 0 && !GetUtils.isEmail(this)) {
     return Strings.enterValidEmail;
   }
  }

  String? isValidPhoneNumber() {
    if(isEmpty) {
      return Strings.pleaseEnterPhone;
    } else if(length > 0 && !GetUtils.isPhoneNumber(this)){
      return Strings.enterValidPhone;
    }
  }

  String? isValidPhoneNumberV2() {
    if(isEmpty){
      return Strings.pleaseEnterPhoneNumber;
    }
    else if(length > 0 && !GetUtils.isPhoneNumber(this)){
      return Strings.enterValidPhone;
    }
  }

  String? isValidUrl() {
    if(!GetUtils.isURL(this)){
      return Strings.enterValidUrl;
    }
  }

  String? isEmptyField({String? messageTitle}){
    if (isEmpty){
      return "$messageTitle is mandatory";
    }
  }

  String? isEmptyFieldValid3({String? messageTitle}){
    if (isEmpty){
      return "$messageTitle is mandatory";
    } else if(length < 3){
      return "$messageTitle must be longer than 3 characters";
    }
  }


  String? quantityValidation({String? messageTitle,String? value}){
    int numberValue  = int.tryParse(value ?? "0") ?? 0;
    if (isEmpty){
      return "$messageTitle is mandatory";
    } else if(numberValue == 0){
      return "$messageTitle must be greater than 0";
    }
  }

  String? priceyValidation({String? messageTitle,String? value}){
    if (isEmpty){
      return "$messageTitle is mandatory";
    }
  }

  String? isEmptyFieldAndGraterZero({String? messageTitle, String? value}){
    int numberValue  = int.tryParse(value ?? "0") ?? 0;
    if (isEmpty){
      return "$messageTitle is mandatory";
    } else if(numberValue <= 0 ){
      return "Value must be greater than 0";
    }
  }

  String? isEmptyFieldWithNoNumber({String? messageTitle}){
    if (isEmpty){
      return "$messageTitle can't be empty";
    }
    else if (int.tryParse(replaceAll(' ', ''))!=null){
      return "Invalid $messageTitle ";
    }
  }

  String? validatePassword() {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = RegExp(pattern);
    if (isEmpty) {
      return "Please enter password";
    }
    else if(!regExp.hasMatch(this)){
      return 'Password must be at least 6 characters, including at least 1 capital letter, at least 1 number & at least 1 special character';
    }
  }

  String? validateOtp() {
    if (isEmpty) {
      return "Please enter OTP";
    }
    else  if(length > 0 && !GetUtils.isNumericOnly(this)){
      return 'Please enter valid OTP';
    }
  }


  String? isNumberOnly({String? messageTitle}) {
    if (isEmpty) {
      return "Please enter $messageTitle";
    }
    else  if(length > 0 && !GetUtils.isNumericOnly(this)){
      return 'Please enter valid $messageTitle';
    }
  }

  String? validateConfirmPassword({required String password}) {
    if (isEmpty) {
      return "Please enter password";
    }
    else  if( password!=this){
      return 'Enter same password';
    }
  }

}