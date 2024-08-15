import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/controller/container_controller.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/screens/mission/map/map_screen.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/confirmation_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/pills/container_type_pill.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';

class ContainerDetailScreen extends ConsumerStatefulWidget {
  const ContainerDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ContainerDetailScreen> createState() =>
      _ContainerDetailScreenState();
}

class _ContainerDetailScreenState extends ConsumerState<ContainerDetailScreen> {
  final likeCount = 12345;

  void handleDelete(model.DetailedContainer d) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ConfirmationBottomSheet(
          onConfirmPressed: () {
            ref
                .read(containerControllerProvider.notifier)
                .deleteContainer(d.id);

            Navigator.of(context).pop();
          },
          title: 'Apakah kamu yakin akan menghapus laporan?',
          message:
              'Poin kamu akan berkurang 5⭐ apabila masih dalam status Pending',
          color: AppColors.red,
          yes: 'Ya, hapus',
          no: 'Tidak jadi deh',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final container = ref.watch(containerProvider(widget.id));
    final state = ref.watch(containerControllerProvider);
    final profile = ref.watch(profileProvider);
    ref.listen<AsyncValue>(containerControllerProvider, (_, state) {
      state.showErrorSnackbar(context);

      if (state.isLoading) {
        state.showLoadingSnackbar(context, 'Menghapus data');
      }

      if (!state.hasError && !state.isLoading) {
        state.showSnackbar(context,
            'Sukses melakukan hapus permohonan depo/tong baru dengan ID ${widget.id}');
        ref.invalidate(containersProvider);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    return Scaffold(
      body: container.when(
        error: (e, s) => ErrorScreen(message: e.toString()),
        loading: () => const LoadingScreen(
            message: 'Data depo/tong sedang diproses nih..'),
        data: (d) => CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 240,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  children: [
                    FlutterMap(
                        options: MapOptions(
                            interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.pinchZoom),
                            backgroundColor: AppColors.lightGrey,
                            initialCenter:
                                LatLng(d.lat.toDouble(), d.long.toDouble()),
                            initialZoom: 18),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.saddansyah.skripsi_mobile',
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              point:
                                  LatLng(d.lat.toDouble(), d.long.toDouble()),
                              width: 48,
                              height: 48,
                              child: SvgPicture.asset(
                                  'assets/svgs/container_icon.svg'),
                            ),
                          ])
                        ]),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: <Color>[
                            AppColors.white,
                            AppColors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      bottom: 24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.greenPrimary,
                            child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                        initialCoord: LatLng(d.lat.toDouble(),
                                            d.long.toDouble()),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.map_rounded,
                                  color: AppColors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update terakhir: ${DateFormat('yyyy/MM/dd - hh:mm:ss').format(d.updatedAt.toLocal())}',
                          style:
                              Fonts.regular12.copyWith(color: AppColors.grey),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(d.name,
                                  style: Fonts.bold18.copyWith(fontSize: 21)),
                            ),
                            SizedBox(width: 6),
                            d.status == Status.accepted &&
                                    d.userId == profile.value?.id
                                ? AddedPointPill(point: d.point)
                                : const SizedBox(width: 0)
                          ],
                        ),
                        SizedBox(height: 6),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: switch (d.status) {
                              Status.accepted => AppColors.greenAccent,
                              Status.pending => AppColors.lightGrey,
                              Status.rejected => AppColors.red,
                            },
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            d.status.value,
                            style: Fonts.semibold14.copyWith(
                              color: switch (d.status) {
                                Status.accepted => AppColors.greenPrimary,
                                Status.pending => AppColors.grey,
                                Status.rejected => Colors.red[600],
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        d.status != Status.accepted &&
                                d.userId == profile.value?.id
                            ? Container(
                                width: double.infinity,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.dark1.withOpacity(0.2),
                                            BlendMode.darken),
                                        image: AssetImage(
                                            'assets/images/milestone_map.png')),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey[350]!)),
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Kamu akan mendapatkan poin tambahan apabila laporanmu disetujui Admin 🤩',
                                  textAlign: TextAlign.center,
                                  style: Fonts.bold16.copyWith(
                                      fontSize: 14, color: AppColors.white),
                                ),
                              )
                            : const SizedBox(width: 0),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  width: 1, color: Colors.grey[350]!)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 6,
                                children: [
                                  Text('Tipe: ', style: Fonts.semibold14),
                                  ContainerTypePill(type: d.type),
                                ],
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                children: [
                                  Text('Volume:', style: Fonts.semibold14),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 3,
                                      children: [
                                        Icon(
                                          Icons.water_rounded,
                                          size: 16,
                                          color: AppColors.bluePrimary,
                                        ),
                                        Text(
                                          '${d.maxVol.toStringAsFixed(1).toString()} L',
                                          style: Fonts.semibold14.copyWith(
                                              fontSize: 12,
                                              color: AppColors.bluePrimary),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Text('Berat:', style: Fonts.semibold14),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 3,
                                      children: [
                                        Icon(
                                          Icons.scale_rounded,
                                          size: 16,
                                          color: AppColors.bluePrimary,
                                        ),
                                        Text(
                                          '${d.maxKg.toStringAsFixed(1).toString()} kg',
                                          style: Fonts.semibold14.copyWith(
                                              fontSize: 12,
                                              color: AppColors.bluePrimary),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                children: [
                                  Text('Klaster: ', style: Fonts.semibold14),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 3,
                                      children: [
                                        Icon(
                                          Icons.location_city_rounded,
                                          size: 16,
                                          color: AppColors.bluePrimary,
                                        ),
                                        Text(
                                          d.clusterName,
                                          style: Fonts.semibold14.copyWith(
                                              fontSize: 12,
                                              color: AppColors.bluePrimary),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  width: 1, color: Colors.grey[350]!)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Evidence Rating: ',
                                  style: Fonts.semibold14),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 3,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppColors.amber,
                                  ),
                                  Text(
                                    '${d.rating} (1xx)',
                                    style: Fonts.regular14
                                        .copyWith(color: AppColors.grey),
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              // Ratings
                              Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                    color: AppColors.blueAccent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    border: Border.all(
                                        width: 2,
                                        color: AppColors.bluePrimary)),
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text('Coming Soon Feature',
                                      style: Fonts.semibold14.copyWith(
                                          color: AppColors.bluePrimary)),
                                ),
                              ),
                              SizedBox(height: 12),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 1,
                                        color: AppColors.greenPrimary),
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    )),
                                onPressed: state.isLoading ? null : () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  width: double.infinity,
                                  child: Center(
                                    child: state.isLoading
                                        ? CircularProgressIndicator(
                                            color: AppColors.greenPrimary)
                                        : Text(
                                            'Muat lainnya',
                                            style: Fonts.semibold14.copyWith(
                                                color: AppColors.greenPrimary),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  width: 1, color: Colors.grey[350]!)),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: AppColors.greenPrimary,
                                    foregroundColor: AppColors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    )),
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(popSnackbar(
                                          'Belum diimplementasi. Tunggu updatenya ya 😉',
                                          SnackBarType.info,
                                          CircularProgressIndicator(
                                              color: AppColors.white),
                                        ));
                                      },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: state.isLoading
                                        ? [
                                            CircularProgressIndicator(
                                                color: AppColors.white)
                                          ]
                                        : [
                                            Icon(
                                              Icons.star_rounded,
                                              color: AppColors.white,
                                              weight: 100,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Berikan Evidence Rating',
                                              style: Fonts.bold16,
                                            ),
                                          ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              d.userId != profile.value?.id
                                  ? SizedBox()
                                  : OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              width: 1, color: AppColors.red),
                                          elevation: 0,
                                          foregroundColor: AppColors.red,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          )),
                                      onPressed: state.isLoading
                                          ? null
                                          : () {
                                              handleDelete(d);
                                            },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: state.isLoading
                                              ? [
                                                  CircularProgressIndicator(
                                                      color: AppColors.red)
                                                ]
                                              : [
                                                  Icon(
                                                    Icons.delete_rounded,
                                                    color: AppColors.red,
                                                    weight: 100,
                                                  ),
                                                  const SizedBox(width: 9),
                                                  Text(
                                                    'Hapus Depo/Tong',
                                                    style: Fonts.bold16,
                                                  ),
                                                ],
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
