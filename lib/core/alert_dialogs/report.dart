import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showReportDialog(BuildContext context, int recieverId, {VoidCallback? onApprove}) {
  TextEditingController controller = TextEditingController();

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage("assets/Settings/Report.png"),
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Դժգոհել",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Color(0xff164866)),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 137,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    color: const Color(0xffF3F4F6)),
                child: TextField(
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    color: Color(0XFF164866),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: null,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                      hintText: 'Ներկայացնել խնդիրը',
                      hintStyle: TextStyle(
                        color: Color(0XFFE2E2E2),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  Dio dio = Dio();

                  var body = {
                    "reciverId": recieverId,
                    "complaint": controller.text
                  };

                  var prefs = await SharedPreferences.getInstance();

                  await dio.post(
                      "https://autozone.onepay.am/api/v1/users/sendComplaint",
                      data: body,
                      options: Options(
                        headers: {
                          "Authorization": "Bearer ${prefs.getString("token")}"
                        },
                      ));

                  Navigator.pop(context);

                  if(onApprove != null) {
                    onApprove();
                  }
                },
                child: Container(
                  width: 135,
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff007200)),
                  alignment: Alignment.center,
                  child: const Text(
                    "Ուղարկել",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      });
}
