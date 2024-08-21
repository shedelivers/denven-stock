

import 'package:denvin_stock/exports.dart';


class StorageHelper {
  static const String _userId = "userId";
  static const String _userName = "userName";
  static const String _userModel = "userModel";
  static const String _subscriptionDetails = "subscriptionDetails";
  static const String _clinicModal = "clinicModal";
  static const String _userToken = "userToken";
  static const String _refreshToken = "refreshToken";
  static const String _fcmToken = "fcmToken";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _clinicId = "clinicId";
  static const String _clinicCode = "clinicCode";
  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');
  static final StorageHelper _singleton = StorageHelper._internal();

  StorageHelper._internal();

  static Future init() async {
    var result = await GetStorage.init();
    print("GetStorageIsIntilized$result");
  }

  factory StorageHelper() {
    return _singleton;
  }

  _savePref(String key, Object? value) async {
    var prefs = GetStorage();
    prefs.write(key, value);
  }

  T _getPref<T>(String key) {
    return GetStorage().read(key) as T;
  }

  void clearAll() {
    GetStorage().erase();
  }

  int? getUserId() {
    return _getPref(_userId);
  }

  String? getUserName() {
    return _getPref(_userName);
  }

  void saveUserName(String? name) {
    _savePref(_userName, name);
  }

  void saveUserId(int? id) {
    _savePref(_userId, id);
  }


  String? getUserToken() {
    return _getPref(_userToken);
  }

  String? getRefreshToken() {
    return _getPref(_refreshToken);
  }

  void saveRefreshToken(String? token) {
    _savePref(_refreshToken, token);
  }

  void saveUserToken(String? token) {
    _savePref(_userToken, token);
  }

  String? getFcmToken() {
    return _getPref(_fcmToken);
  }

  void saveFcmToken(String? token) {
    _savePref(_fcmToken, token);
  }

  bool getIsLoggedIn(){
    return _getPref(_isLoggedIn) ?? false;
  }

  void saveIsLoggedIn(bool value) {
    _savePref(_isLoggedIn, value);
  }


  String? getClinicId() {
    return _getPref(_clinicId);
  }

  void saveClinicId(String? value){
    _savePref(_clinicId, value);
  }

  int? getClinicCode(){
    return _getPref(_clinicCode);
  }

  void saveClinicCode(int? value){
    _savePref(_clinicCode, value);
  }

  UserModal? getUserModel() {
    String? user = _getPref(_userModel);
    if (user != null) {
      Map<String, dynamic> userMap = _decoder.convert(user);
      return UserModal.fromJson(userMap);
    } else {
      return null;
    }
  }

  void saveUserModel(UserModal? userModel) {
    if (userModel != null) {
      String value = _encoder.convert(userModel.toJson());
      _savePref(_userModel, value);
    } else {
      _savePref(_userModel, null);
    }
  }


  //
  // void saveSubscriptionPlan(SubscriptionDetails? subscriptionDetails) {
  //   if (subscriptionDetails != null) {
  //     String value = _encoder.convert(subscriptionDetails.toJson());
  //     _savePref(_subscriptionDetails, value);
  //   } else {
  //     _savePref(_subscriptionDetails, null);
  //   }
  // }
  //
  // SubscriptionDetails? getSubscriptionPlan() {
  //   String? user = _getPref(_subscriptionDetails);
  //   if (user != null) {
  //     Map<String, dynamic> userMap = _decoder.convert(user);
  //     return SubscriptionDetails.fromJson(userMap);
  //   } else {
  //     return null;
  //   }
  // }

  ClinicDetails? getClinicModel() {
    String? user = _getPref(_clinicModal);
    if (user != null) {
      Map<String, dynamic> userMap = _decoder.convert(user);
      return ClinicDetails.fromJson(userMap);
    } else {
      return null;
    }
  }

  void saveClinicModel(ClinicDetails? clinicDetails) {
    if (clinicDetails != null) {
      String value = _encoder.convert(clinicDetails.toJson());
      _savePref(_clinicModal, value);
    } else {
      _savePref(_clinicModal, null);
    }
  }

}
