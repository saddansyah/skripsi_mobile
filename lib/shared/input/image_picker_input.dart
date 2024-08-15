import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi_mobile/theme.dart';

class ImagePickerInput extends StatefulWidget {
  const ImagePickerInput(
      {super.key,
      this.selectedImage,
      required this.pickImage,
      required this.removeSelectedImage});

  final File? selectedImage;
  final Future Function(ImageSource) pickImage;
  final void Function() removeSelectedImage;

  @override
  State<ImagePickerInput> createState() => _ImagePickerInputState();
}

class _ImagePickerInputState extends State<ImagePickerInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(width: 1, color: Colors.grey[350]!)),
          padding: const EdgeInsets.all(24),
          child: widget.selectedImage != null
              ? Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Image.file(
                      widget.selectedImage!,
                      semanticLabel: 'Uploaded Image',
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: CircleAvatar(
                        backgroundColor: AppColors.red,
                        child: IconButton(
                            onPressed: () => widget.removeSelectedImage(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppColors.white,
                            )),
                      ),
                    )
                  ],
                )
              : Text(
                  'Tidak ada gambar yang dipilih..',
                  style: Fonts.regular14.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(height: 12),
        widget.selectedImage != null
            ? Center(
                child: Text(
                  'Tekan X apabila ingin unggah ulang',
                  style: Fonts.semibold14.copyWith(color: AppColors.grey),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(21),
                    elevation: 0,
                    backgroundColor: AppColors.lightGrey,
                    foregroundColor: AppColors.grey,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.grey[350]!),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    )),
                onPressed: () => widget.pickImage(ImageSource.camera),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_rounded,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Unggah Gambar',
                        style: Fonts.semibold14,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
