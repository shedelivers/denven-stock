

import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import "package:denvin_stock/exports.dart";
import 'full_screen_image.dart';


Widget imageAsset(String name,{double? scale, double? width, double? height, BoxFit? fit,Color? color}) =>
    Image.asset(
      name,
      height: height,
      width: width,
      fit: fit,color: color
    );


Widget imageFile(File file,
        {double? scale, double? width, double? height, BoxFit? fit}) =>
    Image.file(
      file,
      height: height,
      width: width,
      fit: fit,
    );

Widget imageMemory(Uint8List bytes,
        {double? scale, double? width, double? height, BoxFit? fit}) =>
    Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
    );

Widget imageNetwork(String url, {double? scale, double? width, double? height, BoxFit? fit}) => Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
    );

imageAssetProvider(name) => AssetImage(name);

imageNetworkProvider(name) => NetworkImage(name);

imageFileProvider(name) => FileImage(name);


Widget cachedImage(url,{double? height, double? width, BoxFit boxFit = BoxFit.contain,}) {
  return CachedNetworkImage(
      width: width,
      height: height,
      fit: boxFit,
      imageUrl: url ?? "",
      placeholder: (context, url) => const  Center(
            child: CupertinoActivityIndicator(),
          ),
      errorWidget: (context, url, error) => const Center(
            child: Icon(
              Icons.error_rounded,
              color: Colors.grey,
            ),
          ));
}

FullScreenWidget cachedImageWithView(url,{double? height, double? width, var tag, BoxFit boxFit = BoxFit.contain}) {
  return FullScreenWidget(
    isOpen: (isOpen){

    },
    disposeLevel: DisposeLevel.High,
    child: Hero(
      tag: tag,
      child: CachedNetworkImage(
          width: width,
          height: height,
          fit: boxFit,
          imageUrl: url ?? "",
          placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
          errorWidget: (context, url, error) => const Icon(
                Icons.error_rounded,
                color: Colors.grey,
              )),
    ),
  );
}
