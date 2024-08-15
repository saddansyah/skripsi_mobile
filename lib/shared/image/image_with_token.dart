import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/shared/image/image_error.dart';
import 'package:skripsi_mobile/theme.dart';

class ImageWithToken extends ConsumerWidget {
  const ImageWithToken(this.src, {super.key});

  final String src;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);

    return Image.network(
      headers: {'authorization': 'Bearer ${session.value?.accessToken ?? ''}'},
      errorBuilder: (context, error, stackTrace) {
        return const ImageError();
      },
      src,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator(
          color: AppColors.greenPrimary,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        );
      },
    );
  }
}
