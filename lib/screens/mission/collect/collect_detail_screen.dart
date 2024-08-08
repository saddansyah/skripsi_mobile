import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/shared/appbar/appbar_image.dart';
import 'package:skripsi_mobile/shared/error_screen.dart';
import 'package:skripsi_mobile/shared/loading_screen.dart';
import 'package:skripsi_mobile/shared/pills/waste_type_pill.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/error_extension.dart';

class CollectDetailScreen extends ConsumerStatefulWidget {
  const CollectDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<CollectDetailScreen> createState() =>
      _CollectDetailScreenState();
}

class _CollectDetailScreenState extends ConsumerState<CollectDetailScreen> {
  num likeCount = 11294;

  @override
  Widget build(BuildContext context) {
    final collect = ref.watch(collectProvider(widget.id));

    ref.listen<AsyncValue>(collectsProvider, (_, state) {
      state.showSnackbarOnError(context);
    });

    return Scaffold(
        body: collect.when(
            error: (e, s) => ErrorScreen(message: e.toString()),
            loading: () => LoadingScreen(
                message: 'Data kumpul sampahmu sedang diproses nih..'),
            data: (d) => CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: false,
                      expandedHeight: 180,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Image.network(
                          d.img,
                          colorBlendMode: BlendMode.color,
                          fit: BoxFit.cover,
                        ),
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
                                Row(
                                  children: [
                                    Text('Sampah ID ${widget.id}',
                                        style: Fonts.bold18
                                            .copyWith(fontSize: 21)),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: switch (d.status) {
                                          Status.accepted =>
                                            AppColors.greenAccent,
                                          Status.pending => AppColors.lightGrey,
                                          Status.rejected => AppColors.red,
                                        },
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Text(
                                        d.status.value,
                                        style: Fonts.semibold14.copyWith(
                                          color: switch (d.status) {
                                            Status.accepted =>
                                              AppColors.greenPrimary,
                                            Status.pending => AppColors.grey,
                                            Status.rejected => Colors.red[600],
                                          },
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        IconButton(
                                            color: AppColors.bluePrimary,
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.thumb_up_outlined)),
                                        Text(
                                            likeCount > 1000
                                                ? '${(likeCount / 1000).toStringAsFixed(1)}K'
                                                : likeCount.toString(),
                                            style: Fonts.semibold16.copyWith(
                                                color: AppColors.bluePrimary)),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 12),
                                Container(
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
                                  child: Text('+5 ⭐ apabila disetujui Admin',
                                      textAlign: TextAlign.center,
                                      style: Fonts.bold16.copyWith(
                                          fontSize: 14,
                                          color: AppColors.white)),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[350]!)),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      WasteTypePill(type: d.type),
                                      SizedBox(height: 12),
                                      Wrap(
                                        spacing: 6,
                                        children: [
                                          Text('Volume:',
                                              style: Fonts.semibold14),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.blueAccent,
                                              borderRadius: BorderRadius.all(
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
                                          SizedBox(width: 3),
                                          Text('Berat: ',
                                              style: Fonts.semibold14),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.blueAccent,
                                              borderRadius: BorderRadius.all(
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
                                SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[350]!)),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text('Informasi Tambahan: ',
                                          style: Fonts.semibold14),
                                      SizedBox(height: 12),
                                      d.info.length == 0
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
                                SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[350]!)),
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
                                                    .format(
                                                        d.createdAt.toLocal()),
                                                textStyle: Fonts.regular12),
                                            iconWidget: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  color: AppColors.greenPrimary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
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
                                                        .format(d.createdAt
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
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              child: d.status != Status.pending
                                                  ? d.status == Status.rejected
                                                      ? Icon(
                                                          Icons.close_rounded,
                                                          color:
                                                              AppColors.white)
                                                      : Icon(
                                                          Icons
                                                              .check_circle_rounded,
                                                          color:
                                                              AppColors.white)
                                                  : Icon(Icons.pending_rounded,
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        ],
                                        stepperDirection: Axis.vertical,
                                        activeIndex:
                                            d.status == Status.pending ? 0 : 1,
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
                                SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[350]!)),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                AppColors.greenPrimary,
                                            foregroundColor: AppColors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            )),
                                        onPressed: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.edit_rounded,
                                                color: AppColors.white,
                                                weight: 100,
                                              ),
                                              const SizedBox(width: 9),
                                              Text(
                                                'Edit Laporan',
                                                style: Fonts.bold16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        indent: 12,
                                        endIndent: 12,
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                width: 1, color: AppColors.red),
                                            elevation: 0,
                                            foregroundColor: AppColors.red,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            )),
                                        onPressed: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
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
                )));
  }
}
