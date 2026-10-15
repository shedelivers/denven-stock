

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/consumer_module/controller/consumer_controller.dart';

class ConsumerScreen extends GetView<ConsumerController> {
  const ConsumerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: myAppBar(
              showLogo: false,
              centerLogo: true,
              title: "Dentists",
              titleColor: primaryColor,
              showOcrButton: IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.addConsumerScreen)?.then((value) {
                          controller.isEdit.value = false;
                          if (value == "ADDED") {
                            controller.getCustomer();
                          }
                        });
                      },
                      icon: const Icon(Icons.add)).marginOnly(right: 10.0)),
          body: _mainBody()),
    );
  }

  _mainBody() {
    return Obx(
      () => Column(
        mainAxisAlignment: controller.consumerList.isEmpty || controller.isLoading.value ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          vGap(20.0),
              controller.isLoading.value ? Utils.screenLoading() : controller.consumerList.isEmpty ?
              Column(
                children: [
                  Utils.noDataFound(message: "No dentist found"),
                  vGap(10.0),
                  Container(
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Add Dentist",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                        hGap(4.0),
                        const Icon(Icons.add,color: Colors.white,)
                      ],
                    ),
                  ).onTap(() {
                    Get.toNamed(AppRoutes.addConsumerScreen)?.then((value) {
                      controller.isEdit.value = false;
                      if (value == "ADDED") {
                        controller.getCustomer();
                      }
                    });
                  }),
                ],
              )
                  : Expanded(
                      child: NotificationListener<Notification>(
                        onNotification: _onScrollNotification,
                        child: ListView.separated(
                          separatorBuilder: (_, index) => vGap(10.0),
                          itemCount: controller.consumerList.length + (controller.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (_, index) {
                            if (index >= controller.consumerList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                              );
                            }
                            var consumer = controller.consumerList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: textFieldBorderColor, width: 1)),
                              child: Row(
                                children: [
                                  Text(consumer.firstname ?? Strings.nA,style: black_16_400(),),
                                  hGap(4.0),
                                  Text(consumer.lastname ?? Strings.nA),
                                  const Spacer(),
                                  IconButton(onPressed: (){
                                    controller.isEdit.value = true;
                                    controller.editingConsumer.value = consumer;
                                    Get.toNamed(AppRoutes.addConsumerScreen,)?.then((value) {
                                      controller.isEdit.value = false;
                                      if (value == "EDITED") {
                                        controller.getCustomer();
                                      }
                                    });
                                  }, icon: const Icon(Icons.edit)),
                                  IconButton(onPressed: (){showAlertDialog(consumer.id.toString());}, icon: const Icon(Icons.delete)),
                                ],
                              ),
                            );
                          }),
                      ),
                    )
        ],
      ),
    );
  }

  bool _onScrollNotification(Notification notification) {
    ScrollMetrics? metrics;
    if (notification is ScrollUpdateNotification) {
      metrics = notification.metrics;
    } else if (notification is ScrollMetricsNotification) {
      metrics = notification.metrics;
    }
    if (metrics != null && metrics.axis == Axis.vertical && metrics.extentAfter < 200) {
      controller.loadMoreCustomers();
    }
    return false;
  }

  void showAlertDialog(String consumerId) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap(20.0),
              TextView("Are you sure?", style: black_17_600(),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              TextView("You want to delete the consumer",maxLine: 3, style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),).marginSymmetric(horizontal: 20.0),
              vGap(10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                        },
                        child: Text("No", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                    InkWell(
                        borderRadius: BorderRadius.circular(6.0),
                        onTap: (){
                          Get.back();
                          controller.deleteConsumer(consumerId);
                        },
                        child: Text("Yes", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                  ],
                ),
              ).marginSymmetric(horizontal: 10.0),
              vGap(20.0),
            ],
          ),
        );
      },
    );
  }
}
