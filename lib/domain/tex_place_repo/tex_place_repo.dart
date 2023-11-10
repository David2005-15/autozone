import 'package:autozone/domain/tex_place_repo/itex_place_repo.dart';
import 'package:dio/dio.dart';

class TexPlaceRepo implements ITexPlaceRepo {
  Dio dio = Dio();

  @override
  Future<Map> getTexPlaces(double latitude, double longitude) async {
    var body = {"latitude": latitude, "longitude": longitude};

    var respone = await dio.post(
        "https://autozone.onepay.am/api/v1/techPayment/getStations",
        data: body, options: Options(validateStatus: (status) {
      return true;
    }));

    if (respone.data["stationsWithDistances"] != null) {
      return respone.data["stationsWithDistances"]; 
    }

    return {};
  }
}
