import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:denvin_stock/components/conformation_popup.dart';
import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/network/modal/barcode_modal.dart';
import 'package:denvin_stock/network/modal/dto/create_update_product.dart';
import 'package:intl/intl.dart';
import 'package:dio/src/form_data.dart' as dio;
import 'package:http_parser/src/media_type.dart' as mediaType;
import 'package:dio/src/multipart_file.dart' as multipart;

import '../choose_tag_view.dart';
class AddProductController extends GetxController implements CameraOnCompleteListener {
  ProductType? productType;
  Rxn<ProductModal> products = Rxn();
  Rxn<int?> selectedSupplier = Rxn(null);
  Rxn<int?> selectedStorage = Rxn(null);
  RxInt minimumLevelCount = 1.obs;
  RxList<String> imageUrlToEdit = <String>[].obs;
  RxList<File> myFile = <File>[].obs;
  // Rxn<String?> imageUrlToEdit = Rxn(null);
  RxBool dontHaveCode = false.obs;
  RxBool isLoading = false.obs;
  RxBool dummyLoading = false.obs;
  RxBool imageLoading = false.obs;
  RxBool isEdit = false.obs;
  bool _isDeletingProduct = false;
  RxBool showSupplierMenu = true.obs;
  RxBool isExpandedMoreFields = false.obs;

  Rxn<AutovalidateMode> autoValidate = Rxn<AutovalidateMode>(AutovalidateMode.disabled);
  RxList<Supplier> supplierList = <Supplier>[Supplier(id: null, name: "Choose Supplier")].obs;
  RxList<Supplier> storageList = <Supplier>[Supplier(id: null, name: "Choose Storage")].obs;
  RxList<BarcodeModal> barcodes = <BarcodeModal>[].obs;
  RxList<TagModal> mySelectedTags = <TagModal>[].obs;

  RxList<BarcodeModal> addBarcodes = <BarcodeModal>[].obs;
  RxList<BarcodeModal> removeBarcodes = <BarcodeModal>[].obs;

  late ProductApiProvider _productApiProvider;
  late TextEditingController productNameController;
  late TextEditingController quantityController;
  late TextEditingController minimumLevelController;
  late TextEditingController priceController;
  late TextEditingController totalPriceController;
  late TextEditingController storageController;
  late TextEditingController supplierCodeController;
  late TextEditingController supplierController;
  late TextEditingController dateController;
  late TextEditingController manufactureController;
  late TextEditingController notesController;

  late CameraHelper cameraHelper;

  RxList<TextEditingController> expiryDateController = <TextEditingController>[].obs;
  RxList<TextEditingController> dynamicQuantityDateController = <TextEditingController>[].obs;
  RxList<TextEditingController> dynamicPriceController = <TextEditingController>[].obs;
  RxList<FocusNode> expiryDateFocusNode = <FocusNode>[].obs;
  RxList<FocusNode> dynamicQuantityDateFocusNode = <FocusNode>[].obs;
  RxList<FocusNode> dynamicPriceFocusNode = <FocusNode>[].obs;
  RxList<bool> isOldExpiryData = <bool>[].obs;

  late FocusNode productNameFocusNode;
  late FocusNode quantityFocusNode;
  late FocusNode minimumLevelFocusNode;
  late FocusNode priceFocusNode;
  late FocusNode totalPriceFocusNode;
  late FocusNode storageFocusNode;
  late FocusNode supplierCodeFocusNode;
  late FocusNode supplierFocusNode;
  late FocusNode dateFocusNode;
  late FocusNode manufactureFocusNode;
  late FocusNode notesFocusNode;

  RxBool isStorageListEmpty = false.obs;
  RxString fileName = "".obs;
  RxString fileType = "".obs;
  RxString imagePath = "".obs;


  @override
  void onInit() {
    getArguments();
    initialize();
    getSupplier();
    getStorage();

    super.onInit();
  }

  getArguments() {
    if (Get.arguments != null) {
      if (Get.arguments[RoutesArgument.productDetails] != null) {
        products.value = Get.arguments[RoutesArgument.productDetails];
        isEdit.value = Get.arguments[RoutesArgument.isEdit] ?? false;
        productType = Get.arguments[RoutesArgument.productType];
        productNameController = TextEditingController(
          text: products.value?.name ?? "",
        );
        manufactureController = TextEditingController(
          text: products.value?.manufacturer ?? "",
        );
        supplierCodeController = TextEditingController(
          text: products.value?.supplierCode ?? "",
        );
        selectedSupplier.value = products.value?.supplier?.id;

      }
      if (Get.arguments[RoutesArgument.barCode] != null) {
        addBarcodes.add(Get.arguments[RoutesArgument.barCode]);
      }
    }
  }

  void addInitialValues() {
    productNameController.text = products.value?.name ?? "";
    priceController.text = (products.value?.quantity == 0?"0": products.value?.price ?? 0).toString();
   //priceController.text = (products.value?.price ?? 0).toString();
    notesController.text = (products.value?.note ?? "").toString();
    minimumLevelController.text = products.value?.minLevel.toString() ?? "";
    minimumLevelCount.value = products.value?.minLevel ?? 0;
    minimumLevelCount.value = products.value?.minLevel ?? 0;
    manufactureController.text = products.value?.manufacturer ?? "";
    supplierCodeController.text = products.value?.supplierCode ?? "";
    supplierController.text = products.value?.supplier?.name ?? "";
    // dateController.text = products.value?.orderedAt != null ? setOrderDate(products.value?.orderedAt ?? "") ;
    dontHaveCode.value = true;
    if (storageList.any((element) => element.id == products.value?.storageId)) {
      selectedStorage.value = products.value?.storageId;
    }
    imageUrlToEdit.value = products.value?.productImage??[];
   // imageUrlToEdit.value = products.value?.productImage != null && products.value?.productImage != "" ? "${ApiConstants.baseUrlForImage}/${extractImagePath(products.value?.productImage ?? "")}" : null;
    isExpandedMoreFields.value = true;
    if((products.value?.expiries!.length ?? 0) > 0){
      for(Expiries expiries in products.value?.expiries ?? []){
        expiryDateController.add(TextEditingController(text: expiries.at));
        dynamicQuantityDateController.add(TextEditingController(text: expiries.qty.toString()));
        dynamicPriceController.add(TextEditingController(text: expiries.price.toString()));
        expiryDateFocusNode.add(FocusNode());
        dynamicQuantityDateFocusNode.add(FocusNode());
        dynamicPriceFocusNode.add(FocusNode());
        isOldExpiryData.add(true);
      }
    }
    if (products.value?.barcode?.isNotEmpty ?? false) {
      if (products.value?.barcode?[0].barcodes?.isNotEmpty ?? false) {
        // Same visibility as Product Details: hide Denven barcodes.
        for (Barcodes code in (products.value?.barcode?[0].barcodes ?? [])
            .where((code) => code.isDenvenBarcode != true)) {
          barcodes.add(BarcodeModal(
              barcode: code.barcode,
              symbology: code.type,
              removeAll: false,
              uniqueId: code.uniqueId));
        }
      }
    }
  }

  String setOrderDate(String orderDate) {
    DateTime originalDate = DateTime.parse(orderDate);
    String formattedDate = DateFormat('dd/MM/yyyy').format(originalDate);
    return formattedDate;
  }

  void initialize() {
    _productApiProvider = ProductApiProvider();
    cameraHelper = CameraHelper(this);
    productNameController = TextEditingController();
    quantityController = TextEditingController();
    minimumLevelController = TextEditingController();
    minimumLevelController.text = minimumLevelCount.value.toString();
    priceController = TextEditingController();
    totalPriceController = TextEditingController();
    storageController = TextEditingController();
    supplierCodeController = TextEditingController();
    supplierController = TextEditingController();
    dateController = TextEditingController();
    manufactureController = TextEditingController();
    notesController = TextEditingController();
    if(!isEdit.value) expiryDateController.add(TextEditingController());
    if(!isEdit.value) isOldExpiryData.add(false);
    if(!isEdit.value) dynamicQuantityDateController.add(TextEditingController());
    if(!isEdit.value) dynamicPriceController.add(TextEditingController());
    expiryDateFocusNode.add(FocusNode());
    dynamicQuantityDateFocusNode.add(FocusNode());
    dynamicPriceFocusNode.add(FocusNode());
    productNameFocusNode = FocusNode();
    quantityFocusNode = FocusNode();
    minimumLevelFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    totalPriceFocusNode = FocusNode();
    storageFocusNode = FocusNode();
    supplierCodeFocusNode = FocusNode();
    supplierFocusNode = FocusNode();
    dateFocusNode = FocusNode();
    manufactureFocusNode = FocusNode();
    notesFocusNode = FocusNode();
  }

  addNewExpAndQuantity() {
    isOldExpiryData.add(false);
    expiryDateController.add(TextEditingController());
    dynamicQuantityDateController.add(TextEditingController());
    dynamicPriceController.add(TextEditingController());
    expiryDateFocusNode.add(FocusNode());
    dynamicQuantityDateFocusNode.add(FocusNode());
    dynamicPriceFocusNode.add(FocusNode());
    update();
  }

  checkRememberMe() {
    dontHaveCode.value = !dontHaveCode.value;
    update();
  }

  getBarCode() {
    Get.toNamed(AppRoutes.scannerScreen)?.then((value ) {
      if (value != null) {
         BarcodeModal? bar=value;
         List barCodee=[];
         barCodee.addAll( addBarcodes.where((e1) => e1.barcode==bar?.barcode).toList());
         barCodee.addAll(barcodes.where((e1) =>  e1.barcode==bar?.barcode).toList()) ;
        if(barCodee.isNotEmpty){
          Utils.showSnackBar("Already added");
          return ;
        }
        if (isEdit.value) {
          addBarcodes.add(value);
        } else {
          addBarcodes.add(value);
        }
        update();
      }
    });
  }

  addMinimumLevel() {
    minimumLevelCount.value = minimumLevelCount.value + 1;
    minimumLevelController.text = (minimumLevelCount.value).toString();
  }

  subMinimumLevel() {
    if (minimumLevelCount.value > 0) {
      minimumLevelCount.value = minimumLevelCount.value - 1;
      minimumLevelController.text = (minimumLevelCount.value).toString();
    }
  }

  getDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      fieldHintText: "dd/mm/yyyy",
      locale: const Locale('en', 'GB'),
      initialDate: DateTime.tryParse(dateController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    dateController.text = DateFormat('dd/MM/yyyy').format(picked!);
    update();
  }

  getExpiryDate(int index) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      fieldHintText: "dd/mm/yyyy",
      initialDate: DateTime.tryParse(expiryDateController[index].text),
      firstDate: DateTime.now(), // Set minimum date to current date
      lastDate: DateTime(2101),
    );
    expiryDateController[index].text = DateFormat('dd/MM/yyyy').format(picked!);
    update();
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
    String value = expiryDateController[index].text;
    for (int i = 0; i < expiryDateController.length; i++) {
      if (i != index && expiryDateController[i].text == value) {
        return true;
      }
    }
    return false;
  }

  Future getSupplier({Supplier? supplierModal}) async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      DataResponse<PaginationResponseModal<Supplier>> response = await _productApiProvider.getSupplier();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          
          // supplierList.addAll((model?.data ?? []).where((element) => element=="Implant"));
          supplierList.addAll((model?.data ?? []));
          if (supplierModal?.id != null) {
            selectedSupplier.value = supplierModal?.id;
          }
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  Future getStorage() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      customLoader.show();
      DataResponse<PaginationResponseModal<Supplier>> response = await _productApiProvider.getStorage();
      customLoader.hide();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          // if(model?.data?.isEmpty ?? true){
          //   isStorageListEmpty.value = true;
          //   addDefaultStorage();
          // }
          // if(model?.data?.isNotEmpty ?? false){
          //   Supplier? hasImplantStock = model?.data?.firstWhereOrNull((element) => element.name == "Implant Storage");
          //   if(hasImplantStock == null){
          //     isStorageListEmpty.value = true;
          //     print('Storage Name => ${hasImplantStock}');
          //      addDefaultStorage();
          //   }
          // }
          storageList.addAll(model?.data ?? []);
          if(storageList.isNotEmpty){
            isStorageListEmpty.value = false;
          }
          if (isEdit.value) {
            getProductById();
          }
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  addTagView(){
    chooseTagDialog(selectedTags: mySelectedTags).then((value) {
      if(value!.isNotEmpty ?? false){
        mySelectedTags.value = <TagModal>[];
        mySelectedTags.addAll(value.map((e) => e).toList());
        update();
      }
    });
  }

  Future addDefaultStorage() async {
    if (await Utils.hasNetwork()) {
      Map<String, dynamic> payload = HashMap();
      payload[ApiConstants.name] = "Implant Storage";
      customLoader.show();
      DataResponse<PaginationResponseModal<Supplier>> response = await _productApiProvider.postStorage(payload);
      print('supplier => ${response.response}');
      customLoader.hide();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          getStorage();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  getProductById() async {
    if (await Utils.hasNetwork()) {
      isLoading.value = true;
      customLoader.show();
      DataResponse<ProductModal> response = await _productApiProvider.getProductById(productId: products.value?.id);
      customLoader.hide();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to get data");
      } else {
        if (response.response != null) {
          var model = response.response;
          products.value = model;
          if (isEdit.value) {
            addInitialValues();
          }
          if(products.value?.tags?.isNotEmpty ?? false){
            for(var tag in products.value?.tags ?? []){
              mySelectedTags.add(TagModal(name: tag));
            }
          }
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Unable to get data");
        }
      }
    }
  }

  Future addProduct() async {
    if (await Utils.hasNetwork()) {
      List<ExpiryDataDto> expiryList = [];
      for (int i = 0; i < dynamicQuantityDateController.length; i++) {
        if (dynamicQuantityDateController[i].text.isNotEmpty || expiryDateController[i].text.isNotEmpty) {
          expiryList.add(ExpiryDataDto(
              quantity: dynamicQuantityDateController[i].text ?? "0",
              at: expiryDateController[i].text ?? "",
            price: dynamicPriceController[i].text ?? "0",
          ));
        }
      }
      List<BarCodeDataDto>? barCode = [];
      for (int i = 0; i < addBarcodes.length; i++) {
        barCode.add(BarCodeDataDto(
            removeAll: addBarcodes[i].removeAll.toString(),
            barcode: addBarcodes[i].barcode ?? "",
            symbol: addBarcodes[i].symbology ?? "0"));
      }
      String orderedAtDateString = "";
      if(dateController.text.isNotEmpty){
        DateTime inputDate = DateFormat('dd/MM/yyyy').parse(dateController.text).toUtc();
        orderedAtDateString = DateFormat('yyyy/MM/dd').format(inputDate);
      }

      List<Map<String, String>> existingImagesEncode = [];
      for(var url in imageUrlToEdit){
        existingImagesEncode.add({"file": url});
      }

      dio.FormData formData = await CreateUpdateProductDto(
              internalSupplierId: selectedSupplier.value,
              name: productNameController.text,
              manufacturer: manufactureController.text,
              minLevel: minimumLevelController.text,
              storageId: selectedStorage.value,
              price: priceController.text.isNotEmpty?priceController.text:"0",
              dontHaveSupplierCode: false.toString(),
              ProductImageMobile: myFile,
              ExistingImages: jsonEncode(existingImagesEncode),
             // ExistingImages: imageUrlToEdit,
              // productImage: File(imagePath.value),
              orderedAt: dateController.text.isNotEmpty ? "${orderedAtDateString}T00:00:00" : null,
              supplierCode: (supplierCodeController.text.isEmpty) ? "DEN${10000 + Random().nextInt(90000)}" : supplierCodeController.text,
              expiryData: expiryList,
              barCode: barCode).toJson();

      isLoading.value = true;
      customLoader.show();
      DataResponse<ProductModal> response = await _productApiProvider.addProduct(payload: formData);
      customLoader.hide();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to add product");
      } else {
        if (response.response != null) {
          var model = response.response;
          InventoryController controller1 = Get.find<InventoryController>();
          controller1.currentPage.value = 1;
          controller1.getInventoryData();
          Get.find<DashboardController>().getSummary();
          Get.back(result: "Added");
          Utils.showSnackBar("Product added successfully",isSuccess: true);
        } else {
          Utils.showSnackBar(response.error ?? "Unable to add product");
        }
      }
    }
  }



  Future editProduct() async {
    if (await Utils.hasNetwork()) {
      List<ExpiryDataDto> expiryList = [];
      for (int i = 0; i < dynamicQuantityDateController.length; i++) {
        if (dynamicQuantityDateController[i].text.isNotEmpty || expiryDateController[i].text.isNotEmpty) {
          expiryList.add(
            ExpiryDataDto(
                quantity: dynamicQuantityDateController[i].text,
                at: expiryDateController[i].text,
                price: dynamicPriceController[i].text,
              ),
          );
        }
      }
      List<BarCodeDataDto>? apiBarCode = [];
      List<String> myList = mySelectedTags.map((element) => element.name ?? "").toList();
      String tagsStringList = myList.join(',');
      apiBarCode.addAll((addBarcodes).map((e) => BarCodeDataDto(barcode: e.barcode, removeAll: (e.removeAll ?? false).toString(), symbol: e.symbology
      )).toList());

      List<Map<String, String>> existingImagesEncode = [];
      for(var url in imageUrlToEdit){
        existingImagesEncode.add({"file": url});
      }

      dio.FormData formData = await CreateUpdateProductDto(
          id: products.value?.id,
          ProductImageMobile: myFile,
          ExistingImages: jsonEncode(existingImagesEncode),
          expiryData: expiryList,
          minLevel: minimumLevelController.text,
          barCode: apiBarCode,
          TagCollection: tagsStringList
      ).toJson();
      isLoading.value = true;
      customLoader.show();
      DataResponse<ProductModal> response = await _productApiProvider.editProductV2(payload: formData, productId: products.value?.id.toString() ?? "");
      customLoader.hide();
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Unable to add product");
      } else {
        if (response.response != null) {
          InventoryController controller1 = Get.find<InventoryController>();
          controller1.currentPage.value = 1;
          controller1.getInventoryData();
          Get.find<DashboardController>().getSummary();
          Get.back(result: "Added");
        } else {
          Utils.showSnackBar(response.error ?? "Unable to add product");
        }
      }
    }
  }

  void confirmDeleteProduct() {
    if (!isEdit.value) {
      return;
    }
    confirmPopUp(
      title: 'Delete Product',
      subtitle: 'Are you sure you want to delete this product?',
      cancelText: 'Cancel',
      conFirmButtonText: 'Delete',
      onConfirm: () {
        deleteProductFromEdit();
      },
    );
  }

  Future<void> deleteProductFromEdit() async {
    final product = products.value;
    final productId = product?.id;
    final clinicKey = StorageHelper().getClinicId();
    if (productId == null || clinicKey == null || clinicKey.isEmpty) {
      Utils.showSnackBar("Unable to delete product");
      return;
    }
    if (_isDeletingProduct) {
      return;
    }
    if (await Utils.hasNetwork()) {
      _isDeletingProduct = true;
      customLoader.show();
      try {
        DataResponse response = await _productApiProvider.deleteProductBySupport(
          productId: productId.toString(),
        );
        if (response.successful == false) {
          Utils.showSnackBar(response.error ?? "Unable to delete product");
        } else {
          Utils.showSnackBar("Product deleted successfully", isSuccess: true);
          if (Get.isRegistered<InventoryController>()) {
            final InventoryController inventoryController = Get.find<InventoryController>();
            inventoryController.currentPage.value = 1;
            inventoryController.getInventoryData();
          }
          if (Get.isRegistered<DashboardController>()) {
            final DashboardController dashboardController = Get.find<DashboardController>();
            dashboardController.getSummary();
            dashboardController.updateIndex(2);
          }
          Get.until((route) => route.settings.name == AppRoutes.dashboard);
        }
      } finally {
        customLoader.hide();
        _isDeletingProduct = false;
      }
    }
  }

  /**************************************************************************************/

  Future deleteAllBarCode({required int barcodeUniqueId,required Function onSuccess}) async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      ComanResponseModal response = await _productApiProvider.deleteAllBarCode(
          barcodeUniqueId: barcodeUniqueId.toString());
      customLoader.hide();

      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          onSuccess();
          Utils.showSnackBar("All Bar Code Deleted");
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }
  Future deleteOneBarCode(
      {required DeleteBarCodeDto deleteBarCodeDto,required Function onSuccess}) async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      ComanResponseModal response = await _productApiProvider.deleteOneBarCOde(
          deleteBarCodeDto: deleteBarCodeDto);
      customLoader.hide();

      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          onSuccess();
          Utils.showSnackBar("BarCode Deleted");
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
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

  addBannerImage() {
    cameraHelper.openImagePicker(false, whenCompleted: () {});
    refresh();
  }

  @override
  void onSuccessFile(File file, String fileTy) {
    imagePath.value = file.path;
    //imageUrlToEdit.add(file.path);
   // imageUrlToEdit.value = file.path;
   // myFile.value = File(imagePath.value);
    myFile.add(File(imagePath.value));
    fileType.value = imagePath.substring(imagePath.lastIndexOf(".") + 1);
    fileName.value = file.path.split('/').last;
    imageLoading.value = false;
  }

  @override
  void onSuccessWebFile(File file, Uint8List uint8list, String fileType) {

  }
}

enum ProductType { add, edit }
