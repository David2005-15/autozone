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
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: const BoxDecoration(
        color: Color(0xffF3F4F6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              onChanged(!checked);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, bottom: 2),
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      name ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866),
                      ),
                    ),
                  ),
                ),
                Checkbox(
                  value: checked,
                  onChanged: onChanged,
                  checkColor: Colors.white,
                  activeColor: const Color(0xff447B18),
                )
              ],
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
                  padding: const EdgeInsets.only(left: 8, right: 8),
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
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                address ?? "",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Color(0xff164866),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Image(
                                image: AssetImage("assets/WorkHours.png"),
                                width: 15,
                                height: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Text(workingTime ?? "",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
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
            height: 30,
            alignment: Alignment.center,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                showMapDialog(context, latitude, longtitude, address ?? "", name ?? "");
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        fontSize: 15,
                        color: Color(0xff164866),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
