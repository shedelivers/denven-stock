import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/baske_modal.dart';
import 'package:intl/intl.dart';


class BasketProductDetailController extends GetxController {

  Rxn<Product> products = Rxn();
  RxBool isLoading = false.obs;
  RxBool showBannerCode = true.obs;

  getArguments(){
    if(Get.arguments != null) {
      products.value = Get.arguments[RoutesArgument.productDetails];
    }
  }

  String extractImagePath(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    String imagePath = jsonData.isNotEmpty ? jsonData[0]['file'] : '';
    int startIndex = imagePath.indexOf('product-images');
    if (startIndex != -1) {
      imagePath = imagePath.substring(startIndex);
    } else {
      imagePath = '';
    }
    return imagePath;
  }

  String convertDateFormat(String originalDateTimeString) {
    DateFormat originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    try {
      DateTime originalDateTime = originalFormat.parse(originalDateTimeString);
      String formattedDate = targetFormat.format(originalDateTime);
      return formattedDate;
    } catch (e) {
      return originalDateTimeString;
    }
  }


  Color getExpiryColor({required List<ExpiryLevel> list, String? date, required int index}) {
    int level = 0;
    if(list.isEmpty){
      return Colors.grey;
    } else {
      level = list[index].level ?? 0;
      if(level == 1){
        return Colors.redAccent;
      } else if(level == 2){
        return const Color(0xfff17a00);
      } else if(level == 3) {
        return const Color(0xfffda600);
      } else if(level == 4){
        return const Color(0xff1ec1b0);
      }
    }
    return Colors.grey;
  }

  String convertExpiryDateFormat(String originalDateString) {
    DateFormat originalFormat = DateFormat("dd/MM/yyyy");
    DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    try {
      DateTime originalDate = originalFormat.parse(originalDateString);
      String formattedDate = targetFormat.format(originalDate);
      return formattedDate;
    } catch (e) {
      return originalDateString;
    }
  }

}