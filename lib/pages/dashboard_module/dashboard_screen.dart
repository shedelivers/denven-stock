import 'dart:io';

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/dashboard_module/scan_arrived_items_screen.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:upgrader/upgrader.dart';



class DashboardScreen extends GetView<DashboardController> {

  int selectedIndex = 0;

  final List<Widget> _pages = [HomeScreen(), ScanArrivedItemsScreen() , InventoryStockScreen(), SettingsScreen()];

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> MyAnnotatedRegion(
        child: UpgradeAlert(
          dialogStyle: Platform.isIOS? UpgradeDialogStyle.cupertino:UpgradeDialogStyle.material,
          child: Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20 ), topRight:Radius.circular(13)),
              child: BottomNavigationBar(
                selectedItemColor: whiteColor,
                unselectedItemColor: unSelectedNevTextColor,
                type: BottomNavigationBarType.fixed,
                backgroundColor: primaryColor,
                onTap: controller.updateIndex,
                unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                    color: unSelectedNevTextColor,
                    fontWeight: FontWeight.w600
                ),
                selectedLabelStyle: TextStyle(
                    fontSize: 12,
                    color: whiteColor,
                    fontWeight: FontWeight.w600
                ),
                currentIndex: controller.currentIndex.value,
                items: [
                  BottomNavigationBarItem(
                    icon: imageAsset(homeIcon,height: 20.0,width: 20.0,color: controller.currentIndex.value == 0 ? whiteColor : unSelectedNevTextColor),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: imageAsset(scanIcon,height: 20.0,width: 20.0,color: controller.currentIndex.value == 1 ? whiteColor : unSelectedNevTextColor),
                    label: "Scan Arrived Items",
                  ),
                  BottomNavigationBarItem(
                    icon: imageAsset(stockIcon,height: 20.0,width: 20.0,color: controller.currentIndex.value == 1 ? whiteColor : unSelectedNevTextColor),
                    label: "Stock",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu,color: controller.currentIndex.value == 2 ? whiteColor : unSelectedNevTextColor,),
                    label: "Menu",
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                _mainBody(),
                if (controller.currentIndex.value == 0) _intercomLauncher(context),
              ],
            ),

          ),
        ),
      ),
    );

  }

  _mainBody(){
    return _pages[controller.currentIndex.value];

    //   PageView(
    //   controller: controller.pageController,
    //   onPageChanged: controller.pageChange,
    //   children: _pages,
    // );
  }

  Widget _intercomLauncher(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 20,
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: const CircleBorder(),
        color: primaryColor,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Intercom.instance.displayMessenger(),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

}