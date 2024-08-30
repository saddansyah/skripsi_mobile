import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/card/card.dart';
import 'package:skripsi_mobile/models/ui/menu.dart';
import 'package:skripsi_mobile/theme.dart';

class MissionScreen extends ConsumerStatefulWidget {
  const MissionScreen({super.key});

  @override
  ConsumerState<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends ConsumerState<MissionScreen> {
  bool hasPermission = false;
  @override
  void initState() {
    super.initState();

    checkPermissionStatus();
  }

  void checkPermissionStatus() async {
    final locationStatus = await Permission.locationWhenInUse.status;
    final cameraStatus = await Permission.camera.status;

    if (mounted) {
      setState(() {
        hasPermission = locationStatus == PermissionStatus.granted &&
            cameraStatus == PermissionStatus.granted;
      });
    }
  }

  void requestPermissions() async {
    await Permission.locationWhenInUse.request();
    await Permission.camera.request();

    checkPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final locationService = ref.watch(locationServiceProvider);

    return Scaffold(
      appBar: StyledAppBar.main(title: 'Misi'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: locationService.when(
          data: (status) {
            return !hasPermission || status == ServiceStatus.disabled
                ? Column(
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
                      Column(
                        children: [
                          Text('Oops, Tunggu Dulu 🤔', style: Fonts.bold18),
                          const SizedBox(height: 6),
                          Text(
                            'Misi memerlukan akses lokasi untuk mapping dan akses kamera untuk fitur',
                            style: Fonts.regular14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.greenPrimary,
                            foregroundColor: AppColors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                        onPressed:
                            hasPermission && status == ServiceStatus.disabled
                                ? () => openAppSettings()
                                : () => requestPermissions(),
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 240,
                          child: Text(
                            hasPermission && status == ServiceStatus.disabled
                                ? 'Nyalakan Lokasi/GPS'
                                : 'Request Permission',
                            style: Fonts.bold16,
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.greenPrimary,
                            Colors.green[800]!
                          ]),
                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('#learn1',
                                style: Fonts.regular14
                                    .copyWith(color: AppColors.white)),
                            const SizedBox(height: 6),
                            Text(
                              'Pemilahan Sampah 101',
                              style: Fonts.bold18.copyWith(
                                  color: AppColors.white, fontSize: 21),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(12)),
                                  color: AppColors.dark1.withOpacity(0.1)),
                              child: Text(
                                'Sebelum kamu memulai misi Kumpul Sampah!, ada baiknya kamu belajar pemilahan sampah secara singkat dulu ya..',
                                style: Fonts.regular14
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.greenPrimary,
                                  foregroundColor: AppColors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  )),
                              onPressed: () {
                                // Root navigate to learn (index 3)
                                ref.read(navigationPageProvider).animateTo(3);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_rounded,
                                      color: AppColors.white,
                                      weight: 100,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Buka Menu Belajar',
                                      style: Fonts.bold16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Flexible(
                        child: GridView.builder(
                          itemCount: missionMenu.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          itemBuilder: (m, i) => Card(
                            missionMenu[i],
                            isRootNavigator: true,
                          ),
                        ),
                      ),
                    ],
                  );
          },
          error: (e, _) => ErrorScreen(
            buttonText: 'Muat Ulang',
            message: e.toString(),
            isRefreshing: locationService.isRefreshing,
            onPressed: () {
              ref.invalidate(locationServiceProvider);
            },
          ),
          loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.greenPrimary),
          ),
        ),
      ),
    );
  }
}
