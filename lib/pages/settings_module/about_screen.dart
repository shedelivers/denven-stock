import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/settings_module/controller/policy_page_controller.dart';
import 'package:flutter/cupertino.dart';

class AboutScreen extends GetView<PolicyPageController> {

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppBar(centerLogo: false, showBack: true, showLogo: false, title: Strings.aboutUs),
          body: _mainBody()
      ),
    );
  }

  _mainBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vGap(20.0),
          TextView("Welcome to Denven!",style: black_15_400()?.copyWith(fontWeight: FontWeight.w600),),
          vGap(10.0),
          TextView("At Denven, we are dedicated to transforming the way dental practices manage their inventory and ordering processes. Our cutting-edge application is designed to streamline stock management, ensuring dental professionals can focus more on patient care and less on administrative tasks.",maxLine: 12,style: black_15_400(),),
          vGap(20.0),
          TextView("Our Vision",style: black_15_400()?.copyWith(fontWeight: FontWeight.w600),),
          vGap(10.0),
          TextView("Our vision is to empower dental practices with a comprehensive solution that simplifies inventory management and ordering. We aim to eliminate the common challenges associated with stock control, providing a seamless, efficient, and reliable system that enhances the overall functionality of dental offices.",maxLine: 12,style: black_15_400(),),
          vGap(20.0),
          TextView("What We Do",style: black_15_400()?.copyWith(fontWeight: FontWeight.w600),),

          vGap(10.0),
          TextView("Denven is an innovative application that offers a robust stock management and ordering solution for dental practices. Here’s how we can help:",maxLine: 12,style: black_15_400(),),
          vGap(10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 4,
              ).marginOnly(top: 6),
              hGap(10),
              Expanded(child: TextView("Real-Time Inventory Management: Keep track of your inventory in real-time. Our system monitors stock levels continuously, providing you with up-to-date information at your fingertips.",maxLine: 12,style: black_15_400(),)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 4,
              ).marginOnly(top: 6),
              hGap(10),
              Expanded(child: TextView("Automated Alerts and Reordering: Never run out of essential supplies again. Denven sends automated alerts when stock levels are low and can even automate the reordering process for you.",maxLine: 12,style: black_15_400(),)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 4,
              ).marginOnly(top: 6),
              hGap(10),
              Expanded(child: TextView("Cost and Time Efficiency: By optimizing your inventory, Denven helps reduce waste and overstock, saving your practice both time and money.",maxLine: 12,style: black_15_400(),)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 4,
              ).marginOnly(top: 6),
              hGap(10),
              Expanded(child: TextView("User-Friendly Interface: Our intuitive design ensures that managing your inventory is simple and straightforward, requiring minimal training for your staff.",maxLine: 12,style: black_15_400(),)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 4,
              ).marginOnly(top: 6),
              hGap(10),
              Expanded(child: TextView("Comprehensive Reporting: Gain valuable insights into your inventory usage and trends with our detailed reporting tools. Make informed decisions to enhance the efficiency of your practice.",maxLine: 12,style: black_15_400(),)),
            ],
          ),
          vGap(20.0),
          TextView("Our Commitment",style: black_15_400()?.copyWith(fontWeight: FontWeight.w600),),
          vGap(10.0),
          TextView("We are committed to providing exceptional service and support to our users. Our team of experts is always ready to assist you, ensuring you get the most out of the Denven application. We continually update and improve our software based on user feedback and industry advancements to meet the evolving needs of dental practices.",maxLine: 12,style: black_15_400(),),
          vGap(20.0),
          TextView("Join Us",style: black_15_400()?.copyWith(fontWeight: FontWeight.w600),),
          vGap(10.0),
          TextView("Experience the future of dental practice management with Denven. Join the growing community of dental professionals who trust us to manage their inventory and ordering needs efficiently and effectively.",maxLine: 12,style: black_15_400(),),
          vGap(40.0),
      
        ],
      ).paddingSymmetric(horizontal: 30.0),
    );
    }
}