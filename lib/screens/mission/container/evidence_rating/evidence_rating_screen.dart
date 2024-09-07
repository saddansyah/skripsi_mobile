import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/evidence_rating_controller.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/models/evidence_rating.dart';
import 'package:skripsi_mobile/repositories/evidence_rating_repository.dart';
import 'package:skripsi_mobile/shared/input/decoration/styled_input_decoration.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/validator.dart';

class EvidenceRatingScreen extends ConsumerStatefulWidget {
  const EvidenceRatingScreen({super.key, required this.container});

  final model.DetailedContainer container;

  @override
  ConsumerState<EvidenceRatingScreen> createState() =>
      _EvidenceRatingScreenState();
}

class _EvidenceRatingScreenState extends ConsumerState<EvidenceRatingScreen> {
  final formKey = GlobalKey<FormState>();
  Reporter selectedReporter = Reporter.user;
  double rating = 0;
  final infoController = TextEditingController();

  @override
  void dispose() {
    infoController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(popSnackbar(
          'Input data tidak lengkap/invalid. Mohon isi dengan benar',
          SnackBarType.error));
      return;
    }

    final newRating = PayloadEvidenceRating(
      value: rating.toInt(),
      isAnonim: selectedReporter == Reporter.anonim,
      info: infoController.text.trim(),
      containerId: widget.container.id,
    );

    ref
        .read(evidenceRatingControllerProvider.notifier)
        .addContainerRating(newRating);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(evidenceRatingControllerProvider);

    ref.listen<AsyncValue>(evidenceRatingControllerProvider, (_, s) {
      s.showErrorSnackbar(context);

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Menambah data');
      }

      if (!s.hasError && !s.isLoading) {
        s.showSnackbar(context, 'Kamu mendapatkan 5⭐ tambahan dari rating depo!');
        ref.invalidate(evidenceRatingProvider);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Tambah Depo/Tong Baru', style: Fonts.semibold16),
        centerTitle: false,
        leading: IconButton(
          onPressed: state.isLoading
              ? null
              : () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info about Evidence Rating
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.greenPrimary, Colors.green[800]!]),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#learn2',
                          style:
                              Fonts.regular14.copyWith(color: AppColors.white)),
                      const SizedBox(height: 6),
                      Text(
                        'Apa itu Evidence Rate?',
                        style: Fonts.bold18
                            .copyWith(color: AppColors.white, fontSize: 21),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: AppColors.dark1.withOpacity(0.1)),
                        child: Column(
                          children: [
                            Text(
                              'Evidence rate adalah nilai yang menentukan apakah sebuah tong sampah itu valid berdasarkan rating dari pengguna lain.',
                              style: Fonts.regular14
                                  .copyWith(color: AppColors.white),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Pengguna dapat memilih anonim atau tidak ketika melakukan evidence rating.',
                              style: Fonts.regular14
                                  .copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    border: Border.all(width: 2, color: Colors.grey[350]!),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rating ${widget.container.name}*',
                          style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      Center(
                        child: RatingBar(
                          minRating: 0,
                          maxRating: 5,
                          allowHalfRating: false,
                          initialRating: rating,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star_rounded,
                                color: AppColors.amber,
                              ),
                              half: Icon(
                                Icons.star_half_rounded,
                                color: AppColors.amber,
                              ),
                              empty: Icon(
                                Icons.star_outline_rounded,
                                color: AppColors.amber,
                              )),
                          onRatingUpdate: (double value) {
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Reporter*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            items:
                                Reporter.values.map<DropdownMenuItem<Reporter>>(
                              (r) {
                                return DropdownMenuItem<Reporter>(
                                  value: r,
                                  child: Text(r.title, style: Fonts.semibold14),
                                );
                              },
                            ).toList(),
                            isExpanded: true,
                            value: selectedReporter,
                            onChanged: (Reporter? newValue) {
                              setState(() {
                                selectedReporter = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Pesan', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: infoController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic(
                            'Contoh: Depo sangat bersih...',
                            const Icon(Icons.messenger_rounded)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input pesan',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 2, color: Colors.grey[350]!)),
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.greenPrimary,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    onPressed: state.isLoading ? null : () => handleSubmit(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                const SizedBox(width: 9),
                                Text(
                                  'Kumpulkan Rating',
                                  style: Fonts.bold16,
                                ),
                                const SizedBox(width: 9),
                                const AddedPointPill(point: '5')
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
