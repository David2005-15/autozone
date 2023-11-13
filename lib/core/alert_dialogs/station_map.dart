import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showMapDialog(
    BuildContext context, double latitude, double longitude, String address, String name) {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              margin:
                  const EdgeInsets.only(right: 6, bottom: 5, top: 5, left: 6),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xff164866),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          address,
                          style: const TextStyle(
                            color: Color(0xff164866),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xff164866),
                        borderRadius: BorderRadius.circular(3)),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [                    
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 15,
                      ),
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) =>
                          _controller.complete(controller),
                      markers: {
                        Marker(
                          markerId: const MarkerId('marker'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 40,
                        // width: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F2F4),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xff164866),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          var currentPos = await getCurrentLocation();

                          String dirGoogleUrl =
                              'https://www.google.com/maps/dir/?api=1&origin=${currentPos.latitude},${currentPos.longitude} &destination=$latitude,$longitude&travelmode=driving&dir_action=navigate';

                          // String googleUrl =
                          //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&mode=d';

                          if (await canLaunchUrl(Uri.parse(dirGoogleUrl))) {
                            await launchUrl(Uri.parse(dirGoogleUrl));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 70, right: 20),
                          width: 76,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.turn_right_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Երթուղի',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]));
    },
  );
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }

  // Check if the app has permission to access location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied.';
    }
  }

  // Get the current location
  // return await Geolocator.getCurrentPosition();

  Position pos = await Geolocator.getCurrentPosition();

  return pos;
}
