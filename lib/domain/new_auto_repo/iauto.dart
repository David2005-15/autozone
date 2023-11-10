abstract class IAuto {
  bool isValidAuto(String auto);
  Future<Map> addAuto(String auto);
  Future<Map> applyAddedAuto(String auto);
}