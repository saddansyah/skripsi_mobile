import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/learn_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/dropdown/dropdown.dart';
import 'package:skripsi_mobile/shared/card/learn_card.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String? selectedSort;
  String? selectedCategory;
  String? searchQuery;

  String contenatedFilterQuery() {
    String query = '';

    if (searchQuery != null) {
      query += '${searchQuery!}&';
    }

    if (selectedSort != null) {
      query += '${selectedSort!}&';
    }

    if (selectedCategory != null) {
      query += '${selectedCategory!}&';
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
    final learns = ref.watch(learnsProvider(contenatedFilterQuery()));
    final learnCount = learns.value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          children: [
            TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Contoh: Memilah Sampah',
                hintStyle: Fonts.semibold14.copyWith(color: AppColors.grey),
                labelText: 'Cari artikel',
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
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Row(
              children: [
                Dropdown(
                    hint: 'Urutkan',
                    data: DropdownLearnSort.values,
                    onChanged: (String? newValue) =>
                        setState(() => selectedSort = newValue),
                    selectedValue: selectedSort),
                SizedBox(width: 12),
                Dropdown(
                    hint: 'Kategori',
                    data: DropdownLearnCategory.values,
                    onChanged: (String? newValue) =>
                        setState(() => selectedCategory = newValue),
                    selectedValue: selectedCategory),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hasil Pencarian', style: Fonts.bold16),
              Text('${learns.value?.length ?? 'Menghitung'} Hasil',
                  style: Fonts.regular12),
              SizedBox(height: 12),
              learns.when(
                data: (l) {
                  return l.isEmpty
                      ? const NotFoundScreen(message: 'Tidak ada data')
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: l.length,
                          itemBuilder: (context, i) {
                            return LearnCard(learn: l[i]);
                          });
                },
                error: (e, _) => ErrorScreen(
                  buttonText: 'Muat Ulang',
                  message: e.toString(),
                  isRefreshing: learns.isRefreshing,
                  onPressed: () {
                    ref.invalidate(learnsProvider);
                  },
                ),
                loading: () => Center(
                  child:
                      CircularProgressIndicator(color: AppColors.greenPrimary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
