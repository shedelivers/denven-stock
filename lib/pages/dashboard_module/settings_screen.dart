import 'dart:io';

import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/dashboard_module/policy_pages.dart';
import '../../components/app_update.dart';
import '../../components/conformation_popup.dart';
import '../../components/open_url.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final formGlobalKey = GlobalKey<FormState>();

  final loginController = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: const SizedBox(),
            // title: TextView(
            //   "Settings",
            //   style: black_17_700()?.copyWith(),
            // ),
          ),
          body: mainBuild()),
    );
  }

  mainBuild() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profileHeaderView(),
          vGap(height_5),
          const Divider(
            thickness: 1,
            color: Color(0xffDDDDDD),
            height: 1,
          ),
          SettingItemView(
            title: "User Profile",
            image: imageAsset(userIcon,height: 20.0),
            onTap: ()async{
              // Utils.showSnackBar("Coming Soon");
              var refresh = await Get.toNamed(AppRoutes.userProfileScreen);
              setState(() {});
            },
          ),
          _divider(),
          SettingItemView(
            title: "Switch Clinic",
            image: imageAsset(switchIcon,height: 20.0),
            onTap: (){
              Get.toNamed(AppRoutes.clinicSelectionScreen);
            },
          ),
          _divider(),
          SettingItemView(
            title: "Dentists",
            image: imageAsset(doctorIcon,height: 20.0),
            onTap: (){
              Get.toNamed(AppRoutes.consumerScreen);
            },
          ),
          // _divider(),
          // SettingItemView(
          //   title: "Implant Report",
          //   image: const Icon(Icons.insert_page_break_sharp,size: 20,),
          //   onTap: (){
          //     Get.toNamed(AppRoutes.implantReportView);
          //   },
          // ),
          // _divider(),
          // SettingItemView(
          //   title: "My Subscription",
          //   image: const Icon(Icons.credit_card,size: 20,),
          //   onTap: (){
          //     Get.toNamed(AppRoutes.manageSubscriptionScreen);
          //   },
          // ),

        /*  _divider(),
          SettingItemView(
            title: "Training Videos",
            image: const Icon(Icons.video_library,size: 20,),
            onTap: (){
              Get.toNamed(AppRoutes.trainingVideos);
            },
          ),*/


          _divider(),
          SettingItemView(
            title: "Change Password",
            image: const Icon(Icons.password,size: 20,),
            onTap: (){
              Get.toNamed(AppRoutes.changePassword);
            },
          ),

          _divider(),
          SettingItemView(
            title: "Policy Pages",
            image: imageAsset(termsIcon,height: 20.0),
            onTap: (){
              Get.to(const PolicyPages());

            },
          ),
          _divider(),
          SettingItemView(
            title: "Rate US",
            image: const Icon(Icons.star_rate_outlined),
            onTap: (){
              if(Platform.isAndroid){
                openUrlInApp(url: Strings.appPlayStoreLink);
              }else if(Platform.isIOS){
                openUrlInApp(url: Strings.appAppStoreLink);
              }
            },
          ),
          _divider(),
          SettingItemView(
            title:"SignOut",
            image: imageAsset(signoutIcon,height: 20.0) ,
            onTap: () {
              confirmPopUp(
                  title: 'SignOut?',
                  subtitle: 'Are you sure, You want to SignOut.',
                  onConfirm: (){
                    StorageHelper().clearAll();
                    Get.offAllNamed(AppRoutes.logIn);
                  }
              );
            },
          ),
          _divider(),
          vGap (20.0),
          Obx(()=> GestureDetector(
              onTap: (){},
              child: Text("V ${loginController.appVersion}",style: const TextStyle(color: Colors.grey),))),
        ],
      ),
    );
  }

  profileHeaderView() {
    StorageHelper helper = StorageHelper();
    return Column(
      children: [
        Center(child: imageAsset(appLogo, height: height_70)),
        vGap(height_10),
        TextView(
          "${helper.getUserFirstName() ?? ""} ${helper.getUserLastName()}",
          style: black_17_700()?.copyWith(color: primaryColor),
        ),
        vGap(height_10),
      ],
    );
  }

  _divider(){
    return const Divider(
      thickness: 1,
      color: Color(0xffDDDDDD),
      height: 1,
      endIndent: 20.0,
      indent: 20.0,
    );
  }
}

class SettingItemView extends StatelessWidget {
  final String title;
  final Widget image;
  final VoidCallback? onTap;
  const SettingItemView({super.key,required this.title,required this.image,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (){},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  image,
                  hGap(14.0 ),
                  TextView(
                    title,
                    style: black_16_400()?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ).marginSymmetric(horizontal: 20.0, vertical: 16.0),
    );
  }
}
