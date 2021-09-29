import 'package:flutter/material.dart';
class Overlays {


  static void showOverlay(BuildContext context, message) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context)=> Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50,
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,  // получаем width всего экрана
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              color: ThemeData.dark().primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message), // если что, добавить примари колор
          ),
        ),
      ),
    ),
    );
    overlayState!.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 2));
    overlayEntry.remove();
  }
}