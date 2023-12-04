import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void tm_type_car_update(
    BuildContext context,
    String? autoMark,
    String? autoNumber,
    List<dynamic> typeList,
    String techNumber,
    String? pin,
    String _selected,
    VoidCallback after) {
  int selected = typeList.indexWhere((element) => element["id"] == _selected);
  var autoService = ServiceProvider.required<IAuto>();
  var registrationService = ServiceProvider.required<IRegistration>();

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: StatefulBuilder(builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(right: 47, left: 46),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 38, top: 12),
                    child: const Text(
                      "Ընտրեք տ/մ տեսակը",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffC32024)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 26),
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "${autoMark!.split(" ")[0].toString() ?? 'No data'}   |   ${autoNumber ?? 'No data'}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff164866)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < typeList.length; i++)
                        button(
                            double.infinity,
                            35,
                            const EdgeInsets.all(5),
                            selected == i
                                ? const Color(0xff007200)
                                : const Color(0xffF3F4F6),
                            selected == i
                                ? Colors.white
                                : const Color(0xff164866), () {
                          state(() {
                            selected = i;
                          });
                        }, typeList[i]["name"])
                    ],
                  ),
                  const SizedBox(height: 20),
                  ButtonFactory.createButton(
                      "cta_green",
                      "Հաստատել",
                      selected >= 0
                          ? () async {
                              var prefs = await SharedPreferences.getInstance();

                              await registrationService.verifyUser(
                                  prefs.getString('phone') ?? '',
                                  prefs.getString('pin') ?? '');

                              Dio dio = Dio();

                              var body = {
                                "techNumber": techNumber,
                                "name": typeList[selected]["name"],
                                "id": typeList[selected]["id"]
                              };

                              await dio.patch(
                                  "https://autozone.onepay.am/api/v1/cars/updateCarVehicleType",
                                  data: body);

                              Navigator.pop(context);

                              after();
                            }
                          : null,
                      double.infinity,
                      35,
                      margin: const EdgeInsets.only(top: 10, bottom: 30))
                ],
              ),
            );
          }),
        );
      });
}

Widget button(double width, double height, EdgeInsetsGeometry margin,
    Color color, Color fore, VoidCallback onPressed, String text) {
  return Container(
    width: width,
    height: height,
    margin: const EdgeInsets.only(bottom: 25),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: fore,
        disabledBackgroundColor: const Color(0xffF3F4F6),
        disabledForegroundColor: const Color(0xffCCCCCC),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    ),
  );
}
