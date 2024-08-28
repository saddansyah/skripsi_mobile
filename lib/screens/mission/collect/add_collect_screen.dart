import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/controller/collect_controller.dart';
import 'package:skripsi_mobile/models/collect.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/screens/mission/collect/map_container_select_screen.dart';
import 'package:skripsi_mobile/shared/card/nearest_container_card.dart';
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

  model.NearestContainer selectedContainer =
      model.NearestContainer(id: 1, name: '-', distance: 0, lat: 0, long: 0);
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

    ref.listen(nearestContainerProvider(50), (_, s) {
      if (s.hasValue) {
        setState(() {
          selectedContainer =
              widget.container != null ? widget.container! : s.value!.first;
        });
      }
    });

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
                      border: Border.all(width: 2, color: Colors.grey[350]!)),
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
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              style: Fonts.regular14,
                              decoration: StyledInputDecoration.basic(
                                  selectedContainer.name),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 12),
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
                                      Icons.map_rounded,
                                      color: AppColors.white,
                                    )),
                              );
                            },
                            error: (error, stackTrace) => CircleAvatar(
                              backgroundColor: AppColors.greenPrimary,
                              child: IconButton(
                                onPressed: null,
                                color: AppColors.grey,
                                icon: Icon(
                                  Icons.map_rounded,
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
                      SizedBox(height: 12),
                      Text(
                        widget.container != null
                            ? 'Default: Depo/Tong terpilih'
                            : 'Default: Depo/Tong terdekat',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      SizedBox(height: 24),
                      Text('Volume (L)*', style: Fonts.semibold14),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: volController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic('Contoh: 1.2',
                            const Icon(Icons.unfold_more_rounded)),
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
                        decoration: StyledInputDecoration.basic('Contoh: 1.2',
                            const Icon(Icons.unfold_more_rounded)),
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
                SizedBox(height: 24),
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
