import 'package:denvin_stock/components/utils/print_value.dart';
import 'package:denvin_stock/exports.dart';

import '../../components/get_app_access_popup.dart';

class SplashScreen extends StatelessWidget {

  late AuthApiProvider _authApiProvider;
  SplashScreen({super.key}){
    _authApiProvider = AuthApiProvider();
    Future.delayed(const Duration(seconds: 1), () {
      StorageHelper().getIsLoggedIn() ? _navigation() : Get.offAndToNamed(AppRoutes.logIn);
    });
  }

  Future _navigation() async {
    if (await Utils.hasNetwork()) {
      FocusScope.of(Get.context!).unfocus();
      DataResponse<UserModal?> dataResponse = await _authApiProvider.getMyProfile();
      if (dataResponse.successful == false) {
        Get.offAndToNamed(AppRoutes.logIn);
      } else {
        if(dataResponse.response?.hasStockAccess == false){
          print('dataResponse.response?.hasStockAccess => ${dataResponse.response?.hasStockAccess}');

          getAppAccessPopUp();
        } else {
          StorageHelper helper = StorageHelper();
          if(helper.getClinicId() != null){
            Get.offAllNamed(AppRoutes.dashboard);
          } else {
            Get.offAllNamed(AppRoutes.authClinicSelection);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
        body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return  Center(
      child: Column(
        children: [
          const Spacer(),
          imageAsset(appLogo, height: 80,width: 80),
          vGap(20.h),
          imageAsset(appTextLogo, width: 150),
          vGap(10),
          TextView("Stock Management"),
          const Spacer(),
          CircularProgressIndicator(color: appGreenColor, backgroundColor: Colors.black.withOpacity(0.1),strokeWidth: 5,),
          vGap(80.h),
        ],
      ),
    );
  }

}