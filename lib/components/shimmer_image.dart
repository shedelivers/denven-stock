import 'package:denvin_stock/exports.dart';

class ShimmerImage extends StatelessWidget {
  ShimmerImage(
      {super.key,
      required this.url,
      this.thumbnail,
      this.fit,
      this.height,
      this.width,
      this.withBaseUrl});
  String url;
  String? thumbnail;
  BoxFit? fit;
  double? height;
  double? width;
  bool? withBaseUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: (withBaseUrl ?? false)
            ? "${ApiConstants.baseUrlForImage}/$url"
            : url,
        fit: fit ?? BoxFit.cover,
        cacheKey: url,
        height: height,
        width: width,
        placeholder: (context, url) =>
            // thumbnail != null
            //     ? Image.network(
            //         thumbnail!,
            //         fit: BoxFit.cover,
            //       )
            //     :
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: shimmerCard(),
            ),
        errorWidget: (context, url, error) => Container(
              // color: Colors.grey.shade200,
              child: Center(
                  child: (thumbnail != null) ? imageAsset(thumbnail ?? fileIcon) : imageAsset(fileIcon)),
            )
        // const Icon(
        //   Icons.error,
        // ),
        );
  }

  Widget shimmerCard() {
    return Container(color: Colors.grey);
  }
}
