import 'package:auto_size_text/auto_size_text.dart';
import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeptPage extends StatefulWidget {
  final int dept;
  final String selectedTexInfo;

  const DeptPage({Key? key, required this.dept, required this.selectedTexInfo})
      : super(key: key);

  @override
  createState() => _DeptPage();
}

class _DeptPage extends State<DeptPage> {
  void updateDeptData() async {
    loading(context);

    var prefs = await SharedPreferences.getInstance();

    var phone = prefs.getString('phone');

    var body = {
      "techNumber": widget.selectedTexInfo,
      "phoneNumber": "374$phone"
    };

    Dio dio = Dio();

    var result = await dio.post(
        "https://autozone.onepay.am/api/v1/users/GetDEBTInfo",
        data: body,
        options: Options(validateStatus: (status) => true));

    Navigator.pop(context);

    setState(() {
      dept = result.data['debt'];
    });
  }

  int dept = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      dept = widget.dept;
    });
  }

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
            'Գույքահարկ',
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
            child: dept != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        dept != 0
                            ? "${dept.toString()} դրամ"
                            : "Գույքահարկի պարտավորություն չունեք",
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
                            updateDeptData();
                          },
                          child: const Image(
                            image: AssetImage("assets/Settings/Refresh.png"),
                            height: 13,
                            width: 13,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        dept != 0
                            ? "${dept.toString()} դրամ"
                            : "Գույքահարկի պարտավորություն չունեք",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xff164866),
                        ),
                      ),
                    ),
                  ),
          ),
        ));
  }
}
