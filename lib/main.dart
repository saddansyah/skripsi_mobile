
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/screens/auth/sign_in_screen.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/extension.dart';
import 'package:skripsi_mobile/utils/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print(await Permission.camera.isGranted);
  print(await Permission.location.isGranted);

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("1dc3f11d-5e6f-4710-ae7b-2dc3c379e07f");
  OneSignal.Notifications.requestPermission(true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: ScaffoldKeys.snackbarKey,
      title: 'Skripsi Mobile',
      theme: getPrimaryTheme(context),
      home: Consumer(
        builder: (context, ref, child) {
          final session = ref.watch(authControllerProvider);

          ref.listen<AsyncValue>(authControllerProvider, (e, s) {
            if (s.hasError && !s.isLoading) {
              s.showErrorSnackbar(context);
            }
          });

          return session.when(
            data: (d) {
              if (d == null) {
                return const SignIn();
              }
              return const MainLayout();
            },
            error: (error, __) {
              return Scaffold(
                body: ErrorScreen(
                    isRefreshing: session.isRefreshing,
                    onPressed: () {
                      if (error.toString().contains('401')) {
                        ref.read(authControllerProvider.notifier).signOut();
                      } else {
                        ref.invalidate(authControllerProvider);
                      }
                    },
                    message: error.toString()),
              );
            },
            loading: () => const Scaffold(
              body: LoadingScreen(
                  message: 'Aplikasi sedang mempersiapkan semuanya untukmu 😁'),
            ),
          );
        },
      ),
    );
  }
}
