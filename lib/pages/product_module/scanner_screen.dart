// Temporarily stubbed out so the project can build on the iOS Simulator.
// The real scanner depends on `ai_barcode_scanner` / `mobile_scanner`, whose
// underlying Google MLKit pods ship fat-frameworks without an arm64
// iOS-Simulator slice. Re-enable the import + AiBarcodeScanner widget when
// building for a real device.
import 'package:denvin_stock/exports.dart';

class ScannerScreen extends GetView<ScannerController> {
  late AudioPlayer player;

  ScannerScreen({super.key}) {
    player = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setAsset('assets/scanned_beep.wav');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: TextView("Scan", style: whiteColor_18_700()),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_outlined,
                color: Colors.white, size: 26),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "Barcode scanner is disabled on the iOS Simulator.\nRun on a physical device to scan.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}