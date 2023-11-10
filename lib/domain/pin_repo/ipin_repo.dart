abstract class IPinRepo {
  bool isValidPin(String pin);
  Future<bool> savePin(String pin);
  Future<bool> verifySavedPin(String pin);
  Future savePinToStorage(String pin);
}