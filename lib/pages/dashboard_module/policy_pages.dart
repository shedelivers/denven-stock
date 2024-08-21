import 'package:denvin_stock/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyPages extends StatelessWidget {
  const PolicyPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(showLogo: false,title: "Policy Pages", centerLogo: true),
      body: Column(
        children: [
          vGap(20.0),
          SettingItemView(
            title: "Frequently Asked Questions",
            image:  imageAsset(faqIcon,height: 20.0),
            onTap: (){
              Utils.showSnackBar("Adding Soon");
              // Get.toNamed(AppRoutes.faqScreen);
            },
          ),
          _divider(),
          SettingItemView(
            title:"About Us",
            image: imageAsset(aboutIcon,height: 20.0),
            onTap: (){
              Get.toNamed(AppRoutes.aboutUs);
            },
          ),
          _divider(),
          SettingItemView(
            title:"Privacy Policy",
            image: imageAsset(privacyPolicyIcon,height: 20.0) ,
            onTap: () async {
              if (!await launchUrl(Uri.parse("https://live.denven.com/Privacy?h=669"))) {
                throw Exception('Something went wrong');
              }
            },
          ),
          _divider(),
          SettingItemView(
            title:"Terms and Conditions",
            image: imageAsset(termsIcon,height: 20.0),
            onTap: ()async{
              if (!await launchUrl(Uri.parse("https://live.denven.com/Terms?h=669"))) {
              throw Exception('Something went wrong');
              }
            },
          ),

        ],
      ),
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
