import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/screens/models/session.dart';
import 'package:skripsi_mobile/utils/interceptor.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class TestRepository {
  static void setup() async {
    Response<ResponseBody> rs = await Dio().get<ResponseBody>(
      '${Api.baseUrl}/auth/state',
      options: Options(headers: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      }, responseType: ResponseType.stream), // set responseType to `stream`
    );

    StreamTransformer<Uint8List, List<int>> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );

    rs.data!.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .where((s) => s.startsWith('data'))
        .map((s) => s.substring(6))
        .map((s) => jsonDecode(s))
        .map((s) => s['data'] == null ? s : Session.fromMap(s['data']))
        .listen((event) => print(event.toString()));
  }
}

class _TestState extends ConsumerState<Test> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final authContoller = ref.read(authControllerProvider.notifier);
    final session = ref.watch(sessionProvider);

    return SafeArea(
      child: Column(
        children: [
          state.isLoading ? const CircularProgressIndicator() : const Text('Idling'),
          session.when(
              data: (data) => Text(data?.refreshToken ?? '-'),
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator()),
          ElevatedButton(
            onPressed: () {
              // TestRepository.setup();
            },
            child: const Text('Setup'),
          ),
          ElevatedButton(
            onPressed: state.isLoading ? null : authContoller.signInWithGoogle,
            child: const Text('SignIn'),
          ),
          ElevatedButton(
            onPressed: state.isLoading ? null : authContoller.signOut,
            child: const Text('SignOut'),
          ),
        ],
      ),
    );
  }
}
