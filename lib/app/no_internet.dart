import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/app/registration/registration.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatefulWidget {
  final bool isRegistered;

  const NoInternetPage({required this.isRegistered, super.key});

  @override
  State<StatefulWidget> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: const Image(
                image: AssetImage("assets/Settings/NoInternet.png"),
                width: 150,
                height: 150,
              ),
            ),
            const Text(
              "Ինտերնետ կապը բացակայում է",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xff164866)),
            ),
            tryAgainButton()
          ],
        ),
      ),
    );
  }

  Widget tryAgainButton() {
    return InkWell(
      onTap: () {
        if (widget.isRegistered) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(
                        isRedirect: false,
                      )));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Registration()));
        }
      },
      child: Container(
        width: double.infinity,
        height: 42,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
        decoration: const BoxDecoration(
          color: Color(0xff164866),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Թարմացնել",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xffFFFFFF)),
        ),
      ),
    );
  }
}
