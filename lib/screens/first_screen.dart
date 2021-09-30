import 'package:flutter/material.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/screens/home.dart';
import 'package:unsplash_gallery/screens/webview_page.dart';
import 'package:unsplash_gallery/widgets/buttons/change_theme.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);


  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mainTitle), centerTitle: true,
        actions: const [
          ChangeTheme()
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).authorization,
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                child: Text(S.of(context).logIn),
                style: ElevatedButton.styleFrom(primary: Colors.blue, onPrimary: Colors.white,),
                onPressed: () => doLogin(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doLogin(BuildContext context) {
    if (DataProvider.authToken == "") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WebViewPage()),
      ).then((value) {
        RegExp exp = RegExp("(?<==).*");
        var oneTimeCode = exp.stringMatch(value);

        DataProvider.doLogin(oneTimeCode: oneTimeCode).then((value) {
          DataProvider.authToken = value.accessToken!;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    }
  }
}
