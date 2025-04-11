import 'dart:io';
import 'dart:typed_data';
import 'package:denvin_stock/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'cropper/ui_helper.dart'

if (dart.library.io) 'cropper/mobile_ui_helper.dart'
if (dart.library.html) 'cropper/web_ui_helper.dart';


abstract class CameraOnCompleteListener {

  void onSuccessFile(File file, String fileType);

  void onSuccessWebFile(File file, Uint8List uint8list, String fileType);

}

class CameraHelper {
  final picker = ImagePicker();
  BuildContext context = Get.context!;
  // CropAspectRatioPreset? cropAspectRatioPreset;
  // CropStyle? cropStyle;
  late CameraOnCompleteListener callback;

  CameraHelper(this.callback,);

  // void setCropping(CropAspectRatioPreset cropAspectRatioPreset) {
  //   this.cropAspectRatioPreset = cropAspectRatioPreset;
  // }
  //
  // void setCroppingWithCircle(CropStyle cropStyle) {
  //   this.cropStyle = cropStyle;
  // }

  void openAttachmentDialog() async {
    if (await isStorageEnabled()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'docx',
          'xlsx',
          'pptx',
          'doc',
          'xls',
          'ppt',
          'txt'
        ],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        debugPrint(file.path);
        callback.onSuccessFile(file, "document");
      } else {
        // User canceled the picker
      }
    }
  }

  //for picking image from camera and gallery
  void openImagePicker(var showDeleteOption, {bool allowDocument = false, String title = "Choose Image", VoidCallback? whenCompleted}) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 0,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 25.sp,
                  )).paddingOnly(right: 20.w).onTap(() {Get.back();}),
              TextView(title,style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
              TextView("File size should not be above 10 MB",style: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextView("Choose from Gallery",),
                        const Spacer(),
                        const Icon(
                          Icons.image_rounded,
                          size: 25,
                        ),
                      ],
                    ).onTap(() async{
                      Navigator.pop(context);
                      getImageWithoutCropping(ImageSource.gallery);
                      // if (await isStorageEnabled()) {
                      //   Navigator.pop(context);
                      //   // docImageDoc();
                      //   getImageWithoutCropping(ImageSource.gallery);
                      // }
                    }),
                    if(allowDocument)  const Divider(
                      height: 20,
                    ),
                  if(allowDocument)  Row(
                      children: [
                        TextView("Document from files",),
                        const Spacer(),
                        const Icon(
                          Icons.file_copy_sharp,
                          size: 25,
                        ),
                      ],
                    ).onTap(() async{
                    // if (await isStorageEnabled()) {
                    //   Navigator.pop(context);
                    //   docPick();
                    // }

                    Navigator.pop(context);
                    docPick();
                    }),
                    const Divider(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextView("Open Camera App",),
                        const Spacer(),
                        const Icon(
                          Icons.camera,
                          size: 25,
                        ),
                      ],
                    ).onTap(() async {
                      Navigator.pop(context);
                      getImageWithoutCropping(ImageSource.camera);
                        // if (await isCameraEnabled()) {
                        //     Navigator.pop(context);
                        //     getImageWithoutCropping(ImageSource.camera);
                        //
                        // }
                    }),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(
              //       child: Column(
              //         children: [
              //           Container(
              //             height: 50,
              //             width: 50,
              //             decoration: const BoxDecoration(
              //                 color: Colors.white,
              //                 shape: BoxShape.circle,
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Color(0x194A841C),
              //                     offset: Offset(0.0, 1.0), //(x,y)
              //                     blurRadius: 19,
              //                   ),
              //                 ]),
              //             child: const Icon(
              //               Icons.camera_alt_rounded,
              //               size: 25,
              //               color: Colors.green,
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           const Text(
              //             "Camera",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 12),
              //           )
              //         ],
              //       ),
              //       onTap: () async {
              //         if (await isCameraEnabled()) {
              //           Navigator.pop(context);
              //           if(cropAspectRatioPreset !=null || cropStyle!=null){
              //             if(cropStyle!=null){
              //               getImageWithCircleCropping(ImageSource.camera);
              //             }else{
              //               getImageWithCropping(ImageSource.camera);
              //             }
              //           }else{
              //             getImageWithoutCropping(ImageSource.camera);
              //           }
              //         }
              //       },
              //     ),
              //     const SizedBox(
              //       width: 60,
              //     ),
              //     GestureDetector(
              //       child: Column(
              //         children: [
              //           Container(
              //             height: 50,
              //             width: 50,
              //             decoration: BoxDecoration(
              //                 color: whiteColor,
              //                 shape: BoxShape.circle,
              //                 boxShadow: const [
              //                   BoxShadow(
              //                     color: Color(0x194A841C),
              //                     offset: Offset(0.0, 1.0), //(x,y)
              //                     blurRadius: 19,
              //                   ),
              //                 ]),
              //             child: const Icon(
              //               Icons.image_rounded,
              //               size: 25,
              //               color: Colors.green,
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Text(
              //             "Gallery",
              //             style: TextStyle(
              //                 color: whiteColor,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 12),
              //           )
              //         ],
              //       ),
              //       onTap: () async {
              //         if (await isStorageEnabled()) {
              //           Navigator.pop(context);
              //           if(cropAspectRatioPreset !=null || cropStyle!=null){
              //             if(cropStyle!=null){
              //               getImageWithCircleCropping(ImageSource.gallery);
              //             }else{
              //               getImageWithCropping(ImageSource.gallery);
              //             }
              //           }else{
              //             getImageWithoutCropping(ImageSource.gallery);
              //           }
              //
              //         }
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    ).whenComplete(whenCompleted ?? (){});
  }

  // Future getImageWithCropping(ImageSource imageSource) async {
  //   XFile? imageFile =
  //   await picker.pickImage(source: imageSource, imageQuality: 50);
  //   // CroppedFile? croppedFile;
  //   if (imageFile != null) {
  //     // croppedFile = await ImageCropper().cropImage(
  //         sourcePath: imageFile.path,
  //         aspectRatioPresets: [
  //           // cropAspectRatioPreset!,
  //         ],
  //         uiSettings: buildUiSettings(context),
  //         compressQuality: 50);
  //   }
  //
  //   if (croppedFile != null) {
  //     if (GetPlatform.isWeb) {
  //       callback.onSuccessWebFile(
  //           File(croppedFile.path), await croppedFile.readAsBytes(), "image");
  //     } else {
  //       callback.onSuccessFile(File(croppedFile.path), "image");
  //     }
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  // Future getImageWithCircleCropping(ImageSource imageSource) async {
  //   XFile? imageFile =
  //   await picker.pickImage(source: imageSource, imageQuality: 50);
  //   CroppedFile? croppedFile;
  //   if (imageFile != null) {
  //     croppedFile = await ImageCropper().cropImage(
  //         sourcePath: imageFile.path,
  //         cropStyle: cropStyle!,
  //         uiSettings: buildUiSettings(context),
  //         compressQuality: 50);
  //   }
  //
  //   if (croppedFile != null) {
  //     if (GetPlatform.isWeb) {
  //       callback.onSuccessWebFile(
  //           File(croppedFile.path), await croppedFile.readAsBytes(), "image");
  //     } else {
  //       callback.onSuccessFile(File(croppedFile.path), "image");
  //     }
  //   } else {
  //     print('No image selected.');
  //   }
  // }
  Future docPick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf', 'doc','png','jpg','jpeg'], type: FileType.custom, allowMultiple: false,);
    if (result != null) {
      callback.onSuccessFile(File(result.files.single.path!), "image");
    } else {
      return null;
    }
  }

  Future docImageDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['png','jpg','jpeg'], type: FileType.custom, allowMultiple: false,);
    if (result != null) {
      callback.onSuccessFile(File(result.files.single.path!), "image");
    } else {
      return null;
    }
  }

  Future getImageWithoutCropping(ImageSource imageSource) async {
    XFile? imageFile;
    imageFile = await picker.pickImage(source: imageSource, imageQuality: 20);
    if (imageFile != null) {
      if (GetPlatform.isWeb) {
        callback.onSuccessWebFile(File(imageFile.path), await imageFile.readAsBytes(), "image");
      } else {
        callback.onSuccessFile(File(imageFile.path), "image");
      }
    } else {
      print('No image selected.');
    }
  }

  Future<bool> isCameraEnabled() async {
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      return true;
    }
    var status = await Permission.camera.request();
    print("status: " + status.toString());
    if (status == PermissionStatus.permanentlyDenied) {
      // Utils.showSnackBar(
      //     "Camera permission permanently denied, we are redirecting to you setting screen to enable permission");
      // Future.delayed(const Duration(seconds: 4), () {
      //   openAppSettings();
      // });
      dialogForOpenSetting();
      return false;
    } else if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isStorageEnabled() async {
    if (GetPlatform.isAndroid || GetPlatform.isWeb) {
      return true;
    }
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    print("status: " + status.toString());
    if (Platform.isAndroid) {
      if (status == PermissionStatus.permanentlyDenied) {
        Utils.showSnackBar(
            "Storage permission permanently denied, we are redirecting to you setting screen to enable permission");
        Future.delayed(const Duration(seconds: 4), () {
          openAppSettings();
        });
        return false;
      } else if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (status == PermissionStatus.permanentlyDenied) {
        Utils.showSnackBar("Photos permission permanently denied, we are redirecting to you setting screen to enable permission");
        Future.delayed(const Duration(seconds: 2), () {
          openAppSettings();
        });
        return false;
      } else if (status == PermissionStatus.granted ||
          status == PermissionStatus.limited) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future dialogForOpenSetting() {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
            EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 160.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: TextView(
                      "Photos permission permanently denied, we are redirecting to you setting screen to enable permission.",
                      maxLine: 3,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: TextView(
                           "Cancel",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openAppSettings();
                          },
                          child: TextView(
                            "Go to Setting",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
