import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:flutter/material.dart';

class DahkPage extends StatefulWidget {
  final bool dahk;

  const DahkPage({Key? key, required this.dahk}) : super(key: key);

  @override
  createState() => _DahkPage();
}

class _DahkPage extends State<DahkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey[100],
              height: 1.0,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 2),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Image(
                image: AssetImage("assets/Settings/BackIcon.png"),
                width: 21,
                height: 21,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xff164866)),
          title: const Text(
            'ԴԱՀԿ հետախուզում',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Container(
            color: const Color(0xffF3F4F6),
            height: 104,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.dahk ? 'Առկա է' : 'Առկա չէ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 13),
                  child: InkWell(
                    onTap: () async {
                      loading(context);

                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.pop(context);
                    },
                    child: const Image(
                      image: AssetImage("assets/Settings/Refresh.png"),
                      height: 13,
                      width: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
