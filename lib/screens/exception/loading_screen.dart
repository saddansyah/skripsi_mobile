import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: AppColors.amber,
            ),
            child: CircularProgressIndicator(color: AppColors.greenPrimary),
          ),
          SizedBox(height: 36),
          Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('Tunggu sebentar ya..', style: Fonts.bold18),
              Text(message, style: Fonts.regular14),
            ],
          ),
        ],
      ),
    );
  }
}
