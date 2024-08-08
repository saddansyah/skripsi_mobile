import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/error_extension.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final profile = ref.watch(profileProvider);

    ref.listen<AsyncValue>(profileProvider, (_, s) {
      s.showSnackbarOnError(context);
    });

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.greenPrimary,
            ),
            child: Center(
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                    color: AppColors.amber),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: profile.when(
                      data: (data) => Image.network(
                            data.avatarUrl,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return CircularProgressIndicator(
                                color: AppColors.greenPrimary,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              );
                            },
                          ),
                      error: (e, s) => const Text('Error'),
                      loading: () => CircularProgressIndicator(
                          color: AppColors.greenPrimary)),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: profile.when(
                            data: (d) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hello, ${d.name.split(' ')[0]}!',
                                        style: Fonts.bold16),
                                    Text(d.rank, style: Fonts.regular12),
                                  ],
                                ),
                            error: (e, _) => Text('$e', style: Fonts.bold16),
                            loading: () => Text('...', style: Fonts.bold16)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(72)),
                            border: Border.all(
                                color: Colors.amberAccent, width: 2)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.amber,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              profile.whenOrNull(
                                      data: (data) =>
                                          data.totalPoint.toString()) ??
                                  '-',
                              style:
                                  Fonts.bold16.copyWith(color: AppColors.amber),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    onPressed: () {
                      authState.isLoading ? null : authController.signOut();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded),
                        SizedBox(width: 6, height: 48),
                        Text('Keluar Akun',
                            style: Fonts.semibold16
                                .copyWith(color: AppColors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
