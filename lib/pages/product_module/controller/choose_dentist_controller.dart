import 'package:denvin_stock/exports.dart';

class ChooseDentistController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  PaginationResponseModal<Supplier>? allSkillResponseModal;
  List<ConsumerModal> consumerList = [];
  ConsumerModal? selectedSkillList;
  Storage? filteredItemStorage;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  static const int _pageSize = 10;
  int _currentPage = 1;
  int _total = 0;
  bool _isFetching = false;
  bool _reachedEnd = false;
  int _requestId = 0;

  bool get hasMoreData => !_reachedEnd && consumerList.length < _total;

  late ProductApiProvider _productApiProvider;

  ChooseDentistController({required ConsumerModal supplierList, Storage? filteredItem}) {
    selectedSkillList = supplierList;
    filteredItemStorage = filteredItem;
  }

  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    hitapi();
    super.onInit();
  }

  hitapi() async {
    consumerList = [];
    _currentPage = 1;
    _total = 0;
    _reachedEnd = false;
    _isFetching = false;
    isLoadingMore.value = false;
    await _fetchConsumerPage(page: 1);
  }

  Future<void> loadMoreDentists() async {
    if (_isFetching || isLoading.value || !hasMoreData) return;
    await _fetchConsumerPage(page: _currentPage + 1);
  }

  Future<void> _fetchConsumerPage({required int page}) async {
    if (!await Utils.hasNetwork()) return;
    final isFirstPage = page == 1;
    final requestId = ++_requestId;
    _isFetching = true;
    if (isFirstPage) {
      customLoader.show();
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try {
      DataResponse<PaginationResponseModal<ConsumerModal>> response =
          await _productApiProvider.getConsumer(page: page, pageSize: _pageSize);
      if (requestId != _requestId) return;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else if (response.response != null) {
        final model = response.response;
        final items = model?.data ?? [];
        consumerList.addAll(items);
        _currentPage = page;
        _total = model?.total ?? consumerList.length;
        if (items.isEmpty || (model?.total == null && items.length < _pageSize)) {
          _reachedEnd = true;
        }
        update();
      } else {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      }
    } finally {
      if (isFirstPage) customLoader.hide();
      if (requestId == _requestId) {
        _isFetching = false;
        isLoading.value = false;
        isLoadingMore.value = false;
      }
    }
  }
}