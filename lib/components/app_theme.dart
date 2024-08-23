import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimens.dart';
import 'font_family.dart';

s
ThemeData themeData =  ThemeData(
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
  // textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.black),),
  brightness: Brightness.light,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  bottomAppBarColor: Colors.white,
  backgroundColor: Colors.white,
  fontFamily: FontFamily.openSans,
  dialogBackgroundColor:Colors.white ,
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: COLOR_white,
    iconTheme: IconThemeData(
      color:blackColor
    ),
    titleTextStyle: TextStyle(color: blackSimilar ,fontSize: 20, fontWeight: FontWeight.w900),
    elevation: 0,
  ),
  datePickerTheme:  DatePickerThemeData(
       headerBackgroundColor: primaryColor ,
      headerForegroundColor: Colors.white,
      backgroundColor: Colors.white,
      cancelButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Colors.black; // Set your desired color here
        },
      ),),
    confirmButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        return Colors.black; // Set your desired color here
      },
    ),)
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: outlineBorder(),
      enabledBorder: outlineBorder(),
      focusedBorder: outlineBorder(),
      errorBorder: outlineBorder(),
      disabledBorder: outlineBorder(),
      focusedErrorBorder: outlineBorder(),
      labelStyle: const TextStyle(color: COLOR_lightGray, fontSize: 16.0, fontWeight: FontWeight.w400)),
);
ThemeData themeDark =  ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  bottomAppBarColor: Colors.black,
  backgroundColor: Colors.black,
  fontFamily: FontFamily.openSans,
  datePickerTheme:  DatePickerThemeData(
      cancelButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Colors.black; // Set your desired color here
        },
      ),),
      confirmButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Colors.black; // Set your desired color here
        },
      ),)
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: blackColor,
    iconTheme: IconThemeData(
        color:blackColor

    ),
     titleTextStyle: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w900),

    elevation: 0,
  ),
  textTheme: TextTheme(
       button: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),

      caption: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),

    headline1: const TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
    headline2: const TextStyle(
        color: Colors.white,fontSize: 20, fontWeight: FontWeight.w900),
    headline3: const TextStyle(
        color: Colors.white,fontSize: 18, fontWeight: FontWeight.w900),
    headline4: TextStyle(
        color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w900),
    headline5: TextStyle(
        color: blackColor, fontSize: 16, fontWeight: FontWeight.w800),
    headline6: TextStyle(
        color: blackColor,fontSize: 20, fontWeight: FontWeight.w900),
    bodyText1: const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
    bodyText2: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
        fontWeight: FontWeight.w400),
    overline: TextStyle(color: Colors.black),
    subtitle1: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
    ),
    subtitle2: TextStyle(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: COLOR_middleBlueM),

  inputDecorationTheme: InputDecorationTheme(
      border: outlineBorder(),
      enabledBorder: outlineBorder(),
      focusedBorder: outlineBorder(),
      errorBorder: outlineBorder(),
      disabledBorder: outlineBorder(),
      focusedErrorBorder: outlineBorder(),
      labelStyle: const TextStyle(
          color: COLOR_lightGray, fontSize: 16.0, fontWeight: FontWeight.w400)),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: FONT_14, fontWeight: FontWeight.w600)),
      backgroundColor: MaterialStateProperty.all<Color>(COLOR_white),
      foregroundColor: MaterialStateProperty.all<Color>(appColor),
      overlayColor: MaterialStateProperty.all<Color>(appColor.withOpacity(0.4)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: FONT_14, fontWeight: FontWeight.w600)),
      backgroundColor: MaterialStateProperty.all<Color>(appColor),
      foregroundColor: MaterialStateProperty.all<Color>(COLOR_white),
      overlayColor: MaterialStateProperty.all<Color>(appColor.withOpacity(0.4)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: FONT_14, fontWeight: FontWeight.w600)),
      foregroundColor: MaterialStateProperty.all<Color>(appColor.withOpacity(0.3)),
      overlayColor: MaterialStateProperty.all<Color>(appColor),
    ),
  ),
);

OutlineInputBorder outlineBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        width: 1,
        color: COLOR_lightGray.withOpacity(0.5),
      ),
    );
