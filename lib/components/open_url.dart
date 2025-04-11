import 'package:denvin_stock/components/utils/strings.dart';
import 'package:denvin_stock/components/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrlInApp({required String url}) async {
  if(!await Utils.hasNetwork()){
    Utils.showSnackBar(Strings.somethingWentWrong);
  }else if(url ==""){
    Utils.showSnackBar(Strings.somethingWentWrong);
  }else{

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      Utils.showSnackBar(Strings.somethingWentWrong);
    }
  }

}