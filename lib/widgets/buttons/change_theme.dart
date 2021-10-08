import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  bool _isSwitch = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Icon(_isSwitch ? Icons.lightbulb : Icons.lightbulb_outline),
        onTap: () {
          _isSwitch = !_isSwitch;
          setState(() {
            switch (_isSwitch) {
              case true:
                AdaptiveTheme.of(context).setLight();
                break;
              case false:
                AdaptiveTheme.of(context).setDark();
                break;
              default:
                AdaptiveTheme.of(context).setSystem();
            }
          });
        },
      );

  // Transform.scale(
  //   scale: 0.7,
  //   child: Row(children: [
  //     const Icon(Icons.dark_mode),
  //     CupertinoSwitch(
  //       value: _isSwitch,
  //       onChanged: (bool value) {
  //         setState(() {
  //           _isSwitch = value;
  //           switch (value) {
  //             case true:
  //               AdaptiveTheme.of(context).setLight();
  //               break;
  //             case false:
  //               AdaptiveTheme.of(context).setDark();
  //               break;
  //             default:
  //               AdaptiveTheme.of(context).setSystem();
  //           }
  //         });
  //       },
  //     ),
  //     const Icon(Icons.wb_sunny),
  //   ]),
  // );

  void init() async {
    AdaptiveThemeMode? checkTheme = await AdaptiveTheme.getThemeMode();
    setState(() {
      _isSwitch = checkTheme?.index == 0 ? true : false;
    });
  }
}
