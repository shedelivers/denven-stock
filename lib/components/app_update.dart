import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import '../exports.dart';
import 'conformation_popup.dart';
import 'open_url.dart';

/// get app version
Future<String> getAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}


Future<String?> getStoreVersion() async {
  String? storeVersion;
  if (Platform.isAndroid) {
    PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();
    Document? result = await playStoreSearchAPI.lookupById('com.denvin.stock.denvin_stock', country: 'in');
    if (result != null) storeVersion = playStoreSearchAPI.version(result);
    debugPrint('PlayStore version: $storeVersion}');
  } else if (Platform.isIOS) {
    ITunesSearchAPI iTunesSearchAPI = ITunesSearchAPI();
    Map<dynamic, dynamic>? result =
    await iTunesSearchAPI.lookupByBundleId('com.denvin.stock', country: 'in');
    if (result != null) storeVersion = iTunesSearchAPI.version(result);
    debugPrint('AppStore version: $storeVersion}');
  } else {
    storeVersion = null;
  }
  return storeVersion;
}




Future<void> appCheck({required String appVersion, required String storeVersion})async {

  List<String> appVersionSplit = appVersion.split('.');
  List<String> updatedAppVersionSplit = storeVersion.split('.');

  if(int.parse(updatedAppVersionSplit[0]) > int.parse(appVersionSplit[0])){

    List<String> dateTimeNow = DateTime.now().toString().split(' ');
    List<String> currentDate = dateTimeNow[0].split('-');

    if(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}') > StorageHelper().getAppUpdateTime()){
      StorageHelper().setAppUpdateTime(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}'));
      updatePopUp(appVersion, storeVersion);

    }


  } else if (int.parse(updatedAppVersionSplit[1]) > int.parse(appVersionSplit[1])){

    List<String> dateTimeNow = DateTime.now().toString().split(' ');
    List<String> currentDate = dateTimeNow[0].split('-');

    if(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}') > StorageHelper().getAppUpdateTime()){
      StorageHelper().setAppUpdateTime(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}'));
      updatePopUp(appVersion, storeVersion);

    }


  } else if (int.parse(updatedAppVersionSplit[2]) > int.parse(appVersionSplit[2])){

    List<String> dateTimeNow = DateTime.now().toString().split(' ');
    List<String> currentDate = dateTimeNow[0].split('-');

    if(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}') > StorageHelper().getAppUpdateTime()){
      StorageHelper().setAppUpdateTime(int.parse('${currentDate[2]}${currentDate[1]}${currentDate[0]}'));
      updatePopUp(appVersion, storeVersion);

    }
  }
}

updatePopUp (String appVersion, String newVersion) {
  confirmPopUp(
    title: 'Update App?',
    conFirmButtonText: 'Update now',
    cancelText: "Later",
    subtitle: 'A new version of App is available! Version $newVersion is now available-you have $appVersion. \n\nWould you like to update it now?',
    onConfirm: (){
      const String appPlayStoreLink = "https://play.google.com/store/apps/details?id=com.denvin.stock.denvin_stock";
      const String appAppStoreLink = "https://apps.apple.com/app/id=com.denvin.stock";

      if(Platform.isAndroid){
        openUrlInApp(url: appPlayStoreLink);
      }else if(Platform.isIOS){
        openUrlInApp(url: appAppStoreLink);
      }
      },
  );
}


