import 'package:flutter/material.dart';
import 'package:unsplash_gallery/res/colors.dart';

final kLightTheme = ThemeData.light().copyWith(
  secondaryHeaderColor: AppColors.white,
  canvasColor: AppColors.white,
  tabBarTheme: const TabBarTheme().copyWith(
    labelColor: Colors.black,
    unselectedLabelColor: AppColors.grayChateau,
  ),
  scaffoldBackgroundColor: Colors.white,
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
    unselectedItemColor: AppColors.grayChateau,
    backgroundColor: AppColors.white,
  ),
  iconTheme: const IconThemeData().copyWith(color: AppColors.black),
);

final kDarkTheme = ThemeData.dark().copyWith(

  secondaryHeaderColor: AppColors.deepGray,
  tabBarTheme: const TabBarTheme().copyWith(labelColor: AppColors.white,
    unselectedLabelColor: AppColors.grayChateau //Colors.white30,
  ),
  primaryColor: AppColors.white,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          fontFamily: 'Roboto',
          fontSize: 17)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: AppColors.white,
    backgroundColor: AppColors.black,
  ),
  iconTheme: const IconThemeData().copyWith(color: AppColors.white),
);
