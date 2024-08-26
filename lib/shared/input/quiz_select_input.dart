import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/theme.dart';

class QuizSelectInput<T> extends StatelessWidget {
  const QuizSelectInput(
      {super.key,
      required this.isSelected,
      required this.index,
      required this.input,
      required this.updateSelected});

  final Input<T> input;
  final void Function(T) updateSelected;
  final bool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(9),
            side: BorderSide(
                width: 2,
                color: isSelected ? AppColors.greenPrimary : Colors.grey[350]!),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(99)),
            )),
        onPressed: () => updateSelected(input.value),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? AppColors.greenPrimary : AppColors.blueAccent,
              child: Text(
                switch (index) {
                  0 => 'A',
                  1 => 'B',
                  2 => 'C',
                  3 => 'D',
                  _ => '-'
                },
                style: Fonts.semibold14.copyWith(
                    color:
                        isSelected ? AppColors.white : AppColors.bluePrimary),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                input.title,
                style: Fonts.semibold14.copyWith(color: AppColors.dark2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
