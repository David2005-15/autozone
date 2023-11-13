// ignore_for_file: unnecessary_set_literal

import 'package:autozone/app/home/tex_pay.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/home_page_widgets/stations_chip.dart';
import 'package:autozone/utils/location_cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChooseLocationPage extends StatefulWidget {
  final String regNumber;
  final String autoNumber;

  const ChooseLocationPage(
      {super.key, required this.regNumber, required this.autoNumber});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  String? selectedValue = "Ընտրեք մարզը";
  String? selectedChil = "Ընտրեք համայնքը";

  Map<String, dynamic> paymentMetadata = {};

  @override
  void initState() {
    setProvince();

    super.initState();
  }

  void getProvinces() {
    for (int i = 0; i < provinceData.length; i++) {
      setState(() {
        province.add(provinceData[i]["translations"]["hy"]["name"]);
      });
    }
  }

  List<dynamic> province = [];
  List<dynamic> englishProvince = [];

  LocationsCacheManager locationsCacheManager = LocationsCacheManager();

  void setProvince() {
    // Dio dio = Dio();

    provinceData = locationsCacheManager.getProvinceData();
    province = locationsCacheManager.getProvince();
    englishProvince = locationsCacheManager.getEnglishProvince();

    provinceChilds.add(selectedChil);

    // var result = await dio.get(
    //   'https://autozone.onepay.am/api/v1/getLocations',
    // );
    // provinceData.clear();

    // setState(() {
    //   provinceData = result.data["locations"];
    // });

    // setState(() {
    //   province.add("Ընտրեք մարզը");

    //   for (int i = 0; i < provinceData.length; i++) {
    //     setState(() {
    //       province.add(provinceData[i]["translations"]["hy"]["name"]);
    //       englishProvince.add(provinceData[i]["translations"]["en"]["name"]);
    //     });
    //   }
    // });
  }

  List<dynamic> provinceData = [];

  List<dynamic> provinceChilds = [];

  List<dynamic> provinceTexPlaceData = [];
  List<dynamic> nearProvinceTexPlaceData = [];

  List<bool> checkedValue = [];
  List<bool> nearestCheckedValue = [];

  var additionalLocation = [];

  // void setPlace(String community, String region) async {
  //   Dio dio = Dio();

  //   var body = {
  //     "community": community,
  //     "region": region,
  //   };

  //   var result = await dio.post(
  //       "https://autozone.onepay.am/api/v1/techPayment/getAllStations",
  //       data: body,
  //       options: Options(validateStatus: (status) => true));

  //   setState(() {
  //     additionalLocation.addAll(result.data["stations"]);

  //     nearestCheckedValue = List.filled(additionalLocation.length, false);
  //   });
  // }

  var additionalLocations = [];

  Future setNearPlace(String community, String region) async {
    Dio dio = Dio();

    var body = {
      "community": community,
      "region": region,
    };

    var result = await dio.post(
        "https://autozone.onepay.am/api/v1/techPayment/getAllStations",
        data: body,
        options: Options(validateStatus: (status) => true));

    setState(() {
      provinceTexPlaceData = result.data["stations"];

      provinceTexPlaceData.forEach((elem) => {
            if (elem["additional_location"] != null)
              {
                elem["additional_location"].forEach((location) {
                  additionalLocations.add(location);
                })
              }
          });

      var names = <String>[];

      additionalLocations.removeWhere((element) {
        if (names.contains(element["data"]["name"].toString())) {
          return true;
        } else {
          names.add(element["data"]["name"].toString());
          return false;
        }
      });

      if (provinceTexPlaceData.length == 1 && additionalLocations.isEmpty) {
        checkedValue = List.filled(provinceTexPlaceData.length, true);
        paymentMetadata["name"] = provinceTexPlaceData[0]["data"]["name"];
        paymentMetadata["address"] = provinceTexPlaceData[0]["data"]["address"];
        paymentMetadata["workingTime"] =
            provinceTexPlaceData[0]["data"]["work_time"];
      } else {
        checkedValue = List.filled(provinceTexPlaceData.length, false);
        nearestCheckedValue = List.filled(additionalLocations.length, false);
      }
    });
  }

  int selectedStationdId = 0;

  late String selectedEnCommunity;
  late String selectedEnRegion;

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
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        title: const Text(
          'Տեխզնման կայանի ընտրություն',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 25),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            province.isNotEmpty
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton(
                      underline: Container(),
                      value: selectedValue,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          provinceChilds.clear();
                          selectedValue = value;
                          selectedChil = "Ընտրեք համայնքը";
                          provinceTexPlaceData = [];
                          additionalLocation.clear();
                          additionalLocations.clear();
                          selectedEnCommunity = "";

                          for (var element in provinceData) {
                            if (element["translations"]["hy"]["name"] ==
                                selectedValue) {
                              selectedEnCommunity =
                                  element["translations"]["en"]["name"];

                              provinceChilds.add("Ընտրեք համայնքը");
                              for (var elem in element["children"]) {
                                provinceChilds
                                    .add(elem["translations"]["hy"]["name"]);
                              }
                            }
                          }
                        });
                      },
                      items: province.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff164866),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton(
                underline: Container(),
                value: selectedChil,
                isExpanded: true,
                onChanged: (value) async {
                  setState(() {
                    selectedChil = value.toString();
                    provinceTexPlaceData = [];
                    selectedEnRegion = "";
                    additionalLocation = [];
                    additionalLocations = [];

                    outterLoop:
                    for (var element in provinceChilds) {
                      if (element != "Ընտրեք համայնքը") {
                        for (var el in provinceData) {
                          for (var elem in el["children"]) {
                            if (elem["translations"]["hy"]["name"] ==
                                selectedChil) {
                              selectedEnRegion =
                                  elem["translations"]["en"]["name"];

                              // setPlace(double.parse(elem["longitude"]),
                              //     double.parse(elem["latitude"]));

                              var place = setNearPlace(
                                  selectedEnCommunity, selectedEnRegion);

                              Future.wait([place]).then((value) {
                                additionalLocations.forEach(
                                  (element) {
                                    // setPlace(
                                    //     element["parent"]["translations"]["en"]
                                    //         ["name"],
                                    //     element["translations"]["en"]["name"]);
                                    // print(additionalLocation);
                                  },
                                );
                              });

                              break outterLoop;
                            }
                          }
                        }
                      }
                    }
                  });
                },
                items: provinceChilds.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: provinceTexPlaceData
                          .asMap()
                          .map(
                            (i, e) {
                              return MapEntry(
                                  i,
                                  StationsChip(
                                    name: e["data"]["name"],
                                    address: e["data"]["address"],
                                    workingTime: e["data"]["work_time"],
                                    longtitude: double.parse(e["longitude"]),
                                    latitude: double.parse(e["latitude"]),
                                    onChanged: (val) {
                                      if (provinceTexPlaceData.length != 1 ||
                                          additionalLocations.isNotEmpty) {
                                        setState(() {
                                          checkedValue = List.filled(
                                              provinceTexPlaceData.length,
                                              false);

                                          nearestCheckedValue = List.filled(
                                              additionalLocations.length,
                                              false);
                                          checkedValue[i] = val!;
                                          selectedStationdId =
                                              int.parse(e["id"].toString());
                                          paymentMetadata["name"] =
                                              e["data"]["name"];
                                          paymentMetadata["address"] =
                                              e["data"]["address"];
                                          paymentMetadata["workingTime"] =
                                              e["data"]["work_time"];
                                        });
                                      } else {
                                        setState(() {
                                          paymentMetadata["name"] =
                                              e["data"]["name"];
                                          paymentMetadata["address"] =
                                              e["data"]["address"];
                                          paymentMetadata["workingTime"] =
                                              e["data"]["work_time"];
                                        });
                                      }
                                    },
                                    checked: checkedValue[i],
                                  ));
                            },
                          )
                          .values
                          .toList(),
                    ),
                    additionalLocations.isNotEmpty
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              const Text(
                                "Տվյալ համայնքին մոտ է",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Color(0xff164866)),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              Column(
                                children: additionalLocations
                                    .asMap()
                                    .map(
                                      (i, e) {
                                        return MapEntry(
                                            i,
                                            StationsChip(
                                              name: e["data"]["name"],
                                              address: e["data"]["address"],
                                              workingTime: e["data"]
                                                  ["work_time"],
                                              longtitude:
                                                  double.parse(e["longitude"]),
                                              latitude:
                                                  double.parse(e["latitude"]),
                                              onChanged: (val) {
                                                setState(() {
                                                  checkedValue = List.filled(
                                                      provinceTexPlaceData
                                                          .length,
                                                      false);
                                                  nearestCheckedValue =
                                                      List.filled(
                                                          additionalLocations
                                                              .length,
                                                          false);

                                                  nearestCheckedValue[i] = val!;
                                                  selectedStationdId =
                                                      int.parse(
                                                          e["id"].toString());
                                                  paymentMetadata["name"] =
                                                      e["data"]["name"];
                                                  paymentMetadata["address"] =
                                                      e["data"]["address"];
                                                  paymentMetadata[
                                                          "workingTime"] =
                                                      e["data"]["work_time"];
                                                });
                                              },
                                              checked: nearestCheckedValue[i],
                                            ));
                                      },
                                    )
                                    .values
                                    .toList(),
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            ButtonFactory.createButton(
                "cta_green",
                "Ընտրել",
                checkedValue.any(
                          (element) => element == true,
                        ) ||
                        nearestCheckedValue.any((element) => element == true)
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TexPay(
                                      station: selectedStationdId,
                                      regNumber: widget.regNumber,
                                      autoNumber: widget.autoNumber,
                                      insuranceName: paymentMetadata["name"],
                                      workingHours:
                                          paymentMetadata["workingTime"],
                                      address: paymentMetadata["address"],
                                    )));
                      }
                    : null,
                double.infinity,
                48,
                margin: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 10, top: 10))
          ],
        ),
      ),
    );
  }
}
