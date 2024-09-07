import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:skripsi_mobile/controller/container_controller.dart';
import 'package:skripsi_mobile/models/cluster.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/repositories/cluster_repository.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/repositories/geolocation_repository.dart';
import 'package:skripsi_mobile/screens/mission/container/map_select_screen.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/select_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/input/decoration/styled_input_decoration.dart';
import 'package:skripsi_mobile/shared/input/card_input.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/validator.dart';

class AddContanierScreen extends ConsumerStatefulWidget {
  const AddContanierScreen({super.key});

  @override
  ConsumerState<AddContanierScreen> createState() => _AddContanierScreenState();
}

class _AddContanierScreenState extends ConsumerState<AddContanierScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    maxVolController.dispose();
    maxKgController.dispose();
    infoController.dispose();
    nameController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final maxVolController = TextEditingController();
  final maxKgController = TextEditingController();
  final infoController = TextEditingController();

  late Cluster selectedCluster = Cluster(
    id: 1,
    name: 'Teknik',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  void updateCluster(Cluster cluster) {
    setState(() {
      selectedCluster = cluster;
    });
  }

  // TODO -> replaced by current user location
  LatLng? selectedLocation;
  void updateLocation(LatLng newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  // Waste type
  ContainerType selectedType = ContainerType.tong;
  void updateType(ContainerType type) {
    setState(() {
      selectedType = type;
    });
  }

  // Show Clusters
  void showClusters(List<Cluster> clusters) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SelectButtomSheet<Cluster>(
          initialValue: selectedCluster,
          updateSelected: updateCluster,
          data: clusters,
          onConfirmPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Pilih klaster',
          message:
              'Pilihlah klaster yang sesuai dengan lokasi depo/tong terletak',
          color: AppColors.greenPrimary,
        );
      },
    );
  }

  // Submit
  void handleSubmit() {
    if (!formKey.currentState!.validate() && selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(popSnackbar(
          'Input data tidak lengkap/invalid. Mohon isi dengan benar',
          SnackBarType.error));

      return;
    }

    final newContainer = model.PayloadContainer(
        name: nameController.text.trim(),
        maxKg: double.parse(maxKgController.text.trim()),
        maxVol: double.parse(maxVolController.text.trim()),
        lat: selectedLocation!.latitude,
        long: selectedLocation!.longitude,
        type: selectedType,
        clusterId: selectedCluster.id);

    ref.read(containerControllerProvider.notifier).addContainer(newContainer);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(containerControllerProvider);
    final clusters = ref.watch(clustersProvider);
    final currentPosition = ref.watch(currentPositionProvider);

    ref.listen<AsyncValue>(containerControllerProvider, (_, s) {
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
        ref.invalidate(containersProvider);
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
                      Text('Nama Depo/Tong', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic(
                            'Contoh: Depo Fakultas Teknik'),
                        keyboardType: TextInputType.text,
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input nama depo/tong yang valid',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Tipe Depo/Tong*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: containerTypeInputCards.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 1,
                          crossAxisCount: 3,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),
                        itemBuilder: (c, i) => CardInput(
                            type: containerTypeInputCards[i],
                            updateType: updateType,
                            isSelected: selectedType ==
                                containerTypeInputCards[i].value),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        containerTypeInputCards
                            .firstWhere((w) => w.value == selectedType)
                            .description,
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Kapasitas Volume Maks (L)*',
                          style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: maxVolController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic(
                          'Contoh: 25 (dalam L)',
                          const Icon(Icons.unfold_more_rounded),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input maksimum volume yang valid',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Biasanya, kapasitas tong untuk 1 KK (3-4 orang) adalah 10-40L sedangkan kapasitas depo untuk 40-80 KK adalah 500-1000L',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Kapasitas Berat Maks (kg)*',
                          style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: maxKgController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Fonts.regular14,
                        decoration: StyledInputDecoration.basic(
                            'Contoh: 9 (dalam kg)',
                            const Icon(Icons.unfold_more_rounded)),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) => textfieldValidator(
                          value,
                          message: 'Mohon input maksimum berat yang valid',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Biasanya, kapasitas tong untuk 1 KK (3-4 orang) adalah 0.6-2.3 kg sedangkan kapasitas depo untuk 40-80 KK adalah 10-35 kg',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Lokasi*', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1, color: AppColors.greenPrimary),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                // Default value = user coordinate
                                if (selectedLocation == null &&
                                    !currentPosition.hasError &&
                                    !currentPosition.isLoading &&
                                    currentPosition.hasValue) {
                                  selectedLocation = LatLng(
                                      currentPosition.value?.latitude ?? 0,
                                      currentPosition.value?.longitude ?? 0);
                                }

                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (_) => MapSelectScreen(
                                      updateCoord: updateLocation,
                                      initialCoord: selectedLocation!,
                                    ),
                                  ),
                                );
                              },
                        child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: double.infinity,
                          child: Center(
                            child: state.isLoading
                                ? CircularProgressIndicator(
                                    color: AppColors.greenPrimary)
                                : Text(
                                    'Pilih Lokasi (Map)',
                                    style: Fonts.semibold14.copyWith(
                                        color: AppColors.greenPrimary),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Koordinat [${selectedLocation?.latitude ?? '-'}, ${selectedLocation?.longitude ?? '-'}]',
                        style: Fonts.semibold14
                            .copyWith(fontSize: 12, color: AppColors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text('Klaster', style: Fonts.semibold14),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              style: Fonts.regular14,
                              decoration: StyledInputDecoration.basic(
                                  selectedCluster.name),
                            ),
                          ),
                          const SizedBox(width: 12),
                          clusters.when(
                            data: (data) => CircleAvatar(
                              backgroundColor: AppColors.greenPrimary,
                              child: IconButton(
                                onPressed: () => showClusters(data),
                                icon: Icon(
                                  Icons.location_city_rounded,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            error: (error, stackTrace) => CircleAvatar(
                              backgroundColor: AppColors.greenPrimary,
                              child: IconButton(
                                onPressed: null,
                                color: AppColors.grey,
                                icon: Icon(
                                  Icons.location_city_rounded,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih sesuai klaster yang ada',
                        style: Fonts.regular12.copyWith(color: AppColors.grey),
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
