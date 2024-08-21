import "package:denvin_stock/exports.dart";

Widget ctextFormField({
  required TextEditingController controller,
  required FocusNode focusNode,
  String? hintText,
  String? label,
  int maxLines = 1,
  bool obsecureText = false,
  String? validator(String? value)?,
  TextInputAction textInputAction = TextInputAction.next,
  TextInputType textInputType = TextInputType.text,
  Widget? prefix,
  Widget? suffix,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        if (label != null) vGap(4),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines,
          obscureText: obsecureText,
          textAlignVertical: TextAlignVertical.center,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
              color: Colors.grey),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: textTheme.bodyText1!.fontSize,
                fontWeight: textTheme.bodyText1!.fontWeight),
            helperStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            prefixStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            fillColor: COLOR_white,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );

Widget ctextFormFieldwithPrefix(
        {required TextEditingController controller,
        required FocusNode focusNode,
        String? hintText,
        String? label,
        int maxLines = 1,
        String? validator(String? value)?,
        String? onChange(String? value)?,
        String? onFieldSubmitted(String? value)?,
        String? onEditingComplete(String? value)?,
        TextInputAction textInputAction = TextInputAction.next,
        TextInputType textInputType = TextInputType.text,
        Widget? prefix}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        if (label != null) vGap(4),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          onChanged: onChange,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines,
          textAlignVertical: TextAlignVertical.center,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
              color: Colors.grey),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: DIMENS_16),
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: textTheme.bodyText1!.fontSize,
                fontWeight: textTheme.bodyText1!.fontWeight),
            helperStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            prefixStyle: TextStyle(
              color: Colors.grey,
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight,
            ),
            fillColor: COLOR_white,
            prefixIcon: prefix,
          ),
        ),
      ],
    );



class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;

  int? maxLines = 1;
  bool? obsecureText = false;

  String? Function(String?)? validator;
  TextInputAction? textInputAction = TextInputAction.next;
  TextInputType? textInputType = TextInputType.text;
  Widget? prefix;
  Widget? suffix;
  ValueChanged<String>? onFieldSubmitted;
  bool? readOnly;
  GestureTapCallback? onTap;
  Color? borderColor;
  List<TextInputFormatter>? inputFormatters;
  Color? fillColor;
  TextStyle? hintStyle;
  int? maxLength;
  InputBorder? border;
  Function(String)? onChanged;
  Key? formKey;

  CustomTextField(
      {Key? key,
      this.formKey,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.hintStyle,
      this.hintText,
      this.maxLines,
      this.inputFormatters,
      this.obsecureText,
      this.validator,
      this.readOnly,
      this.onTap,
      this.borderColor,
      this.fillColor,
      this.prefix,
      this.border,
      this.suffix,this.textInputAction,this.textInputType,this.onFieldSubmitted,this.maxLength
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      readOnly: readOnly ?? false,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      obscureText: obsecureText ?? false,
      obscuringCharacter: "*",
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: blackColor,
          fontSize: 14,
          fontWeight: FontWeight.w400
      ),
      decoration: InputDecoration(
          counter: const Offstage(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
        isDense: true,
        labelText: hintText,
        // hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(
            color: hintTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        helperStyle: TextStyle(
          color: Colors.grey,
          fontSize: textTheme.bodyText1!.fontSize,
          fontWeight: textTheme.bodyText1!.fontWeight,
        ),
        errorMaxLines: 3,
        suffixIconConstraints: const BoxConstraints(minWidth: 30),
        labelStyle: TextStyle(
            color: hintTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w400
        ),
        prefixStyle: TextStyle(
          color: Colors.grey,
          fontSize: textTheme.bodyText1!.fontSize,
          fontWeight: textTheme.bodyText1!.fontWeight,
        ),
        fillColor: fillColor ?? textFieldFillColor,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        focusedBorder: border ?? outlineBorder(width:0.4 ,color:borderColor?? textFieldBorderColor),
        errorBorder: border ?? outlineBorder(color:borderColor?? Colors.red),
        enabledBorder: border ?? outlineBorder(width:0.4 ,color:borderColor?? textFieldBorderColor),
        border: border ?? outlineBorder(color:borderColor??  Colors.transparent),
        focusedErrorBorder: border ?? outlineBorder(color:borderColor??  Colors.red,width: 2)
      ),
    );
  }

  UnderlineInputBorder outlineBorder({double? width,Color? color}){
    return UnderlineInputBorder(
      borderSide: BorderSide(color: textFieldBorderColor,width: 1)
    );
  }
}

class CustomTextFieldSelector extends StatelessWidget {
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;

  int? maxLines = 1;
  bool? obsecureText = false;

  String? Function(String?)? validator;
  TextInputAction? textInputAction = TextInputAction.next;
  TextInputType? textInputType = TextInputType.text;
  Widget? prefix;
  Widget? suffix;
  ValueChanged<String>? onFieldSubmitted;
  bool? readOnly;
  GestureTapCallback? onTap;
  Color? borderColor;
  List<TextInputFormatter>? inputFormatters;
  Color? fillColor;
  TextStyle? hintStyle;
  int? maxLength;
  InputBorder? border;
  Function(String)? onChanged;
  Key? formKey;

  CustomTextFieldSelector(
      {Key? key,
      this.formKey,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.hintStyle,
      this.hintText,
      this.maxLines,
      this.inputFormatters,
      this.obsecureText,
      this.validator,
      this.readOnly,
      this.onTap,
      this.borderColor,
      this.fillColor,
      this.prefix,
      this.border,
      this.suffix,this.textInputAction,this.textInputType,this.onFieldSubmitted,this.maxLength
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child: TextFormField(
        key: formKey,
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        readOnly: readOnly ?? false,
        validator: validator,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        obscureText: obsecureText ?? false,
        obscuringCharacter: "*",
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
            color: blackColor,
            fontSize: 14,
            fontWeight: FontWeight.w400
        ),
        decoration: InputDecoration(
          // floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          isDense: true,
          // labelText: hintText,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
              color: hintTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          helperStyle: TextStyle(
            color: Colors.grey,
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight,
          ),
          errorMaxLines: 3,
          suffixIconConstraints: const BoxConstraints(minWidth: 30),
          labelStyle: TextStyle(
              color: hintTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400
          ),
          prefixStyle: TextStyle(
            color: Colors.grey,
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight,
          ),
          fillColor: fillColor ?? textFieldFillColor,
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          focusedBorder: border ?? outlineBorder(width:0.4 ,color:borderColor?? textFieldBorderColor),
          errorBorder: border ?? outlineBorder(color:borderColor?? Colors.red),
          enabledBorder: border ?? outlineBorder(width:0.4 ,color:borderColor?? textFieldBorderColor),
          border: border ?? outlineBorder(color:borderColor??  Colors.transparent),
          focusedErrorBorder: border ?? outlineBorder(color:borderColor??  Colors.red,width: 2)
        ),
      ),
    );
  }

  UnderlineInputBorder outlineBorder({double? width,Color? color}){
    return UnderlineInputBorder(
      borderSide: BorderSide(color: textFieldBorderColor,width: 1)
    );
  }
}

class CustomTextFieldV2 extends StatelessWidget {
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;
  int? maxLines = 1;
  bool? obsecureText = false;
  String? Function(String?)? validator;
  TextInputAction? textInputAction = TextInputAction.next;
  TextInputType? textInputType = TextInputType.text;
  Widget? prefix;
  Widget? suffixWidget;
  Widget? prefixWidget;
  String? prefixText;
  Widget? suffix;
  List<TextInputFormatter>? inputFormatters;
  ValueChanged<String>? onFieldSubmitted;
  bool? readOnly;
  GestureTapCallback? onTap;
  Color? borderColor;
  Color? fillColor;
  TextStyle? hintStyle;
  int? maxLength;
  InputBorder? border;
  Function(String)? onChanged;

  CustomTextFieldV2(
      {Key? key,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.hintStyle,
      this.prefixText,
      this.hintText,
      this.maxLines,
      this.obsecureText,
      this.validator,
      this.suffixWidget,
      this.readOnly,
      this.inputFormatters,
      this.onTap,
      this.prefixWidget,
      this.borderColor,
      this.fillColor,
      this.prefix,
      this.border,
      this.suffix,this.textInputAction,this.textInputType,this.onFieldSubmitted,this.maxLength
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      readOnly: readOnly ?? false,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      obscureText: obsecureText ?? false,
      obscuringCharacter: "*",
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: blackColor,
          fontSize: 14,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(

        contentPadding: const EdgeInsets.symmetric(vertical: 4.0,),
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(
            color: hintTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        helperStyle: TextStyle(
          color: Colors.grey,
          fontSize: textTheme.bodyText1!.fontSize,
          fontWeight: textTheme.bodyText1!.fontWeight,
        ),
        errorMaxLines: 3,
        labelStyle: TextStyle(
            color: hintTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400
        ),
        prefixStyle: TextStyle(
          color: Colors.red,
          fontSize: textTheme.bodyText1!.fontSize,
          fontWeight: textTheme.bodyText1!.fontWeight,
        ),
        fillColor: Colors.transparent,
        prefixIcon: prefix,
        prefix: prefixWidget,
        prefixText: prefixText,
        suffixIcon: suffix,
        prefixIconConstraints: BoxConstraints.loose(const Size(20,20)),
        suffix: suffixWidget,
        suffixIconConstraints: BoxConstraints.loose(const Size(20,20)),
        filled: true,
        focusedBorder: border ?? InputBorder.none,
        errorBorder: border ?? InputBorder.none,
        enabledBorder: border ?? InputBorder.none,
        border: border ?? InputBorder.none,
        focusedErrorBorder: border ?? InputBorder.none
      ),
    );
  }
}

class CustomTextFieldV3 extends StatelessWidget {
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;

  int? maxLines = 1;
  bool? obsecureText = false;

  String? Function(String?)? validator;
  TextInputAction? textInputAction = TextInputAction.next;
  TextInputType? textInputType = TextInputType.text;
  Widget? prefix;
  Widget? suffix;
  ValueChanged<String>? onFieldSubmitted;
  bool? readOnly;
  GestureTapCallback? onTap;
  Color? borderColor;
  Color? fillColor;
  TextStyle? hintStyle;
  int? maxLength;
  InputBorder? border;

  Function(String)? onChanged;

  CustomTextFieldV3(
      {Key? key,
        this.controller,
        this.onChanged,
        this.focusNode,
        this.hintStyle,
        this.hintText,
        this.maxLines,
        this.obsecureText,
        this.validator,
        this.readOnly,
        this.onTap,
        this.borderColor,
        this.fillColor,
        this.prefix,
        this.border,
        this.suffix,this.textInputAction,this.textInputType,this.onFieldSubmitted,this.maxLength
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap:onTap ,
      readOnly: readOnly??false,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      obscureText: obsecureText ?? false,
      obscuringCharacter: "*",
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.center,
      autovalidateMode: AutovalidateMode.disabled,
      style: TextStyle(
          color: blackColor,
          fontSize: 14,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 20.0),
          isDense: true,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
              color: hintTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
          helperStyle: TextStyle(
            color: Colors.grey,
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight,
          ),
          errorMaxLines: 3,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight,
          ),
          prefixStyle: TextStyle(
            color: Colors.grey,
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight,
          ),
          fillColor: Colors.white,
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          focusedBorder: border ?? outlineBorder(width:1 ,color:borderColor?? textFieldBorderColor),
          errorBorder: border ?? outlineBorder(color:borderColor?? Colors.red),
          enabledBorder: border ?? outlineBorder(width:1 ,color:borderColor?? textFieldBorderColor),
          border: border ?? outlineBorder(color:borderColor??  Colors.transparent),
          focusedErrorBorder: border ?? outlineBorder(color:borderColor??  Colors.red,width: 2)
      ),
    );
  }

  OutlineInputBorder outlineBorder({double? width,Color? color}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: color?? textFieldBorderColor, width: width ?? 1.0),
    );
  }
}