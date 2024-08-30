import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/theme.dart';

class NearestContainerCard extends StatelessWidget {
  const NearestContainerCard(
      {super.key,
      required this.controller,
      required this.currentStaticPosition,
      required this.bound,
      required this.isVisible,
      required this.container});

  final MapController controller;
  final Position currentStaticPosition;
  final LatLngBounds bound;
  final bool isVisible;
  final model.NearestContainer container;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      curve: Curves.easeInOutCirc,
      scale: isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: Colors.grey[350]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Depo/Tong Terdekat',
                  style: Fonts.semibold14.copyWith(color: AppColors.dark2)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(),
                    elevation: 0,
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.grey[350]!),
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                    )),
                onPressed: () {
                  controller.fitCamera(
                    // Fit to nearest container against my location
                    CameraFit.insideBounds(
                      maxZoom: 16,
                      minZoom: 16,
                      bounds: bound,
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    container.name,
                    style: Fonts.semibold14,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        '${container.distance.toStringAsFixed(2)} km',
                        style: Fonts.regular14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '⭐' * container.rating.toInt(),
                        style: Fonts.regular14,
                      ),
                    ],
                  ),
                  trailing:
                      Icon(Icons.location_pin, color: AppColors.greenPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
