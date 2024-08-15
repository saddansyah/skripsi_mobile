import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi_mobile/controller/collect_controller.dart';
import 'package:skripsi_mobile/models/collect.dart';
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/shared/input/image_picker_input.dart';
import 'package:skripsi_mobile/shared/input/waste_type_input.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/validator.dart';

class AddCollectScreen extends ConsumerStatefulWidget {
  const AddCollectScreen({super.key});

  @override
  ConsumerState<AddCollectScreen> createState() => _AddCollectScreenState();
}

class _AddCollectScreenState extends ConsumerState<AddCollectScreen> {
  @override
  void dispose() {
    volController.dispose();
    kgController.dispose();
    infoController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  final volController = TextEditingController();
  final kgController = TextEditingController();
  final infoController = TextEditingController();

  int selectedContainer = 1;
  Reporter selectedReporter = Reporter.user;

  // Waste type
  WasteType selectedType = WasteType.mixed;
  void updateType(WasteType type) {
    setState(() {
      selectedType = type;
    });
  }

  // Image input
  File? selectedImage;
  Future pickImageFromGallery(ImageSource source) async {
    final returnedImage = await ImagePicker().pickImage(
        source: source, maxHeight: 720, maxWidth: 720, imageQuality: 35);

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  void removeSelectedImage() {
    setState(() {
      selectedImage = null;
    });
  }

  // Submit
  void handleSubmit() {
    if (!formKey.currentState!.validate() || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(popSnackbar(
          'Input data tidak lengkap/invalid. Mohon isi dengan benar',
          SnackBarType.error));

      return;
    }

    final newCollect = PayloadCollect(
      type: selectedType,
      containerId: selectedContainer,
      kg: double.parse(kgController.text.trim()),
      vol: double.parse(volController.text.trim()),
      info: infoController.text.trim(),
      isAnonim: selectedReporter == Reporter.anonim,
    );

    ref
        .read(collectControllerProvider.notifier)
        .addMyCollect(newCollect, selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(collectControllerProvider);

    ref.listen<AsyncValue>(collectControllerProvider, (_, state) {
      if (state.isLoading) {
        state.showLoadingSnackbar(context, 'Menambah data');
      }

      if (!state.hasError && !state.isLoading) {
        state.showSnackbar(context,
            'Asyik! Poin akan kamu dapatkan ketika laporanmu disetujui Admin 🤩');
        Navigator.of(context, rootNavigator: true).pop();
        ref.invalidate(collectsProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Input Kumpul Sampah', style: Fonts.semibold16),
        centerTitle: false,
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: Colors.grey[350]!)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Depo/Tong*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              initialValue: 'Container 1',
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              style: Fonts.regular14,
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                suffixIcon: Icon(Icons.location_pin),
                                suffixIconColor: AppColors.grey,
                                border: InputBorder.none,
                                filled: true,
                                fillColor: AppColors.lightGrey,
                                focusColor: AppColors.lightGrey,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 12),
                          CircleAvatar(
                            backgroundColor: AppColors.greenPrimary,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.map_rounded,
                                  color: AppColors.white,
                                )),
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Default: Depo/Tong terdekat',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      SizedBox(height: 24),
                      Text('Volume (L)*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: volController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Contoh: 1.2',
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: AppColors.greenPrimary)),
                          suffixIcon: Icon(Icons.unfold_more_rounded),
                          suffixIconColor: AppColors.grey,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          focusColor: AppColors.lightGrey,
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input volume yang valid',
                        ),
                      ),
                      SizedBox(height: 24),
                      Text('Berat (kg)*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: kgController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Contoh: 2.1',
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: AppColors.greenPrimary)),
                          suffixIcon: Icon(Icons.unfold_more_rounded),
                          suffixIconColor: AppColors.grey,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          focusColor: AppColors.lightGrey,
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input berat yang valid',
                        ),
                      ),
                      SizedBox(height: 24),
                      Text('Tipe Sampah*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: wasteTypeInputCards.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 1,
                          crossAxisCount: 3,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),
                        itemBuilder: (c, i) => CardInput<WasteType>(
                            type: wasteTypeInputCards[i],
                            updateType: updateType,
                            isSelected:
                                selectedType == wasteTypeInputCards[i].value),
                      ),
                      SizedBox(height: 12),
                      Text(
                        wasteTypeInputCards
                            .firstWhere((w) => w.value == selectedType)
                            .description,
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      SizedBox(height: 24),
                      Text('Sisipkan Foto*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      ImagePickerInput(
                          selectedImage: selectedImage,
                          pickImage: pickImageFromGallery,
                          removeSelectedImage: removeSelectedImage),
                      SizedBox(height: 24),
                      Text('Pelapor*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
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
                      SizedBox(height: 24),
                      Text('Informasi Tambahan*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: infoController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText:
                              'Contoh: Hari ini saya mengumpulkan sampah di dekat Fakultas Teknik...',
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: AppColors.greenPrimary)),
                          suffixIcon: Icon(Icons.messenger_rounded),
                          suffixIconColor: AppColors.grey,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          focusColor: AppColors.lightGrey,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input informasi tambahan',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: Colors.grey[350]!)),
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
                                  Icons.edit_rounded,
                                  color: AppColors.white,
                                  weight: 100,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  'Tambah Laporan',
                                  style: Fonts.bold16,
                                ),
                                const SizedBox(width: 9),
                                AddedPointPill(point: 5)
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
