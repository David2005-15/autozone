import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:autozone/core/alert_dialogs/car_is_not_available.dart';
import 'package:shared_preferences/shared_preferences.dart';

void car_found(BuildContext context, String? autoMark, String? autoNumber,
    String techNumber, String? pin) {
  var autoService = ServiceProvider.required<IAuto>();
  var registrationService = ServiceProvider.required<IRegistration>();

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: 220,
            alignment: Alignment.center,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xff164866),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 63,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(width: 50,),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "${autoMark ?? 'No data'}   |   ${autoNumber ?? 'No data'}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff164866)),
                      ),
                    ),
                    // const SizedBox(width: 30,),
                    // FittedBox(
                    //   fit: BoxFit.contain,
                    //   child: Text(
                    //     autoNumber ?? 'No Data',
                    //     style: const TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color(0xff164866)),
                    //   ),
                    // ),
                    // SizedBox(width: 50,)
                  ],
                ),
                ButtonFactory.createButton("cta_green", "Հաստատել", () async {
                  var prefs = await SharedPreferences.getInstance();

                  await registrationService.verifyUser(
                      prefs.getString('phone') ?? '',
                      prefs.getString("pin") ?? '');

                  await autoService.applyAddedAuto(techNumber).then((value) {
                    Navigator.pop(context);

                    if (value.isEmpty) {
                      car_is_not_available(context, techNumber);
                      return;
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage(
                                    isRedirect: false,
                                  )));
                    }
                  });
                }, double.infinity, 35,
                    margin: const EdgeInsets.only(right: 47, left: 47, top: 44))
              ],
            ),
          ),
        );
      });
}
