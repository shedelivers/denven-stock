import 'package:denvin_stock/exports.dart';

class DashboardController extends GetxController {

  RxInt currentIndex = 0.obs;
  late ProductApiProvider _productApiProvider;
  Rxn<UniversalModel> summaryData = Rxn<UniversalModel>();
  RxInt basketCount = 0.obs;
  RxInt arrivedCount = 0.obs;
  // PageController pageController = PageController(
  //   initialPage: 0,
  //   keepPage: false,
  // );

  Rxn<ShimmerLoaderState> showSummeryShimmer = Rxn<ShimmerLoaderState>(ShimmerLoaderState.initial);
  Rxn<ShimmerLoaderState> showBasketShimmer = Rxn<ShimmerLoaderState>(ShimmerLoaderState.initial);
  @override
  void onInit() {
    _productApiProvider  = ProductApiProvider();
    getSummary();
    getBasketCount();
    getArrivedCount();
    super.onInit();
  }
  void updateIndex(int index) {
    currentIndex.value = index;
    update();
    // pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  void pageChange(int index) {
    currentIndex.value = index;
  }

  getSummary() async {
    if (await Utils.hasNetwork()) {
      showSummeryShimmer.value =ShimmerLoaderState.loading;
      update();
      DataResponse<UniversalModel> response = await _productApiProvider.getSummary();
      showSummeryShimmer.value = ShimmerLoaderState.fetched;
      update();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          summaryData.value = model;
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  getBasketCount() async {
    if (await Utils.hasNetwork()) {
      showBasketShimmer.value = ShimmerLoaderState.loading;
      update();
      BasketCount response = await _productApiProvider.getBasketCount();
      showBasketShimmer.value = ShimmerLoaderState.fetched;
      update();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          basketCount.value = model ?? 0;
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

  getArrivedCount() async {
    if (await Utils.hasNetwork()) {
      showBasketShimmer.value = ShimmerLoaderState.loading;
      update();
      BasketCount response = await _productApiProvider.getArrivedCount();
      showBasketShimmer.value = ShimmerLoaderState.fetched;
      update();
      if (response.successful == false) {
        Utils.showSnackBar(response.error ?? "Something went wrong");
      } else {
        if (response.response != null) {
          var model = response.response;
          arrivedCount.value = model ?? 0;
          update();
        } else {
          Utils.showSnackBar(response.error ?? "Something went wrong");
        }
      }
    }
  }

}