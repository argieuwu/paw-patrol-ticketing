import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;
  bool isScanning = true;
  String statusMessage = 'Scan passenger QR code';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Ticket Scanner'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {
                isFlashOn = !isFlashOn;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top status/info area
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  child: Column(
                    children: [
                      Text(
                        'Bus Ticket Scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statusMessage,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Bottom controls/info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (result != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Scan Result',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text('Code: ${result!.code}'),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isScanning = !isScanning;
                            result = null;
                            statusMessage = 'Scan passenger QR code';
                            isScanning
                                ? controller?.resumeCamera()
                                : controller?.pauseCamera();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: Text(
                          isScanning ? 'Pause Scanning' : 'Resume Scanning',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanning) return;

      setState(() {
        result = scanData;
        statusMessage = 'Verifying ticket...';
      });

      // Add delay to prevent multiple scans
      await controller.pauseCamera();
      await _verifyTicket(result!.code.toString());
      await Future.delayed(Duration(seconds: 2));
      await controller.resumeCamera();
    });
  }

  Future<void> _verifyTicket(String code) async {
    try {
      // For demo - in real app, this would be an API call to verify the ticket
      if (code.contains('ticket_')) {
        setState(() {
          statusMessage = '✅ Ticket Validated Successfully';
        });
      } else {
        setState(() {
          statusMessage = '❌ Invalid Ticket';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = '⚠️ Error verifying ticket';
      });
    }
  }

  Future<void> launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      setState(() {
        statusMessage = 'Could not launch URL';
      });
    }
  }
}