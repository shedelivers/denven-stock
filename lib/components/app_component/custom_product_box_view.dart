import 'package:denvin_stock/exports.dart';

class CustomProductBoxView extends StatelessWidget {
  final String title;
  final String subtitle;
  const CustomProductBoxView({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(title, style: black_14_500(),),
        TextView(subtitle, style: greyColor_16_600()?.copyWith(color: primaryColor, fontSize: 14)),
      ],
    );
  }
}