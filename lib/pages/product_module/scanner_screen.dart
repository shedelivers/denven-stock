import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:denvin_stock/exports.dart';


class ScannerScreen extends GetView<ScannerController> {

  late AudioPlayer player;
  ScannerScreen({super.key}) {
    isScan = true;
    player = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setAsset('assets/scanned_beep.wav');
    });
  }

  String barcode = "";
  bool isScan = true;
  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
          body: _mainBody()
      ),
    );
  }

  _mainBody(){
    return Stack(
      children: [
        AiBarcodeScanner(
          canPop: false,
          bottomBar: const SizedBox(),
          onScan: (String value) {
            // if(isScan){
            //   isScan = false;
            //   if(value.isNotEmpty){
            //     Get.back(result: BarcodeModal(removeAll: false, barcode: value, symbology: "Code ${value.substring(value.length - 4)}"));
            //   } else {
            //     Get.back();
            //     Utils.showSnackBar("Unable to detect QR/Barcode");
            //   }
            // }
          },
          onDetect: (BarcodeCapture barcodeCapture) async {
            print(barcodeCapture);
            if(isScan){
              isScan = false;
              if(barcodeCapture.barcodes.isNotEmpty){
                Get.back(result: BarcodeModal(removeAll: false, barcode: barcodeCapture.barcodes.first.rawValue, symbology: barcodeCapture.barcodes.first.format.name.toUpperCase()));
                await player.play();
              } else {
                Get.back();
                Utils.showSnackBar("Unable to detect QR/Barcode");
              }
            }
          },
        ),
        AppBar(backgroundColor: Colors.transparent,title: TextView("Scan",style: whiteColor_18_700(),),centerTitle: true,leading: IconButton(
          onPressed: ()=> Get.back(),
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white, size: 26),
        ).marginOnly(left: 10.0)),
      ],
    );
  }

}