import 'dart:collection';
import 'package:denvin_stock/components/utils/print_value.dart';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/dto/create_update_product.dart';
import 'package:intl/intl.dart';import 'package:dio/src/form_data.dart' as dio;
import 'package:http_parser/src/media_type.dart' as mediaType;

class UpdateQuantityController extends GetxController {

  Rxn<ProductModal> products = Rxn();
  List<TextEditingController> textQuantityController = [];
  List<TextEditingController> textPriceController = [];
  List<TextEditingController> textExpireController = [];
  List<FocusNode> textQuantityFocusNodes = [];
  List<FocusNode> textExpireFocusNodes = [];
  RxList<int> counter = <int>[].obs;
  RxList<String> expiryDates = <String>[].obs;
  RxInt numberOfFoams = 1.obs;
  RxBool isLoading = false.obs;
  late ProductApiProvider _productApiProvider;

  @override
  void onInit() {
    _productApiProvider  = ProductApiProvider();
    super.onInit();
  }

  getArguments(){
    if(Get.arguments != null){
      products.value = Get.arguments[RoutesArgument.productDetails];
      numberOfFoams.value = products.value?.expiries?.length ?? 1;
      initializeTextField();
    }
  }


  initializeTextField() {
    for(int i = 0; i < numberOfFoams.value; i++) {
      textQuantityController.add(TextEditingController());
      textPriceController.add(TextEditingController());
      textExpireController.add(TextEditingController());
      textQuantityFocusNodes.add(FocusNode());
      textExpireFocusNodes.add(FocusNode());
      expiryDates.add(products.value?.expiries?[i].at ?? "N/A");
      textQuantityController[i].text = products.value?.expiries?[i].qty.toString()?? "0";
      textPriceController[i].text = products.value?.expiries?[i].price.toString()?? "0";
      textExpireController[i].text = products.value?.expiries?[i].at ?? "";
      counter.add(0);
    }

  }

  String convertExpiryDateFormat(String originalDateString) {
    DateFormat originalFormat = DateFormat("dd/MM/yyyy");
    // DateFormat originalFormat = DateFormat("yyyy/MM/dd");
    // DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    DateFormat targetFormat = DateFormat("dd MMMM yyyy");
    try {
      DateTime originalDate = originalFormat.parse(originalDateString);
      String formattedDate = targetFormat.format(originalDate);
      return formattedDate;
    } catch (e) {
      return originalDateString;
    }
  }

  getExpiryDate(int index) async {
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      fieldHintText: "dd/mm/yyyy",
      context: Get.context!,
      firstDate: DateTime.now(), // Set minimum date to current date
      lastDate: DateTime(2101),
    );
    textExpireController[index].text = DateFormat('dd/MM/yyyy').format(picked!);
    update();
  }


  addCount(int index){
    if(textQuantityController[index].text !=  "0"){
      counter[index] = counter[index] + 1;
      int tempQty = products.value?.expiries![index].qty ?? 0;
      textQuantityController[index].text = (tempQty - counter[index]).toString();
    }
  }


  minusCount(int index) {
    if(counter[index] > 0){
      counter[index] = counter[index] - 1;
      int tempQty = products.value?.expiries![index].qty ?? 0;
      textQuantityController[index].text = (tempQty - counter[index]).toString();
    }
  }


  submit() async {
    if(await Utils.hasNetwork()) {
      // List<ExpiryDataDto> expiryList = [];
      // for (int i = 0; i < numberOfFoams.value; i++) {
      //   if (textQuantityController[i].text.isNotEmpty || textExpireController[i].text.isNotEmpty) {
      //     expiryList.add(
      //       ExpiryDataDto(
      //         quantity: textQuantityController[i].text,
      //         at: textExpireController[i].text,
      //         price: textPriceController[i].text == "null" || textPriceController[i].text.isEmpty? "0":textPriceController[i].text
      //       ),
      //     );
      //   }
      // }

     // dio.FormData formData = await CreateUpdateProductDto(id: products.value?.id, expiryData: expiryList,).toJson();



      List<Map<String, dynamic>> expiryList = [];
      for (int i = 0; i < numberOfFoams.value; i++) {
        if (textQuantityController[i].text.isNotEmpty || textExpireController[i].text.isNotEmpty) {
          expiryList.add({
            "qty": textQuantityController[i].text,
            "at": textExpireController[i].text,
            "price": textPriceController[i].text == "null" || textPriceController[i].text.isEmpty? "0":textPriceController[i].text
          }
          );
        }
      }

      Map<String, dynamic> payload = {
        "Id": products.value?.id,
        "expiries": expiryList,
      };


      printValue(tag: 'NOW PAYLOAD IS:', payload);

      isLoading.value = true;
      DataResponse<ProductModal?> response = await _productApiProvider.updateProductQty(id: products.value?.id.toString() ?? "", payload: payload);
      isLoading.value = false;

      printValue(tag: "RESPONSE IS:", response.successful);

      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        Get.back(result: "refresh");
       /* if (response.response != null) {
          Get.back(result: "refresh");
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }*/
      }
    }
  }

   Color getExpiryColor({required List<ExpiriesWithPrice> list, String? date, required int index}) {
    int level = 0;
    if(list.isEmpty) {
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
}