import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/app/home/settings/add_new_car.dart';
import 'package:autozone/core/alert_dialogs/choose_tm_type.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  List<dynamic> cars = [];

  bool isInitialRequest = true;

  IAuto autoService = ServiceProvider.required<IAuto>();

  @override
  void initState() {
    getUserData();
    initFirebaseApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey[100],
              height: 1.0,
            ),
          ),
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
          title: const Text(
            "Իմ մեքենաները",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xff164866)),
          ),
          actions: <Widget>[
            Container(
                // margin: const EdgeInsets.only(left: 25),
                child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddNewCarPage()));
                    },
                    child: const Image(
                      image: AssetImage("assets/Settings/CarAddButton.png"),
                      width: 21,
                      height: 21,
                    ))),
            const SizedBox(
              width: 16,
            )
          ],
          iconTheme: const IconThemeData(color: Color(0xff164866)),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: cars.isNotEmpty
              ? Column(
                  children: cars.map((e) {
                  return Column(
                    children: [
                      buildAutoTile(e["carNumber"], e["carMark"],
                          e["carTechNumber"], e["editable"] ?? false,
                          autoMark: e["carMark"],
                          autoNumber: e["carNumber"],
                          typeList: e["vehicle_types"],
                          selected: e["vehicleTypeEn"]),
                      Container(
                          margin: const EdgeInsets.only(left: 70),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xffF5F5F5), width: 1)),
                          ))
                    ],
                  );
                }).toList())
              : !isInitialRequest
                  ? const Center(
                      child: Text(
                        "Ավելացված մեքենաներ չունեք",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff164866),
                            fontSize: 17),
                      ),
                    )
                  : Container(),
        ));
  }

  DatabaseReference? database;

  Future initFirebaseApp() async {
    setState(() {
      database = FirebaseDatabase.instance.ref();
    });
  }

  Widget buildAutoTile(
      String carNumber, String carModel, String techNumber, bool canEdit,
      {String autoMark = "",
      String autoNumber = "",
      List<dynamic>? typeList,
      String selected = ""}) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 8),
      padding: const EdgeInsets.only(right: 10, left: 10),
      decoration: const BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(
          //     color: Color(0xffF5F5F5),
          //     width: 1
          //   )
          // )
          ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xffF2F2F4), width: 2),
                    // color: Colors.yellow
                  ),
                  child: const Image(
                    image: AssetImage("assets/Settings/Auto.png"),
                    width: 22,
                    height: 22,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  carNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866),
                  ),
                ),
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xff164866),
                      borderRadius: BorderRadius.circular(25)),
                ),
                Flexible(
                  child: Text(
                    carModel,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          canEdit
              ? InkWell(
                  onTap: () {
                    tm_type_car_update(
                        context,
                        autoMark,
                        autoNumber,
                        typeList ?? [],
                        techNumber,
                        null,
                        selected,
                        getUserData);
                  },
                  child: const Image(
                    image: AssetImage("assets/Settings/Edit.png"),
                    width: 20,
                    height: 20,
                  ),
                )
              : Container(),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              showRemoveAutoDialog(context, carNumber, () async {
                Dio dio = Dio();

                await dio.delete(
                    "https://autozone.onepay.am/api/v1/cars/deleteCar/$techNumber");

                await getUserData();

                DatabaseEvent insurance_snapshot =
                    await database!.child("inspection_due").once();

                final insurance_data = insurance_snapshot.snapshot.value is Map
                    ? insurance_snapshot.snapshot.value as Map<dynamic, dynamic>
                    : {};
                final instrance_document = insurance_data.values
                    .toList()
                    .cast<Map<dynamic, dynamic>>();

                for (var i = 0; i < instrance_document.length; i++) {
                  if (carNumber == instrance_document[i]["car_number"]) {
                    database!
                        .child("inspection_due")
                        .child(insurance_data.keys.toList()[i])
                        .remove();
                  }
                }

                if (cars.isEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage(isRedirect: true)));
                }
              });
            },
            child: const Image(
              image: AssetImage("assets/Settings/RecycleBin.png"),
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  List<String> types = [];

  Future getUserData() async {
    Dio dio = Dio();
    var prefs = await SharedPreferences.getInstance();

    var result =
        await dio.get("https://autozone.onepay.am/api/v1/users/getData",
            options: Options(
              headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
              validateStatus: (status) {
                return true;
              },
            ));

    setState(() {
      if (result.data["User"] != null) {
        cars = result.data["User"]["Cars"];
      } else {
        cars = [];
      }
      isInitialRequest = false;
    });

    for (int i = 0; i < cars.length; i++) {
      var data = await autoService.addAuto(cars[i]["carTechNumber"]);

      setState(() {
        cars[i]["editable"] = (data["vehicle_types"].length > 1) as bool;
        cars[i]["vehicle_types"] = data["vehicle_types"];
      });
    }
  }

  void showRemoveAutoDialog(
      BuildContext context, String carNumber, VoidCallback onTap) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Դուք ցանկանում եք հեռացնել $carNumber մեքենայի տվյալները։",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                ),
                const SizedBox(
                  height: 40,
                ),
                ButtonFactory.createButton("cta_red", "Հեռացնել", () async {
                  var prefs = await SharedPreferences.getInstance();

                  prefs.setBool("changes", true);

                  Navigator.pop(context);
                  onTap();
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 20))
              ],
            ),
          );
        });
  }
}
