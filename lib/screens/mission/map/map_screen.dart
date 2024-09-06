import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/container_detail_screen.dart';
import 'package:skripsi_mobile/shared/card/nearest_container_card.dart';
import 'package:skripsi_mobile/theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static final controller = MapController();
  List<Marker> allMarkers = [];
  bool isNearestShowed = false;

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(streamPositionProvider);
    final currentStaticPosition = ref.watch(currentPositionProvider);
    final heading = ref.watch(streamNavigationHeadingProvider);
    final nearest = ref.watch(nearestContainerProvider(50));

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          title: Text('Map Depo/Tong', style: Fonts.semibold16),
          centerTitle: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'nearestContainer',
              onPressed: () {
                setState(() {
                  isNearestShowed = !isNearestShowed;
                });
              },
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.greenPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              enableFeedback: true,
              icon: const Icon(Icons.location_pin),
              label: Text(
                'Depo/Tong Terdekat',
                style: Fonts.semibold14,
              ),
            ),
            const SizedBox(width: 6),
            FloatingActionButton(
              heroTag: 'myLocation',
              onPressed: () {
                controller.move(
                    LatLng(currentPosition.value?.latitude ?? 0,
                        currentPosition.value?.longitude ?? 0),
                    18);
              },
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.bluePrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              enableFeedback: true,
              child: const Icon(Icons.my_location_rounded),
            ),
          ],
        ),
        body: nearest.when(
          data: (c) => Stack(
            children: [
              FlutterMap(
                mapController: controller,
                options: MapOptions(
                    interactionOptions:
                        const InteractionOptions(flags: InteractiveFlag.all),
                    backgroundColor: AppColors.lightGrey,
                    initialCenter: LatLng(currentPosition.value!.latitude,
                        currentPosition.value!.longitude),
                    initialZoom: 18),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.saddansyah.skripsi_mobile',
                  ),
                  MarkerLayer(markers: [
                    // User Location
                    Marker(
                      point: LatLng(currentPosition.value?.latitude ?? 0,
                          currentPosition.value?.longitude ?? 0),
                      width: 48,
                      height: 48,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 0),
                        turns: heading.value! / 360,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(99)),
                              color: AppColors.greenPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greenSecondary,
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ]),
                          child: Icon(
                            Icons.navigation_rounded,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    ...c.map((c) {
                      return Marker(
                        rotate: true,
                        point: LatLng(c.lat.toDouble(), c.long.toDouble()),
                        width: 90,
                        height: 90,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ContainerDetailScreen(id: c.id)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                c.name,
                                style: Fonts.semibold14.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                              const SizedBox(height: 3),
                              SvgPicture.asset(
                                  'assets/svgs/container_icon.svg'),
                            ],
                          ),
                        ),
                      );
                    })
                  ])
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: nearest.when(
                  error: (e, s) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Tidak ada data',
                      style: Fonts.semibold14,
                    ),
                  ),
                  loading: () =>
                      LinearProgressIndicator(color: AppColors.greenPrimary),
                  data: (d) => NearestContainerCard(
                      isVisible: isNearestShowed,
                      controller: controller,
                      currentStaticPosition: currentStaticPosition.value!,
                      bound: LatLngBounds(
                        LatLng(currentStaticPosition.value?.latitude ?? 0,
                            currentStaticPosition.value?.longitude ?? 0),
                        LatLng(nearest.value?.first.lat.toDouble() ?? 0,
                            nearest.value?.first.long.toDouble() ?? 0),
                      ),
                      container: d.first),
                ),
              ),
            ],
          ),
          error: (e, s) => ErrorScreen(message: e.toString()),
          loading: () =>
              const LoadingScreen(message: 'Map kamu sedang dimuat nih..'),
        ));
  }
}
