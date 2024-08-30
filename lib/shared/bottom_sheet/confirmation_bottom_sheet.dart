import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  const ConfirmationBottomSheet({
    super.key,
    required this.onConfirmPressed,
    required this.title,
    required this.message,
    this.onDismissPressed,
    this.color,
    this.yes,
    this.no,
  });

  final void Function() onConfirmPressed;
  final void Function()? onDismissPressed;
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
        padding: const EdgeInsets.all(24),
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
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Fonts.regular14,
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
                    onPressed:
                        onDismissPressed ?? () => Navigator.of(context).pop(),
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
                const SizedBox(width: 12),
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
    );
  }
}
