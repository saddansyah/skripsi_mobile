import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/screens/auth/sign_in.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://gqukwmsjfyupbgvhdjob.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWt3bXNqZnl1cGJndmhkam9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAzMjM5MzksImV4cCI6MjAzNTg5OTkzOX0.xxoOgCpEV4szLPm_hQ8ggCVRrUK6r-jLxoJpJ23eyNw',
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skripsi Mobile',
      theme: getPrimaryTheme(context),
      home: Consumer(builder: (context, ref, child) {
        final sessionStream = ref.watch(sessionProvider);
        
        return sessionStream.when(
          data: (session) {
            if (session == null) return const SignIn();
            return const MainLayout();
          },
          error: (error, __) => const Text('error loading auth status.'),
          loading: () {
            return Container(
              color: AppColors.amber,
            );
          },
        );
      }),
    );
  }
}
