
import 'package:denvin_stock/exports.dart';

class CustomStockBoxItemView extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const CustomStockBoxItemView(
      {super.key,
        required this.price,
        required this.image,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextView(
          title,
          style: black_14_600(),
        ),
        vGap(4.0),
        Get.find<DashboardController>().showSummeryShimmer.value ==
                ShimmerLoaderState.loading
            ?   SpinKitThreeBounce(
          color: primaryColor,
          size: 20.0,
        )
            :
        TextView(
          price,
          style: black_17_700()?.copyWith(color: primaryColor),
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //
        //     const Spacer(),
        //     imageAsset(image, width: 22, color: Colors.white),
        //   ],
        // ),
        // vGap(10.0),

      ],
    );
  }
}