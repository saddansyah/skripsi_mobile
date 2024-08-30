import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class TestRepository {}

class _TestState extends ConsumerState<Test> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          session.isLoading
              ? const Text('Fetchin session')
              : const Text('Idling'),
          session.when(
              data: (data) {
                if (data == null) {
                  return const Text('Login Page');
                }
                return Text(data.refreshToken);
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator()),
          ElevatedButton(
            onPressed: () {
              ref.refresh(authControllerProvider);
            },
            child: const Text('Provider Refresh'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.refreshToken(session.value?.refreshToken ?? '-');
            },
            child: const Text('Token Refresh'),
          ),
          ElevatedButton(
            onPressed: session.isLoading ? null : controller.signInWithGoogle,
            child: const Text('SignIn'),
          ),
          ElevatedButton(
            onPressed: session.isLoading ? null : controller.signOut,
            child: const Text('SignOut'),
          ),
        ],
      ),
    );
  }
}
