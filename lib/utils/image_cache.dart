import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();

  factory ImageCacheManager() => _instance;

  ImageCacheManager._internal();

  String? imagePath = "";

  Future getUserImage() async {
    var prefs = await SharedPreferences.getInstance();

    imagePath = prefs.getString('imagePath');

    if (imagePath == null) {
      Dio dio = Dio();

      var result =
          await dio.get("https://autozone.onepay.am/api/v1/users/getData",
              options: Options(
                headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
                validateStatus: (status) {
                  return true;
                },
              ));

      imagePath = result.data["User"]["image"];

      await prefs.setString('imagePath', imagePath ?? "");
    }
  }
}
