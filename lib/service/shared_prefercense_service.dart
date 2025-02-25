import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  static Future<SharedPreferencesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesService(prefs);
  }

  Map<String, String?> getUserData() {
    Map<String, String?> userData = {
      'userId': _prefs.getString('userId'),
      'email': _prefs.getString('email'),
      'name': _prefs.getString('name'),
      'role': _prefs.getString('role'),
      'address': _prefs.getString('address'),
      'phoneNumber': _prefs.getString('phoneNumber'),
    };

    print("User Data: $userData");

    return userData;
  }

  Future<void> saveUserData(
    String userId,
    String email,
    String name,
    String role,
    String address,
    String phoneNumber,
  ) async {
    _prefs.setString('userId', userId);
    _prefs.setString('email', email);
    _prefs.setString('name', name);
    _prefs.setString('role', role);
    _prefs.setString('address', address);
    _prefs.setString('phoneNumber', phoneNumber);

    print('data Save *** $userId,$name,$address,$role,$phoneNumber');
  }

  Future<void> clearUserData() async {
    _prefs.remove('userId');
    _prefs.remove('email');
    _prefs.remove('name');
    _prefs.remove('role');
    _prefs.remove('address');
    _prefs.remove('phoneNumber');
  }
}
