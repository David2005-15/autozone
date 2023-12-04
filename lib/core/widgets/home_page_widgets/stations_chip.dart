import 'package:autozone/core/alert_dialogs/station_map.dart';
import 'package:flutter/material.dart';

class StationsChip extends StatelessWidget {
  final String? name;
  final String? address;
  final String? workingTime;
  final Function(bool?) onChanged;
  final bool checked;
  final double longtitude;
  final double latitude;

  const StationsChip(
      {Key? key,
      this.name,
      this.address,
      this.workingTime,
      required this.onChanged,
      required this.latitude,
      required this.longtitude,
      required this.checked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: const BoxDecoration(
        color: Color(0xffF3F4F6),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 5, right: 15, top: 10, bottom: 10),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                onChanged(!checked);
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 1),
                          child: Container(
                            child: Text(
                              name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: Color(0xff164866),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 23,
                      height: 23,
                      child: InkWell(
                        onTap: () {
                          onChanged(!checked);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: checked
                                ? const Color(0xff447B18)
                                : Colors.transparent,
                            border: Border.all(
                              color: checked ? Colors.transparent: Color(0xffD7D7D7),
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(4), // Set the border radius
                          ),
                          width: 18,
                          height: 18,
                          child: checked
                              ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: Image(
                                    image: AssetImage("assets/Settings/CheckIcon.png"),
                                    width: 14.0,
                                    height: 14,
                                    color: Colors.white,
                                  ),
                              )
                              : null,
                        ),
                      ),
                    ),
                    // Theme(
                    //   data: ThemeData(
                    //     unselectedWidgetColor: const Color(0xffD7D7D7),
                    //   ),
                    //   child: Checkbox(
                    //     value: checked,
                    //     onChanged: onChanged,
                    //     checkColor: Colors.white,
                    //     activeColor: const Color(0xff447B18),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onChanged(!checked);
            },
            child: Container(
                height: 70,
                alignment: Alignment.center,
                color: Colors.white,
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              // width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(address ?? "",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: Color(0xff164866),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(workingTime ?? "",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                        color: Color(0xff164866),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container()
                    ],
                  ),
                )),
          ),
          Container(
            height: 45,
            alignment: Alignment.center,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                showMapDialog(
                    context, latitude, longtitude, address ?? "", name ?? "");
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/Map.png"),
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Դիրքը քարտեզի վրա",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: Color(0xff164866),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
