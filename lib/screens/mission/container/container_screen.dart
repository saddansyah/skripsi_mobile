import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/add_container_screen.dart';
import 'package:skripsi_mobile/shared/dropdown/dropdown.dart';
import 'package:skripsi_mobile/shared/image/image_with_token.dart';
import 'package:skripsi_mobile/shared/mission/container/container_card.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/storage.dart';

class ContainerScreen extends ConsumerStatefulWidget {
  const ContainerScreen({super.key});

  @override
  ConsumerState<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends ConsumerState<ContainerScreen> {
  String? selectedSort;
  String? selectedType;
  String? selectedStatus;
  String? searchQuery;

  String contenatedFilterQuery() {
    String query = '';

    if (searchQuery != null) {
      query += '${searchQuery!}&';
    }

    if (selectedSort != null) {
      query += '${selectedSort!}&';
    }

    if (selectedType != null) {
      query += '${selectedType!}&';
    }

    if (selectedStatus != null) {
      query += '${selectedStatus!}&';
    }

    return '?$query';
  }

  Timer? _debounce;
  void onChanged(String? query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      setState(() {
        searchQuery = 'search=$query';
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containers = ref.watch(containersProvider(contenatedFilterQuery()));
    final profile = ref.watch(profileFromStorageProvider);

    final containerCountByUserId =
        containers.value?.where((d) => d.userId == profile.value?.id).length;
    final containerCount = containers.value?.length;

    ref.listen<AsyncValue>(containersProvider(contenatedFilterQuery()),
        (_, state) {
      state.showErrorSnackbar(context);
    });

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Wrap(
            children: [
              TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Contoh: Depo (case-sensitive)',
                  hintStyle: Fonts.semibold14.copyWith(color: AppColors.grey),
                  labelText: 'Cari depo/tong',
                  labelStyle: Fonts.semibold14.copyWith(color: AppColors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: AppColors.lightGrey,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: AppColors.greenPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.grey.withOpacity(0)),
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                TabBar(
                  dividerColor: AppColors.lightGrey,
                  labelColor: AppColors.greenPrimary,
                  tabs: [
                    Tab(
                      child: Text('Semua Tong', style: Fonts.semibold14),
                    ),
                    Tab(
                      child: Text('Tong Saya', style: Fonts.semibold14),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: Row(
                    children: [
                      Dropdown(
                          hint: 'Urut',
                          data: DropdownContainerSort.values,
                          onChanged: (String? newValue) =>
                              setState(() => selectedSort = newValue),
                          selectedValue: selectedSort),
                      SizedBox(width: 12),
                      Dropdown(
                          hint: 'Tipe',
                          data: DropdownContainerType.values,
                          onChanged: (String? newValue) =>
                              setState(() => selectedType = newValue),
                          selectedValue: selectedType),
                      SizedBox(width: 12),
                      Dropdown(
                          hint: 'Status',
                          data: DropdownStatus.values,
                          onChanged: (String? newValue) =>
                              setState(() => selectedStatus = newValue),
                          selectedValue: selectedStatus),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const AddContanierScreen()));
          },
          disabledElevation: 0,
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.greenPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          enableFeedback: true,
          icon: const Icon(Icons.add_rounded),
          label: SvgPicture.asset(
            'assets/svgs/container_icon.svg',
            width: 36,
            height: 36,
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Hasil Pencarian', style: Fonts.bold16),
                        Text('${containerCount ?? 'Menghitung'} Hasil',
                            style: Fonts.regular12),
                        SizedBox(height: 12),
                        containerCount == 0
                            ? NotFoundScreen(message: 'Tidak ada data')
                            : containers.when(
                                data: (c) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: c.length,
                                  itemBuilder: (context, i) =>
                                      ContainerCard(container: c[i]),
                                ),
                                error: (e, _) =>
                                    ErrorScreen(message: e.toString()),
                                loading: () => Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.greenPrimary),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Milik saya
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Hasil Pencarian', style: Fonts.bold16),
                        Text('${containerCountByUserId ?? 'Menghitung'} Hasil',
                            style: Fonts.regular12),
                        SizedBox(height: 12),
                        containerCountByUserId == 0
                            ? NotFoundScreen(message: 'Tidak ada data')
                            : containers.when(
                                data: (c) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: c
                                      .where(
                                          (d) => d.userId == profile.value?.id)
                                      .length,
                                  itemBuilder: (context, i) => ContainerCard(
                                      isStatusShowed: true,
                                      container: c
                                          .where((d) =>
                                              d.userId == profile.value?.id)
                                          .toList()[i]),
                                ),
                                error: (e, _) =>
                                    ErrorScreen(message: e.toString()),
                                loading: () => Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.greenPrimary),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
