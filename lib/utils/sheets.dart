import 'package:flutter/material.dart';

class Sheets{

  static void showBottomModalSheet(context, List<Widget> list) {
    {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )
          ),
          context: context,
          builder: (context){
            // совместно с isScrollControlled позволяет контролировать высотку ботом шита
            return SafeArea(
              child: Wrap(
                children: list,
              ),
            );
          });
    }
  }
}