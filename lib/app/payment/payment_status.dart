import 'package:autozone/app/payment/payment.dart';
import 'package:flutter/material.dart';

class PaymentStatusPage extends StatefulWidget {
  final String stationName;
  final String stationAddress;
  final List<String> payments;
  final List<dynamic> payinfo;

  const PaymentStatusPage(
      {required this.stationName,
      required this.stationAddress,
      required this.payments,
      required this.payinfo,
      super.key});

  @override
  State<StatefulWidget> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatusPage> {
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
        backgroundColor: Colors.white,
        elevation: 0,
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
        title: Text(
          "Վճարման տեղեկատվություն",
          style: basicStyle(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 57,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xffECECEC), width: 1))),
              alignment: Alignment.centerLeft,
              child: Text(
                "Տեխզննման կայան՝ ${widget.stationName}",
                style: basicStyle(),
              ),
            ),
            Container(
              width: double.infinity,
              height: 57,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xffECECEC), width: 1))),
              child: Text(
                "Հասցե՝ ${widget.stationAddress}",
                style: basicStyle(),
              ),
            ),
            for (int i = 0; i < widget.payments.length; i++)
              Container(
                width: double.infinity,
                height: 57,
                decoration: const BoxDecoration(
                  color: Color(0xffF3F4F6),
                  border: Border(
                      bottom: BorderSide(color: Color(0xffECECEC), width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, top: 10, bottom: 10, right: 20),
                      child: Text(
                        reformatText(widget.payments[i]),
                        style: basicStyle(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 27),
                      child: InkWell(
                        onTap: () {
                          var it = widget.payinfo[i]["items"].firstWhere(
                              (item) =>
                                  item["service"]["name"] ==
                                  widget.payments[i]);

                          var info = {
                            "name": it["service"]["name"],
                            "value": it["amount"].toString()
                          };

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentInfo(
                                        date: widget.payinfo[i]["created_at"],
                                        autoMark: widget.payinfo[i]["request"]
                                            ["car"],
                                        autoNumber: widget.payinfo[i]["request"]
                                            ["car_reg_no"],
                                        items: info,
                                        mijnordavchar: "300",
                                        name: widget.payinfo[i]["name"],
                                      )));
                        },
                        child: const Image(
                          image: AssetImage("assets/Settings/Check.png"),
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  TextStyle basicStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 15,
      color: Color(0xff164866),
    );
  }

  String reformatText(String text) {
    if (text == "CO") {
      return "Բնապահպանական հարկ ( CO)";
    }

    return "Տեխզննում";
  }
}
