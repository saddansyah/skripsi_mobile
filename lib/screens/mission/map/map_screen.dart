import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.initialCoord});

  final LatLng initialCoord;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Map Depo/Tong', style: Fonts.semibold16),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.greenPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enableFeedback: true,
        child: const Icon(Icons.map_rounded),
      ),
      body: FlutterMap(
        options: MapOptions(
            interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
            backgroundColor: AppColors.lightGrey,
            initialCenter: widget.initialCoord,
            initialZoom: 18),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.saddansyah.skripsi_mobile',
          ),
          MarkerLayer(markers: [
            Marker(
              point: widget.initialCoord,
              width: 48,
              height: 48,
              child: SvgPicture.asset('assets/svgs/container_icon.svg'),
            ),
          ])
        ],
      ),
    );
  }
}
