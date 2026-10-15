import 'dart:collection';
import 'package:denvin_stock/components/utils/print_value.dart';
import 'package:denvin_stock/exports.dart';
import 'package:intl/intl.dart';

class UpdateQuantityController extends GetxController {
  Rxn<ProductModal> products = Rxn();
  final List<TextEditingController> textQuantityController = [];
  final List<TextEditingController> textPriceController = [];
  final List<TextEditingController> textExpireController = [];
  final List<FocusNode> textQuantityFocusNodes = [];
  final List<FocusNode> textExpireFocusNodes = [];
  final RxList<int> counter = <int>[].obs;
  final RxList<String> expiryDates = <String>[].obs;
  RxInt numberOfFoams = 1.obs;
  RxBool isLoading = false.obs;
  late ProductApiProvider _productApiProvider;

  @override
  void onInit() {
    super.onInit();
    _productApiProvider = ProductApiProvider();
    _loadFromArguments();
  }

  @override
  void onClose() {
    _disposeFieldControllers();
    super.onClose();
  }

  void _loadFromArguments() {
    _disposeFieldControllers();

    final args = Get.arguments;
    if (args == null) return;

    products.value = args[RoutesArgument.productDetails] as ProductModal?;
    _ensureExpiriesWithPrice();
    final expiriesCount = products.value?.expiriesWithPrice?.length ??
        products.value?.expiries?.length ??
        0;
    numberOfFoams.value = expiriesCount > 0 ? expiriesCount : 1;
    _initializeTextFields();
  }

  void _ensureExpiriesWithPrice() {
    final product = products.value;
    if (product == null) return;
    if (product.expiriesWithPrice?.isNotEmpty ?? false) return;

    final expiries = product.expiries ?? [];
    if (expiries.isEmpty) return;

    product.expiriesWithPrice = expiries
        .map(
          (e) => ExpiriesWithPrice(
            qty: e.qty,
            date: e.at,
            price: e.price,
            level: _levelForExpiryAt(product, e.at),
          ),
        )
        .toList();
    products.value = product;
  }

  int? _levelForExpiryAt(ProductModal product, String? at) {
    if (at == null) return null;
    for (final level in product.expiryLevel ?? []) {
      if (level.at == at) return level.level;
    }
    return null;
  }

  ExpiriesWithPrice? expiryDisplayAt(int index) {
    final rows = products.value?.expiriesWithPrice;
    if (rows == null || index < 0 || index >= rows.length) return null;
    return rows[index];
  }

  String displayPriceAt(int index) {
    final price = expiryDisplayAt(index)?.price?.toString();
    if (price == null || price == 'null' || price.isEmpty) {
      return Strings.nA;
    }
    return price;
  }

  void _disposeFieldControllers() {
    for (final controller in textQuantityController) {
      controller.dispose();
    }
    for (final controller in textPriceController) {
      controller.dispose();
    }
    for (final controller in textExpireController) {
      controller.dispose();
    }
    for (final node in textQuantityFocusNodes) {
      node.dispose();
    }
    for (final node in textExpireFocusNodes) {
      node.dispose();
    }

    textQuantityController.clear();
    textPriceController.clear();
    textExpireController.clear();
    textQuantityFocusNodes.clear();
    textExpireFocusNodes.clear();
    counter.clear();
    expiryDates.clear();
  }

  void _initializeTextFields() {
    final expiries = products.value?.expiries ?? [];
    for (var i = 0; i < numberOfFoams.value; i++) {
      final expiry = i < expiries.length ? expiries[i] : null;
      textQuantityController.add(TextEditingController());
      textPriceController.add(TextEditingController());
      textExpireController.add(TextEditingController());
      textQuantityFocusNodes.add(FocusNode());
      textExpireFocusNodes.add(FocusNode());
      expiryDates.add(expiry?.at ?? 'N/A');
      textQuantityController[i].text = expiry?.qty?.toString() ?? '0';
      textPriceController[i].text = expiry?.price?.toString() ?? '0';
      textExpireController[i].text = expiry?.at ?? '';
      counter.add(0);
    }
  }

  String convertExpiryDateFormat(String originalDateString) {
    final originalFormat = DateFormat('dd/MM/yyyy');
    final targetFormat = DateFormat('dd MMMM yyyy');
    try {
      final originalDate = originalFormat.parse(originalDateString);
      return targetFormat.format(originalDate);
    } catch (e) {
      return originalDateString;
    }
  }

  Future<void> getExpiryDate(int index) async {
    final picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      fieldHintText: 'dd/mm/yyyy',
      context: Get.context!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked == null) return;
    textExpireController[index].text = DateFormat('dd/MM/yyyy').format(picked);
    update();
  }

  void addCount(int index) {
    if (textQuantityController[index].text != '0') {
      counter[index] = counter[index] + 1;
      final tempQty = products.value?.expiries?[index].qty ?? 0;
      textQuantityController[index].text = (tempQty - counter[index]).toString();
    }
  }

  void minusCount(int index) {
    if (counter[index] > 0) {
      counter[index] = counter[index] - 1;
      final tempQty = products.value?.expiries?[index].qty ?? 0;
      textQuantityController[index].text = (tempQty - counter[index]).toString();
    }
  }

  Future<void> submit() async {
    if (!await Utils.hasNetwork()) return;

    final expiryList = <Map<String, dynamic>>[];
    for (var i = 0; i < numberOfFoams.value; i++) {
      if (textQuantityController[i].text.isNotEmpty ||
          textExpireController[i].text.isNotEmpty) {
        expiryList.add({
          'qty': textQuantityController[i].text,
          'at': textExpireController[i].text,
          'price': textPriceController[i].text == 'null' ||
                  textPriceController[i].text.isEmpty
              ? '0'
              : textPriceController[i].text,
        });
      }
    }

    final payload = {
      'Id': products.value?.id,
      'expiries': expiryList,
    };

    printValue(tag: 'NOW PAYLOAD IS:', payload);

    isLoading.value = true;
    final response = await _productApiProvider.updateProductQty(
      id: products.value?.id.toString() ?? '',
      payload: payload,
    );
    isLoading.value = false;

    printValue(tag: 'RESPONSE IS:', response.successful);

    if (response.successful == false) {
      Utils.showSnackBar(response.error ?? 'Something went wrong');
      return;
    }

    Get.back(result: 'refresh');
  }

  Color getExpiryColor({
    required List<ExpiriesWithPrice> list,
    String? date,
    required int index,
  }) {
    if (list.isEmpty || index < 0 || index >= list.length) {
      return Colors.grey;
    }

    final level = list[index].level ?? 0;
    if (level == 1) {
      return Colors.redAccent;
    }
    if (level == 2) {
      return const Color(0xfff17a00);
    }
    if (level == 3) {
      return const Color(0xfffda600);
    }
    if (level == 4) {
      return const Color(0xff1ec1b0);
    }
    return Colors.grey;
  }
}
