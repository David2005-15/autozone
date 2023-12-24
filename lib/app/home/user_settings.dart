import 'dart:io';

import 'package:autozone/app/home/settings/presonal_data.dart';
import 'package:autozone/app/home/settings/my_cars.dart';
import 'package:autozone/app/home/settings/privacy_policy.dart';
import 'package:autozone/utils/image_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserSettings extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final List<Map<dynamic, dynamic>> cars;

  const UserSettings({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.cars
  }) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  XFile? _image;
  ImageCacheManager imageManager = ImageCacheManager();

  Future getUserImage() async {
    // var prefs = await SharedPreferences.getInstance();

    // imagePath = prefs.getString("imagePath");
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
      imagePath = result.data["User"]["image"];
      name = result.data["User"]["fullName"] ?? "";
    });
  }

  String? imagePath;

  String name = "";

  @override
  void initState() {
    getUserImage();
    super.initState();

    setState(() {
      name = widget.name;
    });
  }

  Future updateImage() async {
    ImagePicker picker = ImagePicker();

    var image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (mounted) {
      setState(() {
        _image = image;
      });

      await sendImageToServer(_image!);

      await getUserImage();
    }
  }

  Future sendImageToServer(XFile file) async {
    Dio dio = Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    dio.options.headers = {
      "Authorization": "Bearer ${prefs.getString("token")}"
    };

    await dio.patch("https://autozone.onepay.am/api/v1/users/updateUserImage",
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xffFCFCFC),
      padding: const EdgeInsets.only(top: 10, right: 11, left: 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildImageSection(imagePath),
          buildNameSection(name),
          buildSettingTile("Անձնական տվյալներ", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonalData(
                          fullName: widget.name,
                          phoneNumber: widget.phoneNumber,
                          gmail: widget.email,
                          updateState: getUserImage,
                        )));
          }, "assets/Settings/ProfileIcon.png"),
          buildSettingTile("Իմ մեքենաները", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyCarsPage(),
              ),
            );
          }, "assets/Settings/MyCars.png"),
          buildSettingTile("Հրապարակային օֆերտա", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
          }, "assets/Settings/PrivacyPolicy.png"),
        ],
      ),
    );
  }

  void showRemoveAccountDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            child: SizedBox(
                height: 226,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: const Text(
                          "Դուք ցանկանում եք հեռացնել Ձեր անձնական հաշիվը։",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff164866))),
                    ),
                    Container(
                      width: double.infinity,
                      height: 35,
                      margin: const EdgeInsets.only(
                          left: 60, right: 60, bottom: 34),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xffFF0000),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Հեռացնել",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15),
                      ),
                    )
                  ],
                )),
          );
        }));
  }

  InkWell buildImageSection(String? networkImage) {
    return InkWell(
        onTap: () async {
          updateImage();
        },
        child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _image != null || networkImage != null
                  ? Colors.transparent
                  : const Color(0xffF2F2F4),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            child: networkImage == null
                ? const Image(
                    image: AssetImage("assets/UploadImage.png"),
                    width: 30,
                    height: 30,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6), // Image border
                    child: SizedBox.fromSize(
                        size: const Size.fromRadius(100), // Image radius
                        child: Image(
                          image: NetworkImage(networkImage)
                              as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        )),
                  )));
  }

  Widget setImageFile(String? url) {
    if (url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20), // Image border
        child: SizedBox.fromSize(
            size: const Size.fromRadius(100), // Image radius
            child: Image(
              image: NetworkImage(url!) as ImageProvider<Object>,
              fit: BoxFit.cover,
            )),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Image border
      child: SizedBox.fromSize(
        size: const Size.fromRadius(100), // Image radius
        child: Image(
          image: Image.file(
            File(_image!.path),
            fit: BoxFit.cover,
          ).image,
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Container buildNameSection(String name) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Color(0xff164866),
        ),
      ),
    );
  }

  Widget buildSettingTile(String title, VoidCallback onTap, String path) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(right: 15, left: 11),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F4),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Image(
                    image: AssetImage(path),
                    width: 24,
                    height: 24,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 19),
                  child: AutoSizeText(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff164866),
                      ),
                      maxLines: 1,
                      minFontSize: 11,
                      maxFontSize: 16),
                ),
              ],
            ),
            const Icon(Icons.arrow_right_rounded, color: Color(0xff164866)),
          ],
        ),
      ),
    );
  }
}
