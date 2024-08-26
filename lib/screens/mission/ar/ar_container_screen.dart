import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/theme.dart';

class ArContainerScreen extends StatefulWidget {
  const ArContainerScreen({super.key});

  @override
  State<ArContainerScreen> createState() => _ArContainerScreenState();
}

class _ArContainerScreenState extends State<ArContainerScreen> {
  InAppWebViewController? webViewController;
  InAppLocalhostServer localhostServer = InAppLocalhostServer(port: 3000);

  bool isAgreed = false;
  bool isPermissionsGranted = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start();

    Permission.camera.request();
    Permission.location.request();

    Future.wait([
      Permission.camera.isGranted,
      Permission.location.isGranted,
    ]).then((p) {
      setState(() {
        isPermissionsGranted = p[0] && p[1];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAgreed && isPermissionsGranted) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                localhostServer.close().then(
                    (_) => Navigator.of(context, rootNavigator: true).pop());
              },
              icon: Icon(Icons.arrow_back_rounded)),
          toolbarHeight: 72,
          title: Text('Cari Depo/Tong (AR)', style: Fonts.semibold16),
          centerTitle: false,
        ),
        body: InAppWebView(
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          initialUrlRequest: URLRequest(
              url: WebUri("http://127.0.0.1:3000/assets/htmls/index.html")),
          onGeolocationPermissionsShowPrompt: (controller, origin) async {
            return GeolocationPermissionShowPromptResponse(
                allow: true, origin: origin, retain: true);
          },
          initialSettings: InAppWebViewSettings(
            geolocationEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          onPermissionRequest: (controller, permissionRequest) async {
            return PermissionResponse(
              resources: permissionRequest.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: AppColors.amber,
                ),
              ),
              SizedBox(height: 36),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: isPermissionsGranted
                    ? [
                        Text('Selamat Datang di Fitur AR', style: Fonts.bold18),
                        Text('...', style: Fonts.regular14),
                      ]
                    : [
                        Text('Maaf :(', style: Fonts.bold18),
                        Text(
                            'Akses lokasi dan kamera diharuskan untuk memulai fitur AR',
                            style: Fonts.regular14),
                      ],
              ),
              SizedBox(height: 36),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.greenPrimary,
                    foregroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    )),
                onPressed: () {
                  setState(() {
                    isAgreed = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ya, saya akan menggunakan AR',
                        style: Fonts.bold16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1, color: AppColors.greenPrimary),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    )),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 240,
                  child: Center(
                    child: Text(
                      'Kembali',
                      style: Fonts.semibold14
                          .copyWith(color: AppColors.greenPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
