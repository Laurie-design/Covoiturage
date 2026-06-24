import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  bool _isDriver = false;
  bool _isAdmin = false;
  bool _identityVerified = false;
  bool _licenseVerified = false;
  bool _vehicleVerified = false;
  Uint8List? _profileImage;

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isDriver => _isDriver;
  bool get isAdmin => _isAdmin;
  bool get isFullyVerified =>
      _identityVerified && _licenseVerified && _vehicleVerified;
  bool get identityVerified => _identityVerified;
  bool get licenseVerified => _licenseVerified;
  bool get vehicleVerified => _vehicleVerified;
  Uint8List? get profileImage => _profileImage;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get name => '$_firstName $_lastName';
  String get phone => _phone;
  String get token => _token;

  void login({
    bool isDriver = false,
    bool isAdmin = false,
    String firstName = '',
    String lastName = '',
    String phone = '',
    String token = '',
  }) {
    _isLoggedIn = true;
    _isDriver = isDriver;
    _isAdmin = isAdmin;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _token = token;
    notifyListeners();
  }

  void setUserData({
    String firstName = '',
    String lastName = '',
    required String phone,
    String token = '',
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    if (token.isNotEmpty) _token = token;
    notifyListeners();
  }

  void setRole(bool isDriver) {
    _isDriver = isDriver;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isDriver = false;
    _isAdmin = false;
    _identityVerified = false;
    _licenseVerified = false;
    _vehicleVerified = false;
    _profileImage = null;
    _firstName = '';
    _lastName = '';
    _phone = '';
    _token = '';
    notifyListeners();
  }

  void setIdentityVerified(bool v) {
    _identityVerified = v;
    notifyListeners();
  }

  void setLicenseVerified(bool v) {
    _licenseVerified = v;
    notifyListeners();
  }

  void setVehicleVerified(bool v) {
    _vehicleVerified = v;
    notifyListeners();
  }

  void setProfileImage(Uint8List? bytes) {
    _profileImage = bytes;
    notifyListeners();
  }
}
