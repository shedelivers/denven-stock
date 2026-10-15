import 'dart:async';

import 'package:denvin_stock/exports.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  static final _controlChars = RegExp(r'[\x00-\x1F]');
  static const _scanDelay = Duration(milliseconds: 800);
  static const _diagnosticDelay = Duration(seconds: 10);

  late final MobileScannerController scannerController;
  final AudioPlayer player = AudioPlayer();

  final RxBool isCameraReady = false.obs;
  bool isScan = true;
  bool _isProcessing = false;
  bool _isClosing = false;
  bool _diagnosticDialogOpen = false;

  int detectCount = 0;
  int skippedCount = 0;
  String lastSkipReason = 'No barcode received yet';
  String lastCameraError = '';
  String lastDetectError = '';
  Timer? _diagnosticTimer;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      autoStart: true,
    );
    scannerController.addListener(_onScannerStateChanged);
    unawaited(player.setAsset('assets/scanned_beep.wav'));
  }

  void _onScannerStateChanged() {
    final state = scannerController.value;
    final running = state.isRunning;
    if (isCameraReady.value != running) {
      isCameraReady.value = running;
    }
    final error = state.error;
    if (error != null) {
      final formatted = _formatScannerException(error);
      if (lastCameraError != formatted) {
        lastCameraError = formatted;
        if (!_isClosing) {
          unawaited(showScannerDiagnostic(
            title: 'Scanner did not start',
            autoTriggered: true,
          ));
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    _diagnosticTimer?.cancel();
    _diagnosticTimer = Timer(_diagnosticDelay, () {
      if (_isClosing || _isProcessing || detectCount > 0) return;
      unawaited(showScannerDiagnostic(
        title: 'Barcode not detected',
        autoTriggered: true,
      ));
    });
  }

  @override
  void onClose() {
    _diagnosticTimer?.cancel();
    scannerController.removeListener(_onScannerStateChanged);
    unawaited(scannerController.stop());
    scannerController.dispose();
    player.dispose();
    super.onClose();
  }

  void closeScanner() {
    if (_isClosing) return;
    _isClosing = true;
    isScan = false;
    _diagnosticTimer?.cancel();
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    if (Get.currentRoute == AppRoutes.scannerScreen) {
      Get.back();
    }
    unawaited(scannerController.stop());
  }

  void handleDetectError(Object error, StackTrace stackTrace) {
    lastDetectError = error.toString();
    if (error is MobileScannerBarcodeException) {
      skippedCount++;
      lastSkipReason = 'Frame processed, no barcode in image';
      return;
    }
    unawaited(showScannerDiagnostic(
      title: 'Scanner detect error',
      autoTriggered: true,
    ));
  }

  Future<void> handleBarcodeDetect(BarcodeCapture barcodeCapture) async {
    detectCount++;
    if (!isScan || _isProcessing || _isClosing) {
      skippedCount++;
      lastSkipReason =
          'Ignored detect: isScan=$isScan, processing=$_isProcessing, closing=$_isClosing';
      return;
    }
    if (barcodeCapture.barcodes.isEmpty) {
      skippedCount++;
      lastSkipReason = 'onDetect fired with empty barcodes list';
      return;
    }

    final detected = barcodeCapture.barcodes.first;
    final raw = detected.rawValue?.replaceAll(_controlChars, '');
    final display = detected.displayValue?.replaceAll(_controlChars, '');
    final value = (display != null && display.isNotEmpty)
        ? display
        : (raw != null && raw.isNotEmpty)
            ? raw
            : '';
    if (value.isEmpty) {
      skippedCount++;
      lastSkipReason =
          'Barcode found but value empty. format=${detected.format.name}, displayValue=$display, rawValue=$raw';
      unawaited(showScannerDiagnostic(
        title: 'Barcode value was empty',
        autoTriggered: true,
      ));
      return;
    }

    _isProcessing = true;
    isScan = false;
    _diagnosticTimer?.cancel();
    final symbology = detected.format.name.toUpperCase();

    await Future.delayed(_scanDelay);

    if (_isClosing || Get.currentRoute != AppRoutes.scannerScreen) return;

    _isClosing = true;
    final result = BarcodeModal(
      removeAll: false,
      barcode: value,
      symbology: symbology,
    );

    unawaited(scannerController.stop());
    Get.back(result: result);
    unawaited(player.play());
  }

  String get diagnosticText {
    final state = scannerController.value;
    final error = state.error;
    return [
      'cameraRunning: ${state.isRunning}',
      'cameraInitialized: ${state.isInitialized}',
      'cameraStarting: ${state.isStarting}',
      'hasCameraPermission: ${state.hasCameraPermission}',
      'availableCameras: ${state.availableCameras}',
      'cameraDirection: ${state.cameraDirection.name}',
      'previewSize: ${state.size.width} x ${state.size.height}',
      'torch: ${state.torchState.name}',
      'detectCount: $detectCount',
      'skippedCount: $skippedCount',
      'lastSkipReason: $lastSkipReason',
      'lastCameraError: ${lastCameraError.isEmpty ? (error == null ? 'none' : _formatScannerException(error)) : lastCameraError}',
      'lastDetectError: ${lastDetectError.isEmpty ? 'none' : lastDetectError}',
    ].join('\n');
  }

  String _formatScannerException(MobileScannerException error) {
    final details = error.errorDetails;
    return '${error.errorCode.name}'
        '${details?.code != null ? ' | code=${details!.code}' : ''}'
        '${details?.message != null ? ' | ${details!.message}' : ''}';
  }

  Future<void> retryCamera() async {
    lastCameraError = '';
    try {
      await scannerController.stop();
      await scannerController.start();
    } catch (error) {
      lastCameraError = error.toString();
      await showScannerDiagnostic(
        title: 'Retry failed',
        autoTriggered: true,
      );
    }
  }

  Future<void> showScannerDiagnostic({
    String title = 'Scanner diagnostic',
    bool autoTriggered = false,
  }) async {
    if (_isClosing || _diagnosticDialogOpen) return;
    if (Get.context == null) return;
    _diagnosticDialogOpen = true;
    try {
      await showDialog<void>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: SelectableText(diagnosticText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(retryCamera());
                },
                child: const Text('Retry camera'),
              ),
            ],
          );
        },
      );
    } finally {
      _diagnosticDialogOpen = false;
    }
  }
}
