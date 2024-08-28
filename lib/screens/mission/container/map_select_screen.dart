import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/theme.dart';

class MapSelectScreen extends StatefulWidget {
  const MapSelectScreen(
      {super.key, required this.initialCoord, required this.updateCoord});

  final LatLng initialCoord;
  final void Function(LatLng) updateCoord;

  @override
  State<MapSelectScreen> createState() => _MapSelectScreenState();
}

class _MapSelectScreenState extends State<MapSelectScreen> {
  late LatLng selectedCoord;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    selectedCoord = widget.initialCoord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Tambah Lokasi Depo/Tong', style: Fonts.semibold16),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.greenPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enableFeedback: true,
        label: Text('Pilih Lokasi', style: Fonts.bold16),
        icon: const Icon(Icons.add_rounded),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedCoord = point;
                  });
          
                  widget.updateCoord(selectedCoord);
                },
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
                  point: selectedCoord,
                  width: 48,
                  height: 48,
                  child: SvgPicture.asset('assets/svgs/container_icon.svg'),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
