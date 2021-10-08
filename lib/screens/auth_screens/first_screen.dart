import 'package:flutter/material.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/screens/home.dart';
import 'package:unsplash_gallery/screens/auth_screens/webview_page.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String trigger = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mainTitle),
        centerTitle: true,
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                onPressed: () => doLogin(context),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 125),
              child: TextField(
                obscureText: true,
                focusNode: FocusNode(),
                decoration: InputDecoration(
                  suffixIcon: isChecked(),
                  icon: const Icon(Icons.developer_mode),
                    hintText: 'developer helper'),
                onChanged: (value) => setState(() {
                  trigger = value;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget isChecked(){
    switch(trigger)
    {
      case 'tornado': return const Icon(Icons.done, color: Colors.green,);
      case '': return const Icon(Icons.error_outline);
      default: return const Icon(Icons.error_outline, color: Colors.red,);
    }
  }

  void doLogin(BuildContext context) {
    if (DataProvider.authToken == "" || trigger != 'tornado') {
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
