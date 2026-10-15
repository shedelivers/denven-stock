import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/product_module/controller/choose_dentist_controller.dart';
import 'package:denvin_stock/pages/product_module/controller/choose_storage_controller.dart';

Future<ConsumerModal?> chooseDentistDialog({required ConsumerModal selectedItem,Storage? filterItem, List<int>? disabledList}) {
  return Get.dialog<ConsumerModal?>(
    Container(
      alignment: Alignment.center,
      child: Container(
          height: Get.height * 0.8,
          width: Get.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: margin_10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius_20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextView(
                    "Choose Your Dentist",
                    style: black_17_700()?.copyWith(color: primaryColor),
                  ).marginSymmetric(vertical: margin_15, horizontal: margin_15),
                  const Spacer(),
                  IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close))
                ],
              ).marginSymmetric(horizontal: 10.0),
              Expanded(child: ChooseDentistView(
                selectedItem: selectedItem,
                disabledList: disabledList,
                filterItem: filterItem,
              )),
            ],
          )),
    ),
  );
}

class ChooseDentistView extends GetView<ChooseDentistController> {

  final ConsumerModal selectedItem;
  final Storage? filterItem;
  final List<int>? disabledList;

  ChooseDentistView({Key? key, required this.selectedItem,this.filterItem ,required this.disabledList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseDentistController(supplierList: selectedItem,filteredItem: filterItem));
    return GetBuilder<ChooseDentistController>(builder: (controller) {
      return StatefulBuilder(builder: (context, setState) {
        return Obx(
          ()=> Column(
            children: [
              // _searchFieldView(context: context),
             controller.isLoading.value ? const Expanded(child: SizedBox()) : controller.consumerList.isEmpty ? Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.noDataFound(message: "No dentist found"),
                  vGap(10.0),
                  Container(
                    width: 100.0,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    child: Center(
                      child: TextView("Add New",style: whiteColor_18_700()?.copyWith(fontSize: 16),),
                    ),
                  ).onTap(() {
                    Get.toNamed(AppRoutes.addConsumerScreen)?.then((value) {
                      if (value == "ADDED") {
                        controller.hitapi();
                      }
                    });
                  })
                ],
              )) :  Expanded(
                child: NotificationListener<Notification>(
                  onNotification: (notification) {
                    ScrollMetrics? metrics;
                    if (notification is ScrollUpdateNotification) {
                      metrics = notification.metrics;
                    } else if (notification is ScrollMetricsNotification) {
                      metrics = notification.metrics;
                    }
                    if (metrics != null && metrics.axis == Axis.vertical && metrics.extentAfter < 200) {
                      controller.loadMoreDentists();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: margin_0),
                    itemCount: controller.consumerList.length + (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.consumerList.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                        );
                      }
                      ConsumerModal? item = controller.consumerList[index];
                      return Row(
                        children: [
                          Checkbox(
                              activeColor: disabledList!.contains(item.id) ? primaryColor.withOpacity(0.5) : primaryColor,
                              value: controller.selectedSkillList?.id == item.id || disabledList!.contains(item.id),
                              onChanged: (bool? value) {
                                if(!disabledList!.contains(item.id)){
                                  if(value ?? false){
                                    controller.selectedSkillList = item;
                                  }
                                }
                                setState(() {});
                                controller.update();
                              }),
                          TextView("${item.firstname ?? ""} ${item.lastname ?? ""}",style: TextStyle(color: disabledList!.contains(item.id) ? Colors.grey : Colors.black),).paddingSymmetric(horizontal: 10.0, vertical: 8.0),
                        ],
                      ).marginSymmetric(horizontal: 16);
                    }),
                ),
              ),
              AppButton(
                  buttonText: "Select",
                  buttonColor: primaryColor,
                  onTap: () {
                    ConsumerModal consumer = controller.consumerList.firstWhere((element) => element.id == controller.selectedSkillList?.id);
                    Get.back(result: consumer);
                  }).marginSymmetric(horizontal: margin_20)
            ],
          ),
        );
      });
    });
  }

  _searchFieldView({required BuildContext context}) {
    return CustomTextFieldV3(
      hintText: "Search Storage",
      controller: controller.searchController,
      focusNode: controller.searchFocusNode,
      onFieldSubmitted: (String? value) =>
          FocusScope.of(Get.context!).unfocus(),
      onChanged: (value) {
        // controller.currentPage.value = 0;
        // if (controller.debounce?.isActive ?? false) {
        //   controller.debounce?.cancel();
        // }
        // controller.debounce =
        //     Timer(const Duration(milliseconds: 500), () {
        //       controller.getImplantStockData();
        //     });
      },
      suffix: IconButton(
        onPressed: () {
          controller.hitapi();
        },
        icon: imageAsset(search, height: 16.0),
      ),
    ).marginSymmetric(horizontal: margin_20, vertical: margin_10);
  }
}