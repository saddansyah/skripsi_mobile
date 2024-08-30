import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/shared/image/image_error.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class AppBarImage extends ConsumerStatefulWidget {
  const AppBarImage(this.height, this.width, {super.key});

  final double height;
  final double width;

  @override
  ConsumerState<AppBarImage> createState() => _AppBarImageState();
}

class _AppBarImageState extends ConsumerState<AppBarImage> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return GestureDetector(
      onTap: () {
        ref.refresh(profileProvider);
        ScaffoldKeys.mainLayoutKey.currentState!.openEndDrawer();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(99)),
            color: AppColors.white),
        clipBehavior: Clip.hardEdge,
        child: profile.when(
            data: (data) => Image.network(
                  errorBuilder: (context, error, stackTrace) =>
                      const ImageError(),
                  data.avatarUrl,
                  fit: BoxFit.fill,
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
                ),
            error: (e, s) => const Text('Error'),
            loading: () =>
                CircularProgressIndicator(color: AppColors.greenPrimary)),
      ),
    );
  }
}
