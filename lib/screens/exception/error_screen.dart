import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(
      {super.key,
      required this.message,
      this.isButton = true,
      this.onPressed,
      this.isRefreshing = false});

  final String message;
  final void Function()? onPressed;
  final bool isRefreshing;
  final bool isButton;

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
          ),
          SizedBox(height: 36),
          Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('Sayang sekali :(', style: Fonts.bold18),
              Text(message, style: Fonts.regular14),
            ],
          ),
          SizedBox(height: 36),
          isButton
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.greenPrimary,
                      foregroundColor: AppColors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                  onPressed: isRefreshing
                      ? null
                      : () => onPressed != null
                          ? onPressed!()
                          : Navigator.of(context, rootNavigator: true).pop(),
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 240,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: isRefreshing
                          ? [CircularProgressIndicator(color: AppColors.grey)]
                          : [
                              Text(
                                'Kembali',
                                style: Fonts.bold16,
                              ),
                            ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
