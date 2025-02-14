import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi_mobile/controller/collect_controller.dart';
import 'package:skripsi_mobile/models/collect.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/screens/learn/learn_detail_screen.dart';
import 'package:skripsi_mobile/screens/learn/learn_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/map_container_select_screen.dart';
import 'package:skripsi_mobile/shared/input/decoration/styled_input_decoration.dart';
import 'package:skripsi_mobile/shared/input/image_picker_input.dart';
import 'package:skripsi_mobile/shared/input/card_input.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/validator.dart';

class AddCollectScreen extends ConsumerStatefulWidget {
  const AddCollectScreen({super.key, this.container});

  final model.NearestContainer? container;

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

  model.NearestContainer selectedContainer = model.NearestContainer(
      id: 1,
      name: '-',
      distance: 0,
      lat: 0,
      long: 0,
      rating: 0,
      ratingCount: 0);

  @override
  void initState() {
    super.initState();

    if (widget.container != null) {
      selectedContainer = widget.container!;
    }
  }

  void updateContainer(model.NearestContainer container) {
    setState(() {
      selectedContainer = container;
    });
  }

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
      containerId: selectedContainer.id,
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
    final nearestContainer = ref.watch(nearestContainerProvider(50));

    ref.listen(nearestContainerProvider(50), (b, s) {
      if (s.hasError && !s.isLoading) {
        s.showErrorSnackbar(context, 'Lokasi belum dinyalakan');
      }

      if (s.hasValue) {
        setState(() {
          selectedContainer =
              widget.container != null ? widget.container! : s.value!.first;
        });
      }
    });

    ref.listen<AsyncValue>(collectControllerProvider, (_, s) {
      if (s.hasError && !s.isLoading) {
        s.showErrorSnackbar(context);
      }

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Menambah data');
      }

      if (!s.hasError && !s.isLoading) {
        s.showSnackbar(context,
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
          physics: const ScrollPhysics(),
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
                      border: Border.all(width: 2, color: Colors.grey[350]!)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Depo/Tong*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              style: Fonts.regular14,
                              decoration: StyledInputDecoration.basic(
                                  selectedContainer.name),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 12),
                          nearestContainer.when(
                            data: (data) {
                              return CircleAvatar(
                                backgroundColor: AppColors.greenPrimary,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              MapContainerSelectScreen(
                                                  selectedContainer:
                                                      selectedContainer,
                                                  updateContainer:
                                                      updateContainer),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_rounded,
                                      color: AppColors.white,
                                    )),
                              );
                            },
                            error: (error, stackTrace) => CircleAvatar(
                              backgroundColor: AppColors.lightGrey,
                              child: IconButton(
                                onPressed: null,
                                color: AppColors.grey,
                                icon: Icon(
                                  Icons.add_rounded,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            loading: () => CircleAvatar(
                              backgroundColor: AppColors.greenPrimary,
                              child: IconButton(
                                onPressed: null,
                                color: AppColors.grey,
                                icon: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.container != null
                            ? 'Default: Depo/Tong terpilih'
                            : 'Default: Depo/Tong terdekat',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Volume (L)*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: volController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic('Contoh: 0.3',
                            const Icon(Icons.unfold_more_rounded)),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input volume yang valid',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tiap harinya, satu orang memproduksi sekitar 0.3 L sampah',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Berat (kg)*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: kgController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic('Contoh: 0.05',
                            const Icon(Icons.unfold_more_rounded)),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input berat yang valid',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tiap harinya, satu orang memproduksi sekitar 0.17 kg sampah',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Tipe Sampah*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      const SizedBox(height: 12),
                      Text(
                        wasteTypeInputCards
                            .firstWhere((w) => w.value == selectedType)
                            .description,
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => const LearnDetailScreen(id: 4),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Masih bingung memilah? Buka panduan.',
                              style: Fonts.semibold14
                                  .copyWith(color: AppColors.greenPrimary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Sisipkan Foto*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      ImagePickerInput(
                          selectedImage: selectedImage,
                          pickImage: pickImageFromGallery,
                          removeSelectedImage: removeSelectedImage),
                      const SizedBox(height: 24),
                      Text('Pelapor*', style: Fonts.semibold14),
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
                      const SizedBox(height: 24),
                      Text('Informasi Tambahan*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: infoController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic(
                            'Contoh: Hari Ini Saya Mengumpulkan ...',
                            const Icon(Icons.messenger_rounded)),
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
                const SizedBox(height: 24),
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
                                  Icons.add_rounded,
                                  color: AppColors.white,
                                  weight: 100,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  'Tambah Laporan',
                                  style: Fonts.bold16,
                                ),
                                const SizedBox(width: 9),
                                const AddedPointPill(point: '10')
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
