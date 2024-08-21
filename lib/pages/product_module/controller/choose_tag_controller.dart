import 'package:denvin_stock/exports.dart';

class ChooseTagController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  PaginationResponseModal<Supplier>? allSkillResponseModal;
  RxList<TagModal> tagList = <TagModal>[].obs;
  RxList<String> suggestionTagList = <String>[""].obs;
  RxList<TagModal> selectedTag =  <TagModal>[].obs;
  RxInt currentPage = 1.obs;
  DataResponse<PaginationResponseModal<TagModal>>? tagResponse;
  late ProductApiProvider _productApiProvider;
  RxBool isTextFieldFocused = false.obs;
  RxBool isLoading = false.obs;
  RxString searchKeyWord = "".obs;
  Rxn<String> initialSelectedTag = Rxn();
  Timer? debounce;


  ChooseTagController({required List<TagModal>? selectedTags}) {
    tagResponse = null;
    currentPage.value = 1;
    selectedTag.value = selectedTags ?? [];
  }

  @override
  void onInit() {
    _productApiProvider = ProductApiProvider();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(_handleFocusChange);
    hitApi();
    super.onInit();
  }

  void _handleFocusChange() {
    isTextFieldFocused.value = searchFocusNode.hasFocus;
  }


  num getTotalPage() {
    num totalPage = (tagResponse?.response?.total ?? 1) / (tagResponse?.response?.pageSize ?? 1);
    if ((tagResponse?.response?.total ?? 1) % (tagResponse?.response?.pageSize ?? 1) != 0) {
      totalPage = totalPage + 1;
    }
    return totalPage;
  }


  hitApiGetSuggestions(String? search) async {
    if (await Utils.hasNetwork()) {
      suggestionTagList.value = [];
      isLoading.value = true;
      TagSuggestion response = await _productApiProvider.getSuggestionTags(searchKeyword: search);
      isLoading.value = false;
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          suggestionTagList.addAll(model?.data ?? []);
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
    customLoader.hide();
  }


  hitApi() async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      tagList.value = [];
      tagResponse = await _productApiProvider.getTags(pageNo: currentPage.value,pageSize: currentPage.value == 1 ? 5 : 10);
      customLoader.hide();
      if (tagResponse?.successful == false) {
        Utils.showSnackBar(tagResponse?.error ?? "Something went wrong");
      } else {
        if (tagResponse?.response != null) {
          var model = tagResponse?.response;
          tagList.addAll(model?.data ?? []);
          update();
        } else {
          Utils.showSnackBar(tagResponse?.error ?? "Something went wrong");
        }
      }
    }
    customLoader.hide();
  }

  hitApiLoadMore() async {
    if (await Utils.hasNetwork()) {
      customLoader.show();
      tagResponse = await _productApiProvider.getTags(pageNo: currentPage.value);
      customLoader.hide();
      if (tagResponse?.successful == false) {
        Utils.showSnackBar(tagResponse?.error ?? "Something went wrong");
      } else {
        if (tagResponse?.response != null) {
          var model = tagResponse?.response;
          tagList.addAll(model?.data ?? []);
          update();
        } else {
          Utils.showSnackBar(tagResponse?.error ?? "Something went wrong");
        }
      }
    }
  }
}