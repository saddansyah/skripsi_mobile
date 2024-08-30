import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/location.dart';
import 'dart:math' as math;

class ArContainerScreen extends ConsumerStatefulWidget {
  const ArContainerScreen({super.key, required this.container});

  final model.Container container;

  @override
  ConsumerState<ArContainerScreen> createState() => _ArContainerScreenState();
}

class _ArContainerScreenState extends ConsumerState<ArContainerScreen> {
  InAppWebViewController? webViewController;
  InAppLocalhostServer localhostServer = InAppLocalhostServer(port: 3000);

  bool isAgreed = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(streamPositionProvider);
    final heading = ref.watch(streamNavigationHeadingProvider);

    if (isAgreed) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                localhostServer.close().then(
                    (_) => Navigator.of(context, rootNavigator: true).pop());
              },
              icon: const Icon(Icons.arrow_back_rounded)),
          toolbarHeight: 72,
          title: Text('Cari Depo/Tong (AR)', style: Fonts.semibold16),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                    },
                    initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(
                            "http://127.0.0.1:3000/assets/htmls/index.html?id=${widget.container.id}"))),
                    onGeolocationPermissionsShowPrompt:
                        (controller, origin) async {
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
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: ListTile(
                          title: Text(
                            widget.container.name,
                            style: Fonts.semibold16,
                          ),
                          subtitle: Text(
                            Location.getFormattedDistance(
                              Location.getDistance(
                                  currentPosition.valueOrNull?.latitude ?? 0,
                                  currentPosition.valueOrNull?.longitude ?? 0,
                                  widget.container.lat.toDouble(),
                                  widget.container.long.toDouble()),
                            ),
                            style: Fonts.regular14,
                          ),
                          trailing: Icon(Icons.location_pin,
                              color: AppColors.greenPrimary),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -180,
                    right: 0,
                    left: 0,
                    child: Transform(
                      transform: Matrix4.identity()..rotateX(math.pi / 4),
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: (heading.value! -
                                Location.getBearing(
                                    currentPosition.value?.latitude ?? 0,
                                    currentPosition.value?.longitude ?? 0,
                                    widget.container.lat.toDouble(),
                                    widget.container.long.toDouble())) /
                            -360,
                        child: CircleAvatar(
                          radius: 200,
                          backgroundColor: AppColors.greenPrimary,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: AppColors.white,
                            size: 300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Text('Selamat Datang di Fitur AR', style: Fonts.bold18),
                  Text('...', style: Fonts.regular14),
                ],
              ),
              const SizedBox(height: 36),
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
              const SizedBox(height: 12),
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
