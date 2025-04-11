import 'dart:collection';
import 'dart:convert';

import 'package:denvin_stock/components/custom_image.dart';
import 'package:denvin_stock/components/utils/print_value.dart';
import 'package:denvin_stock/exports.dart';
import 'package:intl/intl.dart';

import '../../../network/modal/add_to_draft_model.dart';
import '../../../network/modal/extra_item_model.dart';

class ArrivedItemsDetailController extends GetxController {

  Rxn<ArrivedItemModal> products = Rxn();
  RxBool isLoading = false.obs;
  RxInt currentPageIndex = 0.obs;
  RxList<Items> items = <Items>[].obs;
  List<ItemDTO> searchItems = [];
  RxList<ItemDTO> itemsPayload = <ItemDTO>[].obs;
  final PageController pageController = PageController();
  List<Storages> selectedStorages = [];
  late ProductApiProvider _productApiProvider;
  RxString progressValue = "0%".obs;
  RxDouble progressPercent = 0.0.obs;
  RxList<Rxn<List<TextEditingController>>> storageController = <Rxn<List<TextEditingController>>>[].obs;
  RxList<Rxn<List<TextEditingController>>> expiryDateController = <Rxn<List<TextEditingController>>>[].obs;
  RxList<Rxn<List<TextEditingController>>> dynamicQuantityDateController = <Rxn<List<TextEditingController>>>[].obs;
  RxList<Rxn<List<FocusNode>>> storageDateFocusNode = <Rxn<List<FocusNode>>>[].obs;
  RxList<Rxn<List<FocusNode>>> expiryDateFocusNode = <Rxn<List<FocusNode>>>[].obs;
  RxList<Rxn<List<FocusNode>>> dynamicQuantityDateFocusNode = <Rxn<List<FocusNode>>>[].obs;
  List<GlobalKey<FormState>> formKeys = [];

  RxString searchValue = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxBool isFocus = false.obs;


  Rxn<ExtraItemModel> extraItems = Rxn();
  final TextEditingController extraItemsController = TextEditingController();
  RxBool extraItemsLoading = false.obs;
  Map<String, dynamic> selectedItem = <String, dynamic>{};


  @override
  void onInit() {
    searchFocusNode.addListener(_onFocusChange);
    _productApiProvider = ProductApiProvider();
     super.onInit();
  }

  void _onFocusChange() {
    if(isFocus.value){
      Future.delayed(const Duration(milliseconds: 500),(){
        isFocus.value = searchFocusNode.hasFocus;
      });
    }else{
      isFocus.value = searchFocusNode.hasFocus;
    }

    print('isFocus => $isFocus');
  }

  getArguments(){
    if(Get.arguments != null) {
      products.value = Get.arguments[RoutesArgument.productDetails];
      getOrderById();
    }
  }

  bool isValidDate(String input) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    try {
      dateFormat.parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isDateBeforeToday(String input) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final DateTime date = dateFormat.parseStrict(input);
    final DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year, today.month, today.day));
  }

  bool isDuplicateDate(int index) {
    String value = expiryDateController[currentPageIndex.value].value?[index].text ?? "";
    if(value.isEmpty){
     return false;
    }
    int length = expiryDateController[currentPageIndex.value].value?.length ?? 0;
    for (int i = 0; i < length; i++) {
      if (i != index && expiryDateController[currentPageIndex.value].value?[i].text == value) {
        return true;
      }
    }
    return false;
  }


  // calculateProgress(int totalLength, int currentItem) {
  //   currentItem = currentItem.clamp(1, totalLength);
  //   double progress = (currentItem / totalLength) * 100;
  //   progressValue.value = "$progress%";
  //   update();
  // }

  calculateProgress(int totalLength, int currentIndex,) {
      currentIndex = currentIndex.clamp(0, totalLength - 1);
      double progress = (currentIndex / totalLength) * 100;
      if (currentIndex == 0) {
        progress = 0;
      }
      print("progressValue.value  $progress: ${progressValue.value}");

      progressValue.value = "${progress.toStringAsFixed(2)}%";
      progressPercent.value = currentIndex / totalLength;

    // refresh();
  }

  // calculateProgress(int totalLength, int currentIndex) {
  //  currentIndex = currentIndex.clamp(0, totalLength - 1);
  //   progressPercent.value = (currentIndex + 1) / totalLength;
  //   currentIndex = currentIndex  + 1;
  //   double progress = (currentIndex / totalLength) * 100;
  //   if (progress < (100 / totalLength)) {
  //     progress = 100 / totalLength;
  //   }
  //   print("progressValue.value  $progress: ${progressValue.value}");
  //
  //   progressValue.value = "${progress.toStringAsFixed(2)}%";
  //  // update();
  // }

  bool isLastIndexIsValid = false;
  lastIndexIsValid () {
    if(currentPageIndex.value == itemsPayload.length -1){
      if(itemsPayload[currentPageIndex.value].status == 'return'){
        isLastIndexIsValid = true;
      } else {
        int sumOfQuantity = itemsPayload[currentPageIndex.value].storages?.map((e) => e.qty ?? 0).reduce((value, element) => value + element)??0;
        bool isAnyStorageNameNull = itemsPayload[currentPageIndex.value].storages?.any((storage) => storage.name == null || storage.name == '') ?? false;
        bool isAnyStorageQuantityNull = itemsPayload[currentPageIndex.value].storages?.any((storage) => storage.qty == null || storage.qty == 0) ?? false;

        if(sumOfQuantity == itemsPayload[currentPageIndex.value].quantity && !isAnyStorageNameNull && !isAnyStorageQuantityNull){
          isLastIndexIsValid = true;
        } else {
          isLastIndexIsValid = false;
        }
      }

      if(isLastIndexIsValid == true){
        printValue(tag: "isLastIndexIsValid: ||", isLastIndexIsValid);
        progressValue.value = "100.00%";
        progressPercent.value = 1;
        //calculateProgress(itemsPayload.length, currentPageIndex.value, isTapped: true);
      } else{
        calculateProgress(itemsPayload.length, currentPageIndex.value);
      }
    } else {
      isLastIndexIsValid = false;
    }
    update();
    printValue(tag: "isLastIndexIsValid:", isLastIndexIsValid);
  }

  getExpiryDate(int index) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      fieldHintText: "dd/mm/yyyy",
      initialDate: DateTime.tryParse(expiryDateController[currentPageIndex.value].value![index].text),
      firstDate: DateTime.now(), // Set minimum date to current date
      lastDate: DateTime(2101),
    );
    if(picked != null){
      expiryDateController[currentPageIndex.value].value![index].text = DateFormat('dd/MM/yyyy').format(picked!);
      List<String> dates = [];
      Storages tempStorage = itemsPayload[currentPageIndex.value].storages?.removeAt(index) ?? Storages();
      dates.add(DateFormat('dd/MM/yyyy').format(picked));
      itemsPayload[currentPageIndex.value].storages?.insert(index, Storages(
        sId: tempStorage.sId,
        qty: tempStorage.qty ?? 0,
        name: tempStorage.name,
        expiredAt: dates,
      ));
    }
    update();
  }

  getOrderById() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<ArrivedItemModal> response = await _productApiProvider.getOrderById(productId: products.value?.id);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        bool runDraftNewItemsLoop = true;
        if (response.response != null) {

          var model = response.response;
          products.value = model;
          items.value = model?.items ?? [];

          List<ItemDTO> allCompleteItems = [];
          List<ItemDTO> allInCompleteItems = [];

          for(int i = 0; i < items.length ; i++){
            if(items[i].draftItems == null){
              itemsPayload.add(
                  ItemDTO(
                    isNew: false,
                    id: items[i].id,
                    name: items[i].productName,
                    supplierCode: items[i].supplierCode,
                    supplier: products.value?.supplierName,
                    status: "Confirm",
                    unitPrice: items[i].price,
                    orderedQuantity: items[i].quanitity,
                    quantity: items[i].quanitity,
                    minLevel: 1,
                    manufacturer: null,
                    type: "Pack",
                    barcodes: [],
                  ));
              storageController.add(Rxn(<TextEditingController>[TextEditingController()]));
              expiryDateController.add(Rxn(<TextEditingController>[TextEditingController()]));
              dynamicQuantityDateController.add(Rxn(<TextEditingController>[TextEditingController(text: (items[i].quanitity ?? 0).toString())]));
              storageDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
              expiryDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
              dynamicQuantityDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
              formKeys.add(GlobalKey<FormState>());
              if(itemsPayload[i].storages == null){
                itemsPayload[i].storages = [];
                itemsPayload[i].storages?.add(Storages(
                  qty: items[i].quanitity,
                  expiredAt: [],
                ));
              }
              calculateProgress(itemsPayload.length, currentPageIndex.value);
            } else {

                int sumOfQuantity = items[i].draftItems?.storages?.map((e) => e.qty ?? 0).reduce((value, element) => value + element)??0;

                bool isAnyStorageNameNull = items[i].draftItems?.storages?.any((storage) => storage.name == null || storage.name == '') ?? false;

                if(
                !isAnyStorageNameNull && sumOfQuantity == items[i].draftItems?.quantity
                    || items[i].draftItems?.status == "return"
                ){
                  printValue('run once: if');
                  allCompleteItems.add(ItemDTO(
                      isNew: false,
                      id: items[i].draftItems?.id??0,
                      name: items[i].draftItems?.name??"",
                      supplierCode: items[i].draftItems?.supplierCode??"",
                      supplier: products.value?.supplierName,
                      status: items[i].draftItems?.status??"",
                      unitPrice: items[i].draftItems?.price??0.0,
                      orderedQuantity: items[i].draftItems?.quantity??0,
                      quantity: items[i].draftItems?.quantity??0,
                      minLevel: 1,
                      manufacturer: null,
                      type: "Pack",
                      barcodes: items[i].draftItems?.barcodes,
                      storages: [
                        ...items[i].draftItems?.storages!.map((e) => Storages(
                          qty: e.qty,
                          sId: e.sId,
                          name: e.name,
                          expiredAt: e.expiredAt,
                        ))??[]
                      ]
                  ));


                } else {
                  allInCompleteItems.add(
                      ItemDTO(
                          isNew: false,
                          id: items[i].draftItems?.id??0,
                          name: items[i].draftItems?.name??"",
                          supplierCode: items[i].draftItems?.supplierCode??"",
                          supplier: products.value?.supplierName,
                          status: items[i].draftItems?.status??"",
                          unitPrice: items[i].draftItems?.price??0.0,
                          orderedQuantity: items[i].draftItems?.quantity??0,
                          quantity: items[i].draftItems?.quantity??0,
                          minLevel: 1,
                          manufacturer: null,
                          type: "Pack",
                          barcodes: items[i].draftItems?.barcodes,
                          storages: [
                            ...items[i].draftItems?.storages?.map((e) => Storages(
                              qty: e.qty,
                              sId: e.sId,
                              name: e.name,
                              expiredAt: e.expiredAt,
                            ))??[]
                          ]
                      )
                  );
                }


                formKeys.add(GlobalKey<FormState>());


             if(products.value?.draftNewItems?.isNotEmpty??false){
                  if (runDraftNewItemsLoop) {

                    for (int k = 0; k < products.value!.draftNewItems!.length; k++) {

                      int sumOfQuantity = products.value?.draftNewItems?[k].storages?.map((e) => e.qty ?? 0).reduce((value, element) => value + element)??0;

                      bool isAnyStorageNameNull =  products.value!.draftNewItems?[k].storages?.any((storage) => storage.name == null || storage.name == '') ?? false;


                      if(
                      !isAnyStorageNameNull
                            && sumOfQuantity == products.value?.draftNewItems?[k].quantity
                            || products.value?.draftNewItems?[k].status == "return"
                        ){
                          allCompleteItems.add(ItemDTO(
                              isNew: products.value?.draftNewItems?[k].isNew,
                              id: products.value?.draftNewItems?[k].id??0,
                              name: products.value?.draftNewItems?[k].name??"",
                              supplierCode: products.value?.draftNewItems?[k].supplierCode??"",
                              supplier: products.value?.supplierName,
                              status: products.value?.draftNewItems?[k].status??"",
                              unitPrice: products.value?.draftNewItems?[k].price??0.0,
                              orderedQuantity: products.value?.draftNewItems?[k].quantity??0,
                              quantity: products.value?.draftNewItems?[k].quantity??0,
                              minLevel: 1,
                              manufacturer: null,
                              type: "Pack",
                              barcodes: products.value?.draftNewItems?[k].barcodes,
                              storages: [
                                ...products.value?.draftNewItems?[k].storages?.map((e) => Storages(
                                  qty: e.qty,
                                  sId: e.sId,
                                  name: e.name,
                                  expiredAt: e.expiredAt,
                                ))??[]
                              ]
                          ));


                        } else {
                          allInCompleteItems.add(
                              ItemDTO(
                                  isNew: products.value?.draftNewItems?[k].isNew,
                                  id: products.value?.draftNewItems?[k].id??0,
                                  name: products.value?.draftNewItems?[k].name??"",
                                  supplierCode: products.value?.draftNewItems?[k].supplierCode??"",
                                  supplier: products.value?.supplierName,
                                  status: products.value?.draftNewItems?[k].status??"",
                                  unitPrice: products.value?.draftNewItems?[k].price??0.0,
                                  orderedQuantity: products.value?.draftNewItems?[k].quantity??0,
                                  quantity: products.value?.draftNewItems?[k].quantity??0,
                                  minLevel: 1,
                                  manufacturer: null,
                                  type: "Pack",
                                  barcodes: products.value?.draftNewItems?[k].barcodes,
                                  storages: [
                                    ...products.value?.draftNewItems?[k].storages?.map((e) => Storages(
                                      qty: e.qty,
                                      sId: e.sId,
                                      name: e.name,
                                      expiredAt: e.expiredAt,
                                    ))??[]
                                  ]
                              )
                          );
                        }
                      formKeys.add(GlobalKey<FormState>());
                    }
                    runDraftNewItemsLoop = false;
                }
                }
            }
          }



          if((allCompleteItems+allInCompleteItems).isNotEmpty){
            itemsPayload.value = allCompleteItems+allInCompleteItems;
            printValue(tag: 'total length: ${allCompleteItems.length} || ${allInCompleteItems.length}', itemsPayload.length);


            for (int i = 0; i < itemsPayload.length ; i++) {
              storageController.add(Rxn(<TextEditingController>[]));
              expiryDateController.add(Rxn(<TextEditingController>[]));
              dynamicQuantityDateController.add(Rxn(<TextEditingController>[]));
              storageDateFocusNode.add(Rxn(<FocusNode>[]));
              expiryDateFocusNode.add(Rxn(<FocusNode>[]));
              dynamicQuantityDateFocusNode.add(Rxn(<FocusNode>[]));
              formKeys.add(GlobalKey<FormState>());


              for (int k = 0; k < itemsPayload[i].storages!.length ; k++){

                storageController[i].value?.add(TextEditingController(text: itemsPayload[i].storages?[k].name??""));
                dynamicQuantityDateController[i].value?.add(TextEditingController(text: itemsPayload[i].storages?[k].qty.toString()??""));
                expiryDateController[i].value?.add(TextEditingController(text: (itemsPayload[i].storages?[k].expiredAt?.isEmpty??true? "":itemsPayload[i].storages?[k].expiredAt?[0])!));
                storageDateFocusNode[i].value?.add(FocusNode());
                dynamicQuantityDateFocusNode[i].value?.add(FocusNode());
                expiryDateFocusNode[i].value?.add(FocusNode());

                // storageController[i].value?[k].text = itemsPayload[i].storages?[k].name??"";
                // dynamicQuantityDateController[i].value?[k].text = itemsPayload[i].storages?[k].qty.toString()??"";
                // expiryDateController[i].value?[k].text = (itemsPayload[i].storages?[k].expiredAt?.isEmpty??true? "":itemsPayload[i].storages?[k].expiredAt?[0])!;
              }
            }

            Future.delayed(const Duration(milliseconds: 500), (){
              pageController.jumpToPage(allCompleteItems.length);
            });
          }


          update();

        } else {
          Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }

  minusCount() {
    ItemDTO tempItem  = itemsPayload.removeAt(currentPageIndex.value);
    int qtValue = tempItem.quantity ?? 0;
    if(qtValue > 0){
      qtValue = qtValue-1;
    }
    tempItem.quantity = qtValue;
    itemsPayload.insert(currentPageIndex.value, tempItem);
    update();
  }


  addCount() {
    ItemDTO tempItem  = itemsPayload.removeAt(currentPageIndex.value);
    int qtValue = tempItem.quantity ?? 0;
    qtValue = qtValue+1;
    tempItem.quantity = qtValue;
    itemsPayload.insert(currentPageIndex.value, tempItem);
    update();
  }

  addNewExpAndQuantity(){
    dynamicQuantityDateController[currentPageIndex.value].value?.add(TextEditingController());
    storageController[currentPageIndex.value].value?.add(TextEditingController());
    expiryDateController[currentPageIndex.value].value?.add(TextEditingController());
    storageDateFocusNode[currentPageIndex.value].value?.add(FocusNode());
    dynamicQuantityDateFocusNode[currentPageIndex.value].value?.add(FocusNode());
    expiryDateFocusNode[currentPageIndex.value].value?.add(FocusNode());
    itemsPayload[currentPageIndex.value].storages?.add(Storages(expiredAt: [], qty: 0));
    update();
  }

  deleteExpAndQuantity(int index){
    dynamicQuantityDateController[currentPageIndex.value].value?.removeAt(index);
    storageController[currentPageIndex.value].value?.removeAt(index);
    expiryDateController[currentPageIndex.value].value?.removeAt(index);
    expiryDateFocusNode[currentPageIndex.value].value?.removeAt(index);
    storageDateFocusNode[currentPageIndex.value].value?.removeAt(index);
    dynamicQuantityDateFocusNode[currentPageIndex.value].value?.removeAt(index);
    itemsPayload[currentPageIndex.value].storages?.removeAt(index);
    update();
  }

  getBarCode() {
    Get.toNamed(AppRoutes.scannerScreen)?.then((value) {
      if (value != null) {
        BarcodeModal temp =  value as BarcodeModal;
        BarcodeDTO? bar = BarcodeDTO(barcode: temp.barcode,removeAll: temp.removeAll,symbology: temp.symbology);
        List<BarcodeDTO> barCodee = [];
        for(int i = 0; i< itemsPayload.length;i++){
          barCodee.addAll(itemsPayload[i].barcodes ?? []);
        }
        // barCodee.addAll((itemsPayload[currentPageIndex.value].barcodes ?? []).where((e1) => e1.barcode == bar.barcode).toList());
        if(barCodee.any((element) => element.barcode == bar.barcode)){
          Utils.showSnackBar("Already added");
          return ;
        }
        ItemDTO tempItem  = itemsPayload.removeAt(currentPageIndex.value);
        List<BarcodeDTO> newBars = tempItem.barcodes ?? [];
        newBars.add(bar);
        tempItem.barcodes = newBars;
        itemsPayload.insert(currentPageIndex.value, tempItem);
        update();
      }
    });
  }

  submit() async {
    if (await Utils.hasNetwork()) {
      var payload = itemsPayload.map((element) {return element.toJson();}).toList();
      for(var myPayload in payload) {
        if(myPayload["Status"] == "return") {
          myPayload["storages"].clear();
          myPayload["storages"] = [];
          myPayload["storages"].add(Storages(
            sId: -1,
            qty: 0,
            expiredAt: [],
          ));
        }
      }

      for(var myPayload in payload) {
        if(myPayload["IsNew"] == true) {
          myPayload["Id"] = -1;
        }
      }

      Map<String, dynamic> data = {"arrivedOrderRequest" : payload};

      printValue(tag: "arrivedOrderRequest PayLoad:", data);

      isLoading.value = true;
      DataResponse response = await _productApiProvider.submitArrivedItems(orderId: products.value?.id.toString(),data: data);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        if (response.response != null) {
          var model = response.response;
          Get.back(result: "DONE");
          update();
        } else {
          Future.delayed(const Duration(milliseconds: 500), (){
            pageController.jumpToPage(currentPageIndex.value);
            // pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
          Utils.showSnackBar("Fill all required field");
         // Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }


  searchingFilter (String value) {
    searchValue.value = value;
    if(value.isNotEmpty){
       searchItems = itemsPayload.where((element) => (
          element.name!.toLowerCase().contains(value.toLowerCase()) ||
              element.supplierCode!.toLowerCase().contains(value.toLowerCase())
      )).toList();
    }else{
      searchItems = itemsPayload;
    }
  }


  getExtraItems(String searchText) async {
    if (await Utils.hasNetwork()) {
      extraItemsLoading.value = true;
      DataResponse<ExtraItemModel> response = await _productApiProvider.getExtraItems(
          searchText: searchText,
          externalSupplierId: products.value?.extSupplierId.toString()??"",
          internalSupplierId: products.value?.supplierId.toString()??"");
      extraItemsLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        if (response.response != null) {
          var model = response.response;
          extraItems.value = model;
          refresh();
        } else {
          Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }


  addItem ({
    required bool isNew,
    required int id,
    required String name,
    required supplierCode,
    required double unitPrice,
    required int orderedQuantity,
    required int quantity,

  }) {


    itemsPayload.add(ItemDTO(
      isNew: isNew,
      id: id,
      name: name,
      supplierCode: supplierCode,
      supplier: products.value?.supplierName,
      status: "Confirm",
      unitPrice: unitPrice,
      orderedQuantity: orderedQuantity,
      quantity: quantity,
      minLevel: 1,
      manufacturer: null,
      type: "Pack",
      barcodes: [],
      storages: [
        Storages(
        sId: -1,
        name: "",
        qty: quantity,
        expiredAt: [],
      )]
    ));
    storageController.add(Rxn(<TextEditingController>[TextEditingController()]));
    expiryDateController.add(Rxn(<TextEditingController>[TextEditingController()]));
    dynamicQuantityDateController.add(Rxn(<TextEditingController>[TextEditingController(text: quantity.toString())]));
    storageDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
    expiryDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
    dynamicQuantityDateFocusNode.add(Rxn(<FocusNode>[FocusNode()]));
    formKeys.add(GlobalKey<FormState>());
    items.add(
      Items(
      id: id,
      productName: name,
      price: unitPrice,
      quanitity: orderedQuantity,
      supplierCode: supplierCode,
    ));
    refresh();
    searchController.clear();
    Get.back();
    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }




  addToDraft () async {
    if (await Utils.hasNetwork()) {
      var payload = itemsPayload.map((element) {return element.toJson();}).toList();

      for(var myPayload in payload) {

        if(myPayload["Status"] == "return") {
          myPayload["storages"].clear();
          myPayload["storages"] = [];
          myPayload["storages"].add(Storages(
            sId: -1,
            qty: 0,
            name: "",
            expiredAt: [],
          ));
        }
      }

      Map<String, dynamic> data = {"orderId" : products.value?.id.toString()??"", "items": payload};

      printValue(tag: "addToDraft PayLoad: After", data);

      isLoading.value = true;
      AddToDraftResponseModal response = await _productApiProvider.addToDraft(
          productId: products.value?.id.toString()??"",data: data);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        Get.back();
        Utils.showSnackBar('Save into draft successfully');
      }
    }
  }
}