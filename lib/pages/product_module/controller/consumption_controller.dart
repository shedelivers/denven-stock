import 'dart:collection';
import 'dart:ffi';
import 'package:denvin_stock/exports.dart';
import 'package:intl/intl.dart';

class ConsumptionController extends GetxController {

  Rxn<ProductModal> products = Rxn();
  RxList<Rxn<List<ConsumptionDto>>> movesMainLists = <Rxn<List<ConsumptionDto>>>[].obs;
  RxList<Rxn<List<TextEditingController>>> storageController = <Rxn<List<TextEditingController>>>[].obs;
  RxList<Rxn<List<TextEditingController>>> quantityController = <Rxn<List<TextEditingController>>>[].obs;
  RxList<Rxn<List<FocusNode>>> storageFocusNode = <Rxn<List<FocusNode>>>[].obs;
  RxList<Rxn<List<FocusNode>>> quantityFocusNode = <Rxn<List<FocusNode>>>[].obs;
  RxList<int> counter = <int>[].obs;
  RxList<String> expiryDates = <String>[].obs;
  RxInt numberOfFoams = 1.obs;
  RxBool isLoading = false.obs;
  late ProductApiProvider _productApiProvider;
  Rxn<Storage> selectedStorage = Rxn();


  @override
  void onInit() {
    _productApiProvider  = ProductApiProvider();
    super.onInit();
  }

  getArguments(){
    if(Get.arguments != null){
      products.value = Get.arguments[RoutesArgument.productDetails];
      numberOfFoams.value = products.value?.expiries?.length ?? 1;
      if(products.value != null){
        if(products.value?.storage != null){
          selectedStorage.value = Storage(
            id: products.value?.storage?.id,
            name: products.value?.storage?.name,
          );
        }
      }
      initializeTextField();
    }
  }


  initializeTextField() {
    for(int i = 0; i < numberOfFoams.value; i++) {
      quantityController.add(Rxn(<TextEditingController>[TextEditingController()]));
      storageController.add(Rxn(<TextEditingController>[TextEditingController()]));
      storageFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
      quantityFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
      movesMainLists.add(Rxn(<ConsumptionDto>[ConsumptionDto(expiry: products.value?.expiries?[i].at ?? "")]));
      counter.add(0);
    }
  }

  deleteExpAndQuantity(int index, int subIndex,String expiryDate){
    movesMainLists[index].value?.removeAt(subIndex);
    // moveStorage.value?.moves?.removeWhere((element) => element.qty.toString() == quantityController[index].value?[subIndex].text && element.expiry == expiryDate,);
    quantityController[index].value?.removeAt(subIndex);
    storageController[index].value?.removeAt(subIndex);
    storageFocusNode[index].value?.removeAt(subIndex);
    quantityFocusNode[index].value?.removeAt(subIndex);
    update();
  }

  addCount(int index,int subIndex){
    counter[index] = counter[index] + 1;
    quantityController[index].value?[subIndex].text = counter[index].toString();
  }

  minusCount(int index,int subIndex){
    if(counter[index] > 0){
      counter[index] = counter[index] - 1;
      quantityController[index].value?[subIndex].text = counter[index].toString();
    }
  }
  addNewExpAndQuantity(int index, String expDate){
    quantityController[index].value?.add(TextEditingController());
    storageController[index].value?.add(TextEditingController());
    storageFocusNode[index].value?.add(FocusNode());
    quantityFocusNode[index].value?.add(FocusNode());
    movesMainLists[index].value?.add(ConsumptionDto(expiry: products.value?.expiries?[index].at ?? ""));
    update();
  }


  submit() async {
    if(await Utils.hasNetwork()){
      List<Map<String,dynamic>> myConsumption = [];
      for(int i=0; i< movesMainLists.length; i++){
        int lengthOfValues = movesMainLists[i].value?.length ?? 0;
        for(int j=0; j < lengthOfValues; j++){
          if(movesMainLists[i].value![j].qty != null && movesMainLists[i].value![j].ConsumerId != null){
            myConsumption.add(movesMainLists[i].value![j].toJson());
          }
        }
      }
      Map<String,dynamic> payload = {};
      payload["ProductId"] = products.value?.id;
      payload["StorageId"] = products.value?.storageId;
      payload["MinLevel"] = products.value?.minLevel;
      payload["Expiries"] = products.value?.expiries?.map((e) => e.toJson()).toList();
      payload["Consumptions"] = myConsumption;
      isLoading.value = true;
      ConsumptionResponse response = await _productApiProvider.postConsumption(payload: payload);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          Get.back(result: "refresh");
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
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



class ConsumptionDto {
  String? expiry;
  int? qty;
  int? ConsumerId;

  ConsumptionDto({this.expiry, this.qty, this.ConsumerId});

  ConsumptionDto.fromJson(Map<String, dynamic> json) {
    expiry = json['Expiry'];
    qty = json['Qty'];
    ConsumerId = json['ConsumerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Expiry'] = expiry;
    data['Qty'] = qty;
    data['ConsumerId'] = ConsumerId;
    return data;
  }
}
