import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/controller/collect_controller.dart';
import 'package:skripsi_mobile/models/collect.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/container_detail_screen.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/confirmation_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/image/image_with_token.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/pills/waste_type_pill.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';

class CollectDetailScreen extends ConsumerStatefulWidget {
  const CollectDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<CollectDetailScreen> createState() =>
      _CollectDetailScreenState();
}

class _CollectDetailScreenState extends ConsumerState<CollectDetailScreen> {
  num likeCount = 11294;

  void handleDelete(DetailedCollect d) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ConfirmationBottomSheet(
          onConfirmPressed: () {
            ref
                .read(collectControllerProvider.notifier)
                .deleteMyCollect(d.id, d.img);

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
    final collect = ref.watch(collectProvider(widget.id));
    final state = ref.watch(collectControllerProvider);

    ref.listen<AsyncValue>(collectControllerProvider, (_, s) {
      if (s.hasError && !s.isLoading) {
        s.showErrorSnackbar(context);
      }

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Menghapus data');
      }

      if (!s.hasError && !s.isLoading) {
        s.showSnackbar(
            context, 'Sukses melakukan hapus data dengan ID ${widget.id}');
        Navigator.of(context, rootNavigator: true).pop();
        ref.invalidate(collectsProvider);
      }
    });

    return Scaffold(
        body: collect.when(
            error: (e, s) => ErrorScreen(message: e.toString()),
            loading: () => const LoadingScreen(
                message: 'Data kumpul sampahmu sedang diproses nih..'),
            data: (d) => RefreshIndicator(
                  onRefresh: () async {
                    await ref.refresh(collectProvider(widget.id).future);
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: false,
                        expandedHeight: 180,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: ImageWithToken(d.img),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('yyyy/MM/dd - hh:mm:ss')
                                        .format(d.createdAt.toLocal()),
                                    style: Fonts.regular14
                                        .copyWith(color: AppColors.grey),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text('Sampah ID ${widget.id}',
                                                style: Fonts.bold18
                                                    .copyWith(fontSize: 21)),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: switch (d.status) {
                                                  Status.accepted =>
                                                    AppColors.greenAccent,
                                                  Status.pending =>
                                                    AppColors.lightGrey,
                                                  Status.rejected =>
                                                    AppColors.red,
                                                },
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12)),
                                              ),
                                              child: Text(
                                                d.status.value,
                                                style:
                                                    Fonts.semibold14.copyWith(
                                                  color: switch (d.status) {
                                                    Status.accepted =>
                                                      AppColors.greenPrimary,
                                                    Status.pending =>
                                                      AppColors.grey,
                                                    Status.rejected =>
                                                      Colors.red[600],
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      d.status == Status.accepted
                                          ? AddedPointPill(point: d.point.toString())
                                          : const SizedBox(width: 0),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  d.status != Status.accepted
                                      ? Container(
                                          width: double.infinity,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      AppColors.dark1
                                                          .withOpacity(0.2),
                                                      BlendMode.darken),
                                                  image: const AssetImage(
                                                      'assets/images/milestone_map.png')),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey[350]!)),
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            'Kamu akan mendapatkan poin tambahan apabila laporanmu disetujui Admin 🤩',
                                            textAlign: TextAlign.center,
                                            style: Fonts.bold16.copyWith(
                                                fontSize: 14,
                                                color: AppColors.white),
                                          ),
                                        )
                                      : const SizedBox(width: 0),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey[350]!)),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Lokasi Depo/Tong:  ',
                                            style: Fonts.semibold14),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgs/container_icon.svg',
                                              height: 36,
                                              width: 36,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                d.containerName,
                                                style: Fonts.bold16.copyWith(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.bluePrimary),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            IconButton(
                                              iconSize: 24,
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .push(MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ContainerDetailScreen(
                                                                      id: d
                                                                          .containerId)));
                                                    },
                                              icon: Icon(
                                                  Icons.navigate_next_rounded,
                                                  color:
                                                      AppColors.greenPrimary),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey[350]!)),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 6,
                                          children: [
                                            Text('Tipe: ',
                                                style: Fonts.semibold14),
                                            WasteTypePill(type: d.type),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 6,
                                          children: [
                                            Text('Volume:',
                                                style: Fonts.semibold14),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.blueAccent,
                                                borderRadius:
                                                    const BorderRadius.all(
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
                                                    color:
                                                        AppColors.bluePrimary,
                                                  ),
                                                  Text(
                                                    '${d.vol.toStringAsFixed(1).toString()} L',
                                                    style: Fonts.semibold14
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .bluePrimary),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Text('Berat:',
                                                style: Fonts.semibold14),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.blueAccent,
                                                borderRadius:
                                                    const BorderRadius.all(
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
                                                    color:
                                                        AppColors.bluePrimary,
                                                  ),
                                                  Text(
                                                    '${d.kg.toStringAsFixed(1).toString()} kg',
                                                    style: Fonts.semibold14
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .bluePrimary),
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
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey[350]!)),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Informasi Tambahan: ',
                                            style: Fonts.semibold14),
                                        const SizedBox(height: 12),
                                        d.info.isEmpty
                                            ? Text(
                                                'Tidak ada informasi tambahan',
                                                style: Fonts.regular12.copyWith(
                                                    color: AppColors.grey),
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(d.info,
                                                style: Fonts.regular12),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey[350]!)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Status Laporan: ',
                                            style: Fonts.semibold14),
                                        AnotherStepper(
                                          stepperList: <StepperData>[
                                            StepperData(
                                              title: StepperText(
                                                "Laporan diterima Admin",
                                                textStyle: Fonts.semibold14,
                                              ),
                                              subtitle: StepperText(
                                                  DateFormat(
                                                          'yyyy/MM/dd - hh:mm:ss')
                                                      .format(d.createdAt
                                                          .toLocal()),
                                                  textStyle: Fonts.regular12),
                                              iconWidget: Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.greenPrimary,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: Icon(
                                                    Icons.check_circle_rounded,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                            StepperData(
                                              title: StepperText(
                                                d.status == Status.rejected
                                                    ? "Laporan ditolak Admin"
                                                    : "Laporan disetujui Admin (+10 ⭐)",
                                                textStyle: Fonts.semibold14,
                                              ),
                                              subtitle: StepperText(
                                                  d.updatedAt == d.createdAt
                                                      ? '-'
                                                      : DateFormat(
                                                              'yyyy/MM/dd - hh:mm:ss')
                                                          .format(d.updatedAt
                                                              .toLocal()),
                                                  textStyle: Fonts.regular12),
                                              iconWidget: Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    color: d.status !=
                                                            Status.pending
                                                        ? d.status ==
                                                                Status.rejected
                                                            ? AppColors.red
                                                            : AppColors
                                                                .greenPrimary
                                                        : AppColors.grey,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: d.status !=
                                                        Status.pending
                                                    ? d.status ==
                                                            Status.rejected
                                                        ? Icon(
                                                            Icons.close_rounded,
                                                            color:
                                                                AppColors.white)
                                                        : Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color:
                                                                AppColors.white)
                                                    : Icon(
                                                        Icons.pending_rounded,
                                                        color: AppColors.white),
                                              ),
                                            ),
                                          ],
                                          stepperDirection: Axis.vertical,
                                          activeIndex:
                                              d.status == Status.pending
                                                  ? 0
                                                  : 1,
                                          activeBarColor:
                                              AppColors.greenSecondary,
                                          inActiveBarColor: AppColors.lightGrey,
                                          verticalGap: 36,
                                          iconHeight: 48,
                                          iconWidth: 48,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey[350]!)),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: AppColors.red),
                                              elevation: 0,
                                              foregroundColor: AppColors.red,
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                        'Hapus Laporan',
                                                        style: Fonts.bold16,
                                                      ),
                                                    ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
                )));
  }
}
