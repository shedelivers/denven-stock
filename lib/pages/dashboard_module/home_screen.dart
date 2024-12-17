import 'package:denvin_stock/exports.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(centerLogo: true, showBack: false, showScanner: false),
          body: _mainBody()),
    );
  }

  _mainBody() {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<DashboardController>().getSummary();
        await Get.find<DashboardController>().getBasketCount();
        await Get.find<DashboardController>().getArrivedCount();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vGap(10.h),
            _welcomeHeading(),
            vGap(10.h),
            _banner(),
            vGap(20.h),
            _summary(),
            vGap(Get.height*0.6),
            // _productList()
          ],
        ),
      ),
    );
  }

  _welcomeHeading() {
    StorageHelper helper = StorageHelper();
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
              Strings.welcome,
              style: black_22_700(),
            ),
            TextView("${helper.getUserFirstName()} ${helper.getUserLastName()}" ?? "N/A", style: primaryColor_18_600()),
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextView(
              Strings.clinic,
              style: black_15_400(),
            ),
            TextView(helper.getClinicModel()?.name ?? "N/A", style: black_14_400()?.copyWith(color: hintTextColor)),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 20.0);
  }

  _emptyState() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageAsset(emptyStateImage).marginSymmetric(horizontal: 20.0),
          vGap(20.h),
          TextView(
            Strings.emptyHere,
            style: black_20_700(),
          ),
          vGap(10.h),
          TextView(
            Strings.addYourFirstProduct,
            style: greyColor_16_600()?.copyWith(color: blackColor),
          ),
        ],
      ),
    );
  }

  _banner() {
    return Stack(
      children: [
        Container(
          height: 164,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://nalammclinics.in/wp-content/uploads/2024/05/dental.png"),
            ),
          ),
        ),
        Container(
          height: 164,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5)
              // gradient: LinearGradient(colors: [
              //   const Color(0xFF2AC553).withOpacity(0.7),
              //   Colors.white.withOpacity(0.3)
              // ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
          ),
        ),
        Container(
          height: 164,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                "Denven Stock Management",
                style: black_17_800()?.copyWith(color: Colors.white,fontSize: 18),
              ),
              vGap(10),
              TextView(
                "Transform Your Dental Practice with Denven’s Intelligent Stock Management and Seamless Ordering Process.",
                style: black_14_400()?.copyWith(color: Colors.white,fontWeight: FontWeight.w600),
                maxLine: 3,
              ),
            ],
          ),
        )
      ],
    );
  }

  _summary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(
          "Summary",
          style: primaryColor_16_700()?.copyWith(color: black),
        ),
        vGap(10.h),
        GetBuilder<DashboardController>(
          builder: (controller) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageAsset(boxesIcon, width: 22),
                        vGap(10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              Strings.totalProducts,
                              style: black_12_600(),
                            ),
                            Obx(()=> Get.find<DashboardController>().showSummeryShimmer.value == ShimmerLoaderState.loading ?   SpinKitThreeBounce(
                                color: primaryColor,
                                size: 20.0,
                              ) : TextView(
                                Get.find<DashboardController>().summaryData.value?.totalProducts.toString() ?? "0" ,
                                style: black_17_700()?.copyWith(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).onTap(() {
                    Get.find<DashboardController>().currentIndex.value = 2;
                  }),
                ),
                hGap(5.0),
                Container(
                  height: 60,
                  width: 1.5,
                  color: textFieldBorderColor,
                ),
                hGap(5.0),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageAsset(plusMinusIcon, width: 22),
                        vGap(10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              Strings.totalQuantity,
                              style: black_12_600(),
                            ),
                            Obx(()=> Get.find<DashboardController>().showSummeryShimmer.value == ShimmerLoaderState.loading ?   SpinKitThreeBounce(
                                  color: primaryColor,
                                  size: 20.0,
                                ) : TextView(
                                Get.find<DashboardController>().summaryData.value?.totalQuantity.toString() ?? "0",
                                style: black_17_700()?.copyWith(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                hGap(5.0),
                Container(
                  height: 60,
                  width: 1.5,
                  color: textFieldBorderColor,
                ),
                hGap(5.0),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageAsset(dollarIcon, width: 22),
                        vGap(10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              Strings.totalPrice,
                              style: black_12_600(),
                            ),
                            Obx(()=>
                              Get.find<DashboardController>().showSummeryShimmer.value == ShimmerLoaderState.loading ? SpinKitThreeBounce(
                                color: primaryColor,
                                size: 20.0,
                              ) : TextView("£${Get.find<DashboardController>().summaryData.value?.totalPrice ?? "0"}",
                                style: black_17_700()?.copyWith(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
        GetBuilder<DashboardController>(
            builder: (controller) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageAsset(stockIcon, width: 22,color: Colors.black),
                          vGap(10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                "Arrived Items",
                                style: black_12_600(),
                              ),
                              Obx(()=> Get.find<DashboardController>().showSummeryShimmer.value == ShimmerLoaderState.loading ?   SpinKitThreeBounce(
                                  color: primaryColor,
                                  size: 20.0,
                                ) : TextView(
                                  Get.find<DashboardController>().arrivedCount.toString(),
                                  style: black_17_700()?.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).onTap(() {
                      Get.find<DashboardController>().currentIndex.value = 1;
                    }),
                  ),
                  hGap(5.0),
                  Container(
                    height: 60,
                    width: 1.5,
                    color: textFieldBorderColor,
                  ),
                  hGap(5.0),
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageAsset(scanIcon, width: 24),
                          vGap(10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                // "Scan or Search",
                                "Scan",
                                style: black_12_600(),
                              ),
                              TextView(
                                "Barcode",
                                style: black_17_700()?.copyWith(color: primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).onTap(() {
                       Get.find<InventoryController>().addProductFormScan(false);
                    }),
                  ),
                  hGap(5.0),
                  Container(
                    height: 60,
                    width: 1.5,
                    color: textFieldBorderColor,
                  ),
                  hGap(5.0),
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageAsset(BasketIcon, width: 24),
                          vGap(10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                "View Basket",
                                style: black_12_600(),
                              ),
                              Obx(()=> Get.find<DashboardController>().showSummeryShimmer.value == ShimmerLoaderState.loading ?   SpinKitThreeBounce(
                                  color: primaryColor,
                                  size: 20.0,
                                ) : TextView(
                                  Get.find<DashboardController>().basketCount.value.toString(),
                                  style: black_17_700()?.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).onTap(() {
                      Get.toNamed(AppRoutes.viewBasketScreen)?.then((value) {
                        controller.getBasketCount();
                      });
                    }),
                  ),
                ],
              );
            }
        ),
      ],
    ).paddingSymmetric(horizontal: 20.0);
  }

  _productList() {
    return Column(
      children: [
        Row(
          children: [
            TextView(
              "Products",
              style: primaryColor_16_700()?.copyWith(color: black),
            ),
            const Spacer(),
            TextView(
              "View All",
              style: black_12_400()?.copyWith(color: primaryColor),
            ),
          ],
        ),
        vGap(10.h),
        // ...List.generate(2, (index) {
        //   return ProductCard();
        // }),
      ],
    );
  }
}


