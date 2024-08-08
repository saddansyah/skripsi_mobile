import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/screens/models/ui/dropdown.dart'
    hide DropdownMenuItem;
import 'package:skripsi_mobile/shared/appbar/main_appbar.dart';
import 'package:skripsi_mobile/shared/mission/collect/collect_card.dart';
import 'package:skripsi_mobile/theme.dart';

class CollectListScreen extends ConsumerStatefulWidget {
  const CollectListScreen({super.key});

  @override
  ConsumerState<CollectListScreen> createState() => _CollectListScreenState();
}

class _CollectListScreenState extends ConsumerState<CollectListScreen> {
  String? sortValue;
  String? typeValue;
  String? ratingValue;
  final dropdownItems = dummyDropdownItems;

  @override
  Widget build(BuildContext context) {
    final collects = ref.watch(collectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Wrap(children: [
          TextField(
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
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.grey.withOpacity(0)),
                    borderRadius: BorderRadius.all(Radius.circular(24)))),
          ),
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Sort
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 36,
                          decoration: BoxDecoration(
                              color: AppColors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(dummyDropdownItems[0].hint,
                                  style: Fonts.semibold14.copyWith(
                                      letterSpacing: 0.5, fontSize: 12)),
                              items: dummyDropdownItems[0]
                                  .menuItems
                                  .map<DropdownMenuItem<String>>(
                                (i) {
                                  return DropdownMenuItem<String>(
                                    value: i.value,
                                    child: Text(i.title,
                                        style: Fonts.semibold14.copyWith(
                                            letterSpacing: 0.5, fontSize: 12)),
                                  );
                                },
                              ).toList(),
                              isExpanded: true,
                              value: sortValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  sortValue = newValue!;
                                });
                              },
                            ),
                          )),
                    ),

                    SizedBox(width: 12),

                    // Type
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 36,
                          decoration: BoxDecoration(
                              color: AppColors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(dummyDropdownItems[1].hint,
                                  style: Fonts.semibold14.copyWith(
                                      letterSpacing: 0.5, fontSize: 12)),
                              items: dummyDropdownItems[1]
                                  .menuItems
                                  .map<DropdownMenuItem<String>>(
                                (i) {
                                  return DropdownMenuItem<String>(
                                    value: i.value,
                                    child: Text(i.title,
                                        style: Fonts.semibold14.copyWith(
                                            letterSpacing: 0.5, fontSize: 12)),
                                  );
                                },
                              ).toList(),
                              isExpanded: true,
                              value: typeValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  typeValue = newValue!;
                                });
                              },
                            ),
                          )),
                    ),

                    SizedBox(width: 12),

                    // Rating
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 36,
                          decoration: BoxDecoration(
                              color: AppColors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(dummyDropdownItems[2].hint,
                                  style: Fonts.semibold14.copyWith(
                                      letterSpacing: 0.5, fontSize: 12)),
                              items: dummyDropdownItems[2]
                                  .menuItems
                                  .map<DropdownMenuItem<String>>(
                                (i) {
                                  return DropdownMenuItem<String>(
                                    value: i.value,
                                    child: Text(i.title,
                                        style: Fonts.semibold14.copyWith(
                                            letterSpacing: 0.5, fontSize: 12)),
                                  );
                                },
                              ).toList(),
                              isExpanded: true,
                              value: ratingValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  ratingValue = newValue!;
                                });
                              },
                            ),
                          )),
                    ),
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
                      data: (c) => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: c.length,
                          itemBuilder: (context, i) =>
                              CollectCard(collect: c[i])),
                      error: (e, _) => Text('$e', style: Fonts.bold16),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                            color: AppColors.greenPrimary),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
