import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/dropdown/dropdown.dart';
import 'package:skripsi_mobile/shared/card/collect_card.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class CollectListScreen extends ConsumerStatefulWidget {
  const CollectListScreen({super.key});

  @override
  ConsumerState<CollectListScreen> createState() => _CollectListScreenState();
}

class _CollectListScreenState extends ConsumerState<CollectListScreen> {
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
  Widget build(BuildContext context) {
    final collects = ref.watch(collectsProvider(contenatedFilterQuery()));
    final collectsCount = collects.value?.length;

    return Scaffold(
      appBar: AppBar(
        title: Wrap(children: [
          TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari berdasarkan ID',
                hintStyle: Fonts.semibold14.copyWith(color: AppColors.grey),
                labelText: 'Cari sampah',
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
                    borderRadius: BorderRadius.all(Radius.circular(24)))),
          ),
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            color: AppColors.greenPrimary,
            onRefresh: () =>
                ref.refresh(collectsProvider(contenatedFilterQuery()).future),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      // Sort
                      Dropdown(
                          hint: 'Urut',
                          data: DropdownCollectSort.values,
                          onChanged: (String? newValue) =>
                              setState(() => selectedSort = newValue),
                          selectedValue: selectedSort),

                      SizedBox(width: 12),

                      Dropdown(
                          hint: 'Tipe',
                          data: DropdownWasteType.values,
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
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Hasil Pencarian', style: Fonts.bold16),
                      Text('${collects.value?.length ?? 'Menghitung'} Hasil',
                          style: Fonts.regular12),
                      SizedBox(height: 12),
                      collects.when(
                        data: (c) => c.isEmpty
                            ? NotFoundScreen(message: 'Tidak ada data')
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: c.length,
                                itemBuilder: (context, i) =>
                                    CollectCard(collect: c[i])),
                        error: (e, _) => ErrorScreen(message: e.toString()),
                        loading: () => Center(
                          child: CircularProgressIndicator(
                              color: AppColors.greenPrimary),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
