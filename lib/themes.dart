import 'package:flutter/material.dart';
import 'package:unsplash_gallery/res/colors.dart';

final kLightTheme = ThemeData.light().copyWith(
  primaryColor: AppColors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.manatee,
    elevation: 0,
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontFamily: 'Roboto',
        fontSize: 17),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: const ButtonStyle().copyWith(
    backgroundColor: MaterialStateProperty.all<Color>(AppColors.dodgerBlue),
  )),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
  ),
  iconTheme: const IconThemeData().copyWith(color: AppColors.black),
);

final kDarkTheme = ThemeData.dark().copyWith(
  primaryColor: AppColors.white,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          fontFamily: 'Roboto',
          fontSize: 17)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.black,
  ),
  iconTheme: const IconThemeData().copyWith(color: AppColors.white),
);
