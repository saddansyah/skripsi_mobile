import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/container_detail_screen.dart';
import 'package:skripsi_mobile/shared/card/nearest_container_card.dart';
import 'package:skripsi_mobile/theme.dart';

class MapContainerSelectScreen extends ConsumerStatefulWidget {
  const MapContainerSelectScreen(
      {super.key,
      required this.selectedContainer,
      required this.updateContainer});

  final model.NearestContainer selectedContainer;
  final void Function(model.NearestContainer) updateContainer;

  @override
  ConsumerState<MapContainerSelectScreen> createState() =>
      _MapContainerSelectScreenState();
}

class _MapContainerSelectScreenState
    extends ConsumerState<MapContainerSelectScreen> {
  static final controller = MapController();

  // For local state
  late model.NearestContainer selected = widget.selectedContainer;
  void updateLocalSelected(model.NearestContainer newSelected) {
    setState(() {
      selected = newSelected;
    });
    widget.updateContainer(newSelected);
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(streamPositionProvider);
    final nearestContainers = ref.watch(nearestContainerProvider(50));

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
            FloatingActionButton(
              heroTag: 'myLocation',
              onPressed: () {
                controller.move(
                    LatLng(currentPosition.value?.latitude ?? 0,
                        currentPosition.value?.longitude ?? 0),
                    18);
                controller.fitCamera(CameraFit.insideBounds(
                    maxZoom: 17,
                    minZoom: 17,
                    bounds: LatLngBounds(
                      LatLng(nearestContainers.value?.first.lat.toDouble() ?? 0,
                          nearestContainers.value?.first.long.toDouble() ?? 0),
                      LatLng(currentPosition.value?.latitude.toDouble() ?? 0,
                          currentPosition.value?.longitude.toDouble() ?? 0),
                    )));
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
        body: nearestContainers.when(
          data: (c) => Stack(
            children: [
              FlutterMap(
                mapController: controller,
                options: MapOptions(
                    interactionOptions:
                        InteractionOptions(flags: InteractiveFlag.all),
                    backgroundColor: AppColors.lightGrey,
                    initialCenter: LatLng(
                        currentPosition.value?.latitude ??
                            widget.selectedContainer.lat.toDouble(),
                        currentPosition.value?.longitude ??
                            widget.selectedContainer.long.toDouble()),
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
                      child: Icon(
                        Icons.my_location_rounded,
                        color: AppColors.bluePrimary,
                        size: 36,
                        shadows: [
                          Shadow(
                            color: AppColors.blueSecondary,
                            blurRadius: 36,
                          )
                        ],
                      ),
                    ),
                    ...c.map((_c) {
                      return Marker(
                        width: 150,
                        height: 150,
                        rotate: true,
                        point: LatLng(_c.lat.toDouble(), _c.long.toDouble()),
                        child: GestureDetector(
                          onTap: () {
                            updateLocalSelected(_c);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _c.name,
                                style: Fonts.semibold14.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                              const SizedBox(height: 3),
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: selected.id == _c.id
                                        ? [
                                            BoxShadow(
                                              color: AppColors.greenSecondary,
                                              blurRadius: 12,
                                              spreadRadius: 3,
                                            ),
                                          ]
                                        : null),
                                child: SvgPicture.asset(
                                    'assets/svgs/container_icon.svg'),
                              ),
                              const SizedBox(height: 3),
                              selected.id == _c.id
                                  ? Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenPrimary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Terpilih',
                                        style: Fonts.semibold14.copyWith(
                                            fontSize: 12,
                                            color: AppColors.white),
                                      ),
                                    )
                                  : const SizedBox(height: 0),
                            ],
                          ),
                        ),
                      );
                    })
                  ])
                ],
              ),
            ],
          ),
          error: (e, s) => ErrorScreen(message: e.toString()),
          loading: () =>
              const LoadingScreen(message: 'Map kamu sedang dimuat nih..'),
        ));
  }
}
