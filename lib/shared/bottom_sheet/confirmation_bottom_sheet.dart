import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skripsi_mobile/theme.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  const ConfirmationBottomSheet({
    super.key,
    required this.onConfirmPressed,
    required this.title,
    required this.message,
    this.color,
    this.yes,
    this.no,
  });

  final void Function() onConfirmPressed;
  final String title;
  final String message;
  final Color? color;
  final String? yes;
  final String? no;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: Fonts.bold18,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    message,
                    style: Fonts.regular12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 1, color: color ?? AppColors.greenPrimary),
                          elevation: 0,
                          foregroundColor: color ?? AppColors.greenPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          )),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
                        child: Text(
                          no ?? 'Tidak',
                          style: Fonts.bold16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: color ?? AppColors.greenPrimary,
                          foregroundColor: AppColors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          )),
                      onPressed: onConfirmPressed,
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
                        child: Text(
                          yes ?? 'Ya',
                          style: Fonts.bold16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
