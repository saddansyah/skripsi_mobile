import 'package:flutter/material.dart' hide Container;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/models/container.dart';
import 'package:skripsi_mobile/theme.dart';

class ViewOnlyMapScreen extends StatefulWidget {
  const ViewOnlyMapScreen({super.key, required this.container});
  final Container container;

  @override
  State<ViewOnlyMapScreen> createState() => _ViewOnlyMapScreenState();
}

class _ViewOnlyMapScreenState extends State<ViewOnlyMapScreen> {
  final controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Map ${widget.container.name}', style: Fonts.semibold16),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.move(
              LatLng(widget.container.lat.toDouble() ?? 0,
                  widget.container.long.toDouble() ?? 0),
              18);
        },
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.greenPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enableFeedback: true,
        child: const Icon(Icons.my_location_rounded),
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
            interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
            backgroundColor: AppColors.lightGrey,
            initialCenter: LatLng(widget.container.lat.toDouble(),
                widget.container.long.toDouble()),
            initialZoom: 18),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.saddansyah.skripsi_mobile',
          ),
          MarkerLayer(markers: [
            Marker(
              rotate: true,
              point: LatLng(widget.container.lat.toDouble(),
                  widget.container.long.toDouble()),
              width: 90,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.container.name,
                    style: Fonts.semibold14.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                  const SizedBox(height: 3),
                  SvgPicture.asset('assets/svgs/container_icon.svg'),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
