import 'dart:async';

import 'package:autozone/app/add_new_car/new_car_page.dart';
import 'package:autozone/app/home/appa_page.dart';
import 'package:autozone/app/home/search_car.dart';
import 'package:autozone/app/home/settings/add_new_car.dart';
import 'package:autozone/app/home/texzznum.dart';
import 'package:autozone/app/home/user_settings.dart';
import 'package:autozone/app/no_internet.dart';
import 'package:autozone/core/alert_dialogs/inspection_day.dart';
import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:autozone/core/alert_dialogs/new_app_version.dart';
import 'package:autozone/core/alert_dialogs/report.dart';
import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/message_answer_factory.dart';
import 'package:autozone/core/widgets/app_bar.dart';
import 'package:autozone/core/widgets/home_page_widgets/home_page_auto_mark_tile.dart';
import 'package:autozone/core/widgets/home_page_widgets/home_page_control_tile.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/firebase_dynamic_link.dart';
import 'package:autozone/utils/firebase_app.dart';
import 'package:autozone/utils/image_cache.dart';
import 'package:autozone/utils/location_cache_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autozone/app/registration/registration.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final bool isRedirect;

  const HomePage({super.key, required this.isRedirect});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> autos = [];
  List<String> autoImagePath = [];
  List<DateTime> autoInspectionDates = [];
  List<String> autiInspectionCompanies = [];
  List<DateTime> autoTexDates = [];
  List<String> currentAutoNumbers = [];

  Dio dio = Dio();
  int _selected = 0;
  int _navigationBarPage = 0;
  String selectedTechNumber = "";
  String selectedAutoNumber = "";
  int userId = 0;
  DatabaseReference? database;

  String name = "";
  String email = "";
  String phoneNumber = "";

  int notificationCount = 0;
  bool doHaveCar = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  LocationsCacheManager manager = LocationsCacheManager();
  ImageCacheManager imageCache = ImageCacheManager();

  Future<void> initConnectivity() async {
    ConnectivityResult status;
    try {
      status = await _connectivity.checkConnectivity();
    } catch (e) {
      return;
    }

    return _updateConnectionStatus(status);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const NoInternetPage(
                  isRegistered: true,
                )),
      );
    }
  }

  void checkDate() async {
    var prefs = await SharedPreferences.getInstance();

    String? date = prefs.getString("today");

    if (date == null) {
      prefs.setString("today", DateTime.now().toIso8601String());
      prefs.setInt("count", 0);
    } else {
      DateTime lastDate = DateTime.parse(date);

      if (lastDate.day == DateTime.now().day - 1) {
        prefs.setString("today", DateTime.now().toIso8601String());
        prefs.setInt("count", 0);
      }
    }
  }

  @override
  void initState() {
    checkDate();
    // Future.delayed(Duration(seconds: 2), () {updateDialog(context);});
    // updateDialog(context);

    FirebaseDynamicLink.initDynamicLink(context);

    manager.setProvince();
    imageCache.getUserImage();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    var auto = getAutoList();

    var init = initFirebaseApp();
    var setToken = setDeviceToken();

    Future.wait([auto]).then((value) {
      Future.delayed(const Duration(seconds: 2), () async {
        await checkInspectionDate(autoTexDates, currentAutoNumbers);
      });
    });

    Future.wait([init, setToken]).then((value) {
      database!.child("messages").onChildAdded.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        Map<dynamic, dynamic> value = snapshot.value as Map;

        // print(value["active"] as bool);

        if (value["issued_user_id"] as int == userId &&
            value["answer"] == "" &&
            value["active"] as bool == true) {
          sendMessage(value["requested_user_id"] as int, "AutoZone",
              "${value["car_number"]} մեքենայի վարորդը դիտել է Ձեր հաղորդագրությունը։");

          Future.delayed(const Duration(seconds: 1), () async {
            MessageAnswerFactory.getMessage(
                snapshot: snapshot,
                key: snapshot.key!,
                id: value["issued_user_id"] as int,
                type: value["issue_type"] as String,
                context: context,
                number: value["car_number"],
                onReport: (id) {
                  showReportDialog(context, id, onApprove: () {
                    success(context, "Հաղորդագրությունն\nուղարկված է");
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  });
                },
                onClose: () {
                  Navigator.pop(context);

                  snapshot.ref.update({
                    "${snapshot.key}/answer": "Չեմ կարող մոտենալ",
                    "${snapshot.key}/answer_date": DateTime.now().toString()
                  });
                  // snapshot.ref.update({
                  //   "${snapshot.key}/answer_date": DateTime.now().toString()
                  // });

                  sendMessage(value["requested_user_id"] as int, "AutoZone",
                      "Չեմ կարող մոտենալ");

                  success(context, "Հաղորդագրությունն\nուղարկված է");
                },
                onApprove: () {
                  Navigator.pop(context);

                  if (value["issue_type"] == "car_number") {
                    String answer =
                        "Խնդրում եմ զանգահարել 0${value["phoneNumber"]} հեռախոսահամարին:";

                    snapshot.ref.update({
                      "${snapshot.key}/answer": answer,
                      "${snapshot.key}/answer_date": DateTime.now().toString()
                    });
                    // snapshot.ref.update({
                    //   "${snapshot.key}/answer_date": DateTime.now().toString()
                    // });

                    sendMessage(value["requested_user_id"] as int, "AutoZone",
                        "Խնդրում եմ զանգահարել 0${value["phoneNumber"]} հեռախոսահամարին:");
                  } else {
                    if (value["issue_type"] == "open_door" ||
                        value["issue_type"] == "light_is_on") {
                      snapshot.ref.update({
                        "${snapshot.key}/answer": "Շնորհակալություն",
                        "${snapshot.key}/answer_date": DateTime.now().toString()
                      });

                      sendMessage(value["requested_user_id"] as int, "AutoZone",
                        "Շնորհակալություն");
                    } else {
                      snapshot.ref.update({
                        "${snapshot.key}/answer": "Շուտով կմոտենամ",
                        "${snapshot.key}/answer_date": DateTime.now().toString()
                      });

                      sendMessage(value["requested_user_id"] as int, "AutoZone",
                        "Շուտով կմոտենամ");
                    }
                    // snapshot.ref.update({
                    //   "${snapshot.key}/answer_date": DateTime.now().toString()
                    // });

                    // sendMessage(value["requested_user_id"] as int, "AutoZone",
                    //     "Շուտով կմոտենամ");
                  }

                  success(context, "Հաղորդագրությունն\nուղարկված է");
                },
                onNumberApprove: (String number) {
                  Navigator.pop(context);

                  if (value["issue_type"] == "car_number") {
                    String answer =
                        "Խնդրում եմ զանգահարել 0$number հեռախոսահամարին:";

                    snapshot.ref.update({
                      "${snapshot.key}/answer": answer,
                      "${snapshot.key}/answer_date": DateTime.now().toString()
                    });
                    // // snapshot.ref.update({
                    // //   "${snapshot.key}/answer_date": DateTime.now().toString()
                    // });

                    sendMessage(value["requested_user_id"] as int, "AutoZone",
                        "Խնդրում եմ զանգահարել 0$number հեռախոսահամարին:");
                  } else {
                    snapshot.ref.update({
                      "${snapshot.key}/answer": "Շուտով կմոտենամ",
                      "${snapshot.key}/answer_date": DateTime.now().toString()
                    });
                  }

                  success(context, "Հաղորդագրությունն\nուղարկված է");
                },
                phoneNumber: value["phoneNumber"]);
          });

          snapshot.ref.update({
            "${snapshot.key}/active": false,
            "${snapshot.key}/seenDate": DateTime.now().toString()
          });
        }
      });

      database!.child("messages").onChildChanged.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        Map<dynamic, dynamic> value = snapshot.value as Map;

        if (value["requested_user_id"] as int == userId &&
            value["answer"] != "" &&
            value["phoneNumber"] != "") {
          setState(() {
            notificationCount += 1;
          });

          RegExp exp = RegExp(r'\b\d+\b');

          String updatedText =
              value["answer"].toString().replaceAllMapped(exp, (match) {
            String number = match[0]!;
            if (!number.startsWith('0')) {
              number = '0$number';
            }
            return number;
          });

          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xffF3F4F6),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Text(
                            "${value["car_number"]} վարորդի պատասխանը",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff164866),
                            ),
                          ),
                        ),
                        Text(
                          updatedText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866),
                          ),
                        ),
                        value["issue_type"].toString() == "car_number"
                            ? InkWell(
                                onTap: () async {
                                  String phoneNumber =
                                      "${value["phoneNumber"]}";

                                  // print(phoneNumber);

                                  Uri url = Uri.parse('tel:$phoneNumber');

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  width: 200,
                                  alignment: Alignment.center,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color(0xff007200)),
                                  child: const Text(
                                    "Զանգահարել",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              });
        }
      });
    });
    super.initState();
  }

  Future sendMessage(int recieverId, String title, String body) async {
    var prefs = await SharedPreferences.getInstance();
    var message = {"receiverId": recieverId, "title": title, "body": body};

    Dio dio = Dio();

    await dio.post(
      "https://autozone.onepay.am/api/v1/notifications/send",
      data: message,
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }

  Future initFirebaseApp() async {
    setState(() {
      database = FirebaseDatabase.instance.ref();
    });
  }

  Future setDeviceToken() async {
    await AutozoneFirebaseApp.getInstance();

    var fcmToken = await FirebaseMessaging.instance.getToken();

    var prefs = await SharedPreferences.getInstance();

    Dio dio = Dio();

    var body = {
      "deviceToken": fcmToken,
    };

    await dio.patch("https://autozone.onepay.am/api/v1/users/updateDeviceToken",
        data: body,
        options: Options(
          headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
          validateStatus: (status) {
            return true;
          },
        ));
  }

  GlobalKey<SearchCarPageState> searchCarPageKey = GlobalKey();

  PreferredSize buildUserSettingsAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 2),
          child: InkWell(
            onTap: () {
              setState(() {
                _navigationBarPage = 0;
              });
            },
            child: const Image(
              image: AssetImage("assets/Settings/BackIcon.png"),
              width: 21,
              height: 21,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: () async {
                  var prefs = await SharedPreferences.getInstance();

                  await prefs.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Registration()));
                },
                child: const Image(
                  image: AssetImage("assets/Settings/Leave.png"),
                  width: 24,
                  height: 24,
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          _navigationBarPage = 0;
        });

        return Future.value(false);
      },
      child: Scaffold(
          appBar: _navigationBarPage == 2
              ? buildUserSettingsAppBar()
              : PreferredSize(
                  preferredSize: const Size.fromHeight(45.0),
                  child: AutozoneAppBar(
                    userId: userId,
                    dahk: dahkInfo,
                    notificationCount: notificationCount,
                    onLogo: () {},
                    onNotification: () {
                      setState(() {
                        notificationCount = 0;
                      });
                    },
                  ),
                ),
          bottomNavigationBar: Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xffF3F4F6),
              showSelectedLabels: false,
              elevation: 0,
              showUnselectedLabels: false,
              onTap: (index) {
                if (index == 0 && _navigationBarPage != 0) {
                  if (widget.isRedirect == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(isRedirect: false)));
                  }

                  getAutoList();
                }

                if (index == 1 && _navigationBarPage == 1) {
                  searchCarPageKey.currentState!.resetState();
                }

                setState(() {
                  _navigationBarPage = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Container(
                      height: 55,
                      // margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Container(
                              width: 50,
                              height: 42,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const ImageIcon(
                                AssetImage(
                                    "assets/Navigation/NavigationBarAuto.png"),
                                color: Color(0xff164866),
                              )),
                          _navigationBarPage == 0
                              ? Container(
                                  width: 50,
                                  height: 5,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 5,
                                )
                        ],
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Container(
                      height: 55,
                      // margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Container(
                              width: 50,
                              height: 42,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const ImageIcon(
                                AssetImage(
                                    "assets/Navigation/NavigationBarSearch.png"),
                                color: Color(0xff164866),
                              )),
                          _navigationBarPage == 1
                              ? Container(
                                  width: 50,
                                  height: 5,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 5,
                                )
                        ],
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 50,
                          height: 42,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const ImageIcon(
                            AssetImage(
                                "assets/Navigation/NavigationBarSettings.png"),
                            color: Color(0xff164866),
                          )),
                      _navigationBarPage == 2
                          ? Container(
                              width: 50,
                              height: 5,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 5,
                            )
                    ],
                  ),
                  label: "",
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: _navigationBarPage == 0
              ? widget.isRedirect || !doHaveCar
                  ? const NewCarPage()
                  : Container(
                      color: const Color(0xffFCFCFC),
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildAutoMarkTileRow(),
                            HomePageControlTile(
                              title: "Տեխզննում",
                              date: autoTexDates.isEmpty
                                  ? "${DateTime.now().month}.${DateTime.now().year}"
                                  : autoTexDates[_selected].year != 1970
                                      ? "${autoTexDates[_selected].month.toString().padLeft(2, '0')}.${autoTexDates[_selected].year}"
                                      : "-",
                              onTap: () {
                                TexPageData data = TexPageData(
                                    inspectionDate: autoTexDates[_selected],
                                    regNumber: selectedTechNumber,
                                    autoNumber: selectedAutoNumber,
                                    user_id: userId,
                                    dahk: autoDahk[_selected]);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TexPage(
                                              data: data,
                                            )));
                              },
                            ),
                            HomePageControlTile(
                              title: "ԱՊՊԱ",
                              date: autoInspectionDates.isEmpty
                                  ? "${DateTime.now().month}.${DateTime.now().year}"
                                  : autoInspectionDates[_selected].year == 1970
                                      ? "-"
                                      : "${autoInspectionDates[_selected].month.toString().padLeft(2, '0')}.${autoInspectionDates[_selected].year}",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppaPage(
                                            date:
                                                autoInspectionDates[_selected],
                                            inspectionCompany:
                                                autiInspectionCompanies[
                                                    _selected])));
                              },
                            )
                          ],
                        ),
                      ),
                    )
              : _navigationBarPage == 2
                  ? UserSettings(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber,
                      cars: [])
                  : SearchCarPage(
                      userId: userId,
                      ownCars: currentAutoNumbers,
                      key: searchCarPageKey,
                    )),
    );
  }

  Future<String> getLogoPath(String autoMark) async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final imageAssetsList = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/Logo/"))
        .toList();

    for (int i = 0; i < imageAssetsList.length; i++) {
      if (autoMark.toLowerCase().contains(imageAssetsList[i]
          .split(".")[0]
          .toLowerCase()
          .replaceAll("assets/logo/", ""))) {
        return imageAssetsList[i];
      }
    }

    return "";
  }

  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if (info.flexibleUpdateAllowed) {
          updateDialog(context, () {
            InAppUpdate.performImmediateUpdate();
          });
        }
      });
    }).catchError((e) {
      // updateDialog(context);
    });
  }

  Future getAutoList() async {
    var prefs = await SharedPreferences.getInstance();

    bool isLoading = false;

    bool isThereChange = prefs.getBool("changes") ?? false;

    if (autos.isEmpty || isThereChange) {
      prefs.setBool("changes", false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isLoading = true;
        });
        loading(context);
      });
    }

    var result =
        await dio.get("https://autozone.onepay.am/api/v1/users/getData",
            options: Options(
              headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
              validateStatus: (status) {
                return true;
              },
            ));

    if (isLoading) {
      Navigator.pop(context);
    }

    await checkForUpdate();

    setState(() {
      autos = result.data["User"]["Cars"];

      if (result.data["User"]["id"] != null) {
        userId = result.data["User"]["id"];
      }

      if (autos.isEmpty) {
        doHaveCar = false;
      } else {
        doHaveCar = true;
        name = result.data["User"]["fullName"];
        email = result.data["User"]["gmail"] ?? "";
        phoneNumber = result.data["User"]["phoneNumber"];

        selectedTechNumber = autos[0]["carTechNumber"];
        selectedAutoNumber = autos[0]["carNumber"];

        autos.forEach((element) async {
          autoImagePath.add(await getLogoPath(element["carMark"]));
          autoInspectionDates.add(DateTime.parse(element["insuranceEndDate"] ??
              DateTime(1970, 1, 1).toIso8601String()));
          autiInspectionCompanies.add(element["insuranceInfo"] ?? "-");
          if (element["inspection"] != null) {
            autoTexDates.add(DateTime.parse(element["inspection"]));
          } else {
            var texDate = DateTime(1970, 1, 1);
            autoTexDates.add(texDate);
          }
          currentAutoNumbers.add(element["carNumber"]);

          userId =
              int.parse(result.data["User"]["Cars"][0]["userId"].toString());
        });
      }
    });

    await getDahk();

    // if (isLoading) {
    //   Navigator.pop(context);
    // }
  }

  List<bool> autoDahk = [];
  var autoService = ServiceProvider.required<IAuto>();

  dynamic dahkInfo = {};

  Future getDahk() async {
    var prefs = await SharedPreferences.getInstance();

    var result =
        await dio.get("https://autozone.onepay.am/api/v1/users/GetDAHKInfo",
            options: Options(
              headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
            ));

    setState(() {
      dahkInfo = result.data;
    });

    // print(result.data);

    // var keys = result.data.keys.toList();
    // var values = result.data.values.toList();
    for (var element in currentAutoNumbers) {
      // print(element);
      // var result = await autoService.addAuto(element["carTechNumber"])
      setState(() {
        autoDahk.add(result.data[element] as bool);
      });
    }

    // for (var element in autos) {
    //   var result = await autoService.addAuto(element["carTechNumber"]);

    //   setState(() {
    //     autoDahk.add(result["dahk"] as bool);
    //   });
    // }
  }

  Future checkInspectionDate(
      List<DateTime> dates, List<String> autoNumber) async {
    for (int i = 0; i < dates.length; i++) {
      Duration difference = dates[i].difference(DateTime.now());

      int days = difference.inDays;

      if (days <= 30 && dates[i].year != 1970) {
        showInspectionExpire(
            context,
            autoNumber[i],
            dates[i],
            autos[i]["carTechNumber"],
            database!,
            userId,
            dahkInfo[autos[i]["carNumber"]] as bool);
      }
    }
  }

  Widget buildAutoMarkTileRow() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 5),
      width: double.infinity,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < autos.length; i++)
                  HomePageAutoMarkTile(
                    imagePath: autoImagePath[i] == ""
                        ? "assets/Navigation/NavigationBarAuto.png"
                        : autoImagePath[i],
                    autoNumber: autos[i]["carNumber"],
                    backgroundColor: _selected == i && autos.length != 1
                        ? const Color(0xff164866)
                        : const Color(0xffF3F4F6),
                    foregroundColor: _selected == i && autos.length != 1
                        ? const Color(0xffF3F4F6)
                        : const Color(0xff164866),
                    onPressed: () {
                      setState(() {
                        selectedTechNumber = autos[i]["carTechNumber"];
                        selectedAutoNumber = autos[i]["carNumber"];
                        _selected = i;
                      });
                    },
                  ),
                buildAddAutoButton()
              ])),
    );
  }

  Widget buildAddAutoButton() {
    return Container(
      width: 73,
      height: 80,
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          color: Color(0xffF3F4F6),
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: InkWell(
          onTap: () {
            if (autos.isEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(
                            isRedirect: true,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddNewCarPage()));
            }
          },
          child: const Image(
            image: AssetImage("assets/Settings/Add.png"),
            width: 15,
            height: 15,
          )),
    );
  }
}
