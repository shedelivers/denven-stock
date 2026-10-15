import 'dart:async';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:denvin_stock/exports.dart';

class ScannerScreen extends GetView<ScannerController> {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAnnotatedRegion(
      isDark: true,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) controller.closeScanner();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.black,
            systemOverlayStyle: statusBarTheme(isDark: true),
            title: TextView('Scan', style: whiteColor_18_700()),
            centerTitle: true,
            leading: IconButton(
              onPressed: controller.closeScanner,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final cutOutSize = constraints.maxWidth * 0.72;
              final scanWindow = Rect.fromCenter(
                center: Offset(
                  constraints.maxWidth / 2,
                  constraints.maxHeight / 2,
                ),
                width: cutOutSize,
                height: cutOutSize,
              );

              return Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: controller.scannerController,
                    fit: BoxFit.cover,
                    scanWindow: scanWindow,
                    onDetect: controller.handleBarcodeDetect,
                    onDetectError: controller.handleDetectError,
                    errorBuilder: (context, error) {
                      return ColoredBox(
                        color: Colors.black,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Camera error:\n${error.errorCode.name}\n${error.errorDetails?.message ?? ''}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                    placeholderBuilder: (context) => const ColoredBox(
                      color: Colors.black,
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: OverlayShape(
                          borderColor: Colors.white,
                          borderWidth: 4,
                          borderLength: 36,
                          borderRadius: 12,
                          overlayColor: const Color.fromRGBO(0, 0, 0, 0.55),
                          cutOutSize: cutOutSize,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isCameraReady.value
                        ? const SizedBox.shrink()
                        : const ColoredBox(
                            color: Colors.black,
                            child: Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: SafeArea(
                      child: TextButton(
                        onPressed: () {
                          unawaited(controller.showScannerDiagnostic(
                            title: 'Why is it not scanning?',
                          ));
                        },
                        child: const Text(
                          "Can't scan? Tap for details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
