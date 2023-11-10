import 'package:flutter/material.dart';

void infoTex(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          insetPadding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Վճարման հաստատումից հետո վճարման տեղեկատվությունը ավտոմատ փոխանցվում է սպասարկող (ընտրված) տեխզննման կայանին։ Վճարման անդորրագիր ներկայացնելու անհրաժեշտություն չկա։",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866)
                  ),
                ),
              ),
               SizedBox(height: 20,),
            ],
          ),
        );
      });
}
