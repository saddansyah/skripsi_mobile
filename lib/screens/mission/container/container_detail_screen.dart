import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/controller/container_controller.dart';
import 'package:skripsi_mobile/controller/evidence_rating_controller.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/models/evidence_rating.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/evidence_rating_repository.dart';
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/screens/mission/ar/ar_container_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/add_collect_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/evidence_rating/evidence_rating_list_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/evidence_rating/evidence_rating_screen.dart';
import 'package:skripsi_mobile/screens/mission/map/view_only_map_screen.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/confirmation_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/pills/container_type_pill.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/location.dart';

class ContainerDetailScreen extends ConsumerStatefulWidget {
  const ContainerDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ContainerDetailScreen> createState() =>
      _ContainerDetailScreenState();
}

class _ContainerDetailScreenState extends ConsumerState<ContainerDetailScreen> {
  final likeCount = 12345;
  final maxDistanceARInM = 2000;

  void handleDeleteRating(EvidenceRating d) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ConfirmationBottomSheet(
          onConfirmPressed: () {
            ref
                .read(evidenceRatingControllerProvider.notifier)
                .deleteContainerRating(d.containerId);

            Navigator.of(context).pop();
          },
          title: 'Apakah kamu yakin akan menghapus rating?',
          message: 'Poin kamu akan berkurang 5⭐ apabila rating kamu dihapus',
          color: AppColors.red,
          yes: 'Ya, hapus',
          no: 'Tidak jadi deh',
        );
      },
    );
  }

  void handleDeleteContainer(model.DetailedContainer d) {
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
    final rating = ref.watch(evidenceRatingProvider(widget.id));
    final currentPosition = ref.watch(currentPositionProvider);
    final containerState = ref.watch(containerControllerProvider);
    final ratingState = ref.watch(evidenceRatingControllerProvider);

    final profile = ref.watch(profileProvider);

    ref.listen<AsyncValue>(containerControllerProvider, (_, s) {
      s.showErrorSnackbar(context);

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Menghapus data');
      }

      if (!s.hasError && !s.isLoading) {
        s.showSnackbar(context,
            'Sukses melakukan hapus permohonan depo/tong baru dengan ID ${widget.id}');
        ref.invalidate(containersProvider);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    ref.listen<AsyncValue>(evidenceRatingControllerProvider, (_, s) {
      s.showErrorSnackbar(context);

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Menghapus data');
      }

      if (!s.hasError && !s.isLoading) {
        s.showSnackbar(context, 'Sukses hapus rating');
        ref.invalidate(evidenceRatingProvider);
      }
    });

    return Scaffold(
      body: container.when(
        error: (e, s) => ErrorScreen(message: e.toString()),
        loading: () => const LoadingScreen(
            message: 'Data depo/tong sedang diproses nih..'),
        data: (d) => RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(containerProvider(widget.id).future);
            await ref.refresh(evidenceRatingProvider(widget.id).future);
            await ref.refresh(currentPositionProvider.future);
          },
          child: CustomScrollView(
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
                              interactionOptions: const InteractionOptions(
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
                                        builder: (context) =>
                                            ViewOnlyMapScreen(container: d),
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update terakhir: ${DateFormat('yyyy/MM/dd - hh:mm:ss').format(d.updatedAt.toLocal())}',
                            style:
                                Fonts.regular12.copyWith(color: AppColors.grey),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(d.name,
                                    style: Fonts.bold18.copyWith(fontSize: 21)),
                              ),
                              const SizedBox(width: 6),
                              d.status == Status.accepted &&
                                      d.userId == profile.value?.id
                                  ? AddedPointPill(point: d.point.toString())
                                  : const SizedBox(width: 0),
                              const SizedBox(width: 6),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: switch (d.status) {
                                Status.accepted => AppColors.greenAccent,
                                Status.pending => AppColors.lightGrey,
                                Status.rejected => AppColors.red,
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
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
                          const SizedBox(height: 12),
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
                                          image: const AssetImage(
                                              'assets/images/milestone_map.png')),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 2, color: Colors.grey[350]!)),
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    'Kamu akan mendapatkan poin tambahan apabila laporanmu disetujui Admin 🤩',
                                    textAlign: TextAlign.center,
                                    style: Fonts.bold16.copyWith(
                                        fontSize: 14, color: AppColors.white),
                                  ),
                                )
                              : const SizedBox(width: 0),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                    width: 2, color: Colors.grey[350]!)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Text('Jarak darimu: ',
                                        style: Fonts.semibold14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueAccent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 3,
                                        children: [
                                          Icon(
                                            Icons.pin_drop_outlined,
                                            size: 16,
                                            color: AppColors.bluePrimary,
                                          ),
                                          Text(
                                            Location.getFormattedDistance(
                                              Location.getDistance(
                                                  currentPosition.valueOrNull
                                                          ?.latitude ??
                                                      0,
                                                  currentPosition.valueOrNull
                                                          ?.longitude ??
                                                      0,
                                                  d.lat.toDouble(),
                                                  d.long.toDouble()),
                                            ),
                                            style: Fonts.semibold14.copyWith(
                                                fontSize: 12,
                                                color: AppColors.bluePrimary),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Text('Tipe: ', style: Fonts.semibold14),
                                    ContainerTypePill(type: d.type),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Text('Volume:', style: Fonts.semibold14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueAccent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
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
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Text('Berat:', style: Fonts.semibold14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueAccent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
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
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Text('Klaster: ', style: Fonts.semibold14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueAccent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
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
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                    width: 2, color: Colors.grey[350]!)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Semua Rating: ', style: Fonts.semibold14),
                                const SizedBox(height: 12),
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
                                      '${d.rating} (${d.ratingCount})',
                                      style: Fonts.regular14
                                          .copyWith(color: AppColors.grey),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Ratings
                                Text('Ratingku: ', style: Fonts.semibold14),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[350]!)),
                                  child: rating.when(
                                    data: (d) {
                                      if (d == null) {
                                        return Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Center(
                                            child: Text(
                                              'Ratingmu belum ada',
                                              style: Fonts.semibold14.copyWith(
                                                  color: AppColors.grey),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return ListTile(
                                          title: Text(
                                            d.info,
                                            style: Fonts.regular14,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 16,
                                                    color: AppColors.amber,
                                                  ),
                                                  Text(
                                                    '${d.value}',
                                                    style: Fonts.regular14
                                                        .copyWith(
                                                            color:
                                                                AppColors.grey),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    d.createdAt.toLocal()),
                                                style: Fonts.regular12.copyWith(
                                                    color: AppColors.grey),
                                              )
                                            ],
                                          ),
                                          leading: Icon(Icons.chat_rounded,
                                              color: AppColors.greenPrimary),
                                          trailing: GestureDetector(
                                            onTap: ratingState.isLoading
                                                ? null
                                                : () {
                                                    handleDeleteRating(d);
                                                  },
                                            child: Icon(
                                              Icons.delete_rounded,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    error: (e, s) => ListTile(
                                      title: Text(
                                        e.toString(),
                                        style: Fonts.regular14,
                                      ),
                                      leading: Icon(Icons.error_outline_rounded,
                                          color: AppColors.red),
                                    ),
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    elevation: 0,
                                  ),
                                  onPressed: ratingState.isLoading
                                      ? null
                                      : () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EvidenceRatingListScreen(
                                                      container: d),
                                            ),
                                          );
                                        },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 48,
                                    width: double.infinity,
                                    child: Center(
                                      child: ratingState.isLoading
                                          ? CircularProgressIndicator(
                                              color: AppColors.greenPrimary)
                                          : Text(
                                              'Lihat Semua Rating',
                                              style: Fonts.semibold14.copyWith(
                                                  color:
                                                      AppColors.greenPrimary),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                rating.when(
                                  error: (e, s) => ListTile(
                                    title: Text(
                                      e.toString(),
                                      style: Fonts.regular14,
                                    ),
                                    leading: Icon(Icons.error_outline_rounded,
                                        color: AppColors.red),
                                  ),
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  data: (e) {
                                    return e != null
                                        ? const SizedBox()
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color:
                                                        AppColors.greenPrimary),
                                                elevation: 0,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                )),
                                            onPressed: ratingState.isLoading
                                                ? null
                                                : () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            EvidenceRatingScreen(
                                                                container: d),
                                                      ),
                                                    );
                                                  },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 48,
                                              width: double.infinity,
                                              child: Center(
                                                child: ratingState.isLoading
                                                    ? CircularProgressIndicator(
                                                        color: AppColors
                                                            .greenPrimary)
                                                    : Text(
                                                        'Beri Evidence Rating',
                                                        style: Fonts.semibold14
                                                            .copyWith(
                                                                color: AppColors
                                                                    .greenPrimary),
                                                      ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                    width: 2, color: Colors.grey[350]!)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                currentPosition.when(
                                  error: (e, s) => Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    child: const Center(
                                      child: Text('Tidak dapat memuat lokasi'),
                                    ),
                                  ),
                                  loading: () => Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                  ),
                                  data: (p) => Location.getDistance(
                                              p.latitude,
                                              p.longitude,
                                              d.lat.toDouble(),
                                              d.long.toDouble()) >
                                          maxDistanceARInM
                                      ? Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_disabled_rounded,
                                                color: AppColors.grey,
                                                weight: 100,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Terlalu Jauh (> 2 km)',
                                                style: Fonts.bold16.copyWith(
                                                    color: AppColors.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  AppColors.greenPrimary,
                                              foregroundColor: AppColors.white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              )),
                                          onPressed: containerState.isLoading ||
                                                  d.status == Status.pending ||
                                                  d.status == Status.rejected
                                              ? null
                                              : () {
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ArContainerScreen(
                                                              container: d),
                                                    ),
                                                  );
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
                                              children: containerState.isLoading
                                                  ? [
                                                      CircularProgressIndicator(
                                                          color:
                                                              AppColors.white)
                                                    ]
                                                  : [
                                                      Icon(
                                                        Icons
                                                            .location_searching_rounded,
                                                        color: AppColors.white,
                                                        weight: 100,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        'Navigasi AR',
                                                        style: Fonts.bold16,
                                                      ),
                                                    ],
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.greenPrimary,
                                      foregroundColor: AppColors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      )),
                                  onPressed: containerState.isLoading ||
                                          d.status == Status.pending ||
                                          d.status == Status.rejected
                                      ? null
                                      : () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (_) => AddCollectScreen(
                                                container:
                                                    model.NearestContainer(
                                                        id: d.id,
                                                        name: d.name,
                                                        distance: 0,
                                                        lat: 0,
                                                        long: 0,
                                                        rating: 0,
                                                        ratingCount: 0),
                                              ),
                                            ),
                                          );
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
                                      children: containerState.isLoading
                                          ? [
                                              CircularProgressIndicator(
                                                  color: AppColors.white)
                                            ]
                                          : [
                                              Icon(
                                                Icons.recycling_rounded,
                                                color: AppColors.white,
                                                weight: 100,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Kumpul Sampah',
                                                style: Fonts.bold16,
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                d.userId != profile.value?.id
                                    ? const SizedBox()
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
                                        onPressed: containerState.isLoading
                                            ? null
                                            : () {
                                                handleDeleteContainer(d);
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
                                            children: containerState.isLoading
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
      ),
    );
  }
}
