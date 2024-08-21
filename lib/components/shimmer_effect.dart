import 'package:denvin_stock/exports.dart';


class CustomShimmer extends StatelessWidget {
  Widget child;
  bool? show;


   CustomShimmer({Key? key,required this.child,this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      (show??true)?
      Shimmer.fromColors(
        period: Duration(seconds: 4),
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade400,
      child: child,
    ):child;
  }
}
class ShimmerEffectWidget extends StatelessWidget {
  final Widget child;
  final Widget? shimmerWidget;
  final bool showShimmer ;



  const ShimmerEffectWidget({super.key,required this.child,this.showShimmer=true, this.shimmerWidget});

  @override
  Widget build(BuildContext context) {
    return  showShimmer
        ? Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.black12,
        child: shimmerWidget ?? child)
        : child;
  }
}