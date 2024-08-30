import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class Dropdown<T extends DropdownData> extends StatelessWidget {
  const Dropdown(
      {super.key,
      required this.hint,
      required this.data,
      required this.onChanged,
      required this.selectedValue});

  final String? selectedValue;
  final String hint;
  final List<T> data;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 36,
        decoration: BoxDecoration(
            color: AppColors.greenAccent,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(hint,
                style: Fonts.semibold14
                    .copyWith(letterSpacing: 0.5, fontSize: 12)),
            items: data
                .map<DropdownMenuItem<String>>((i) => DropdownMenuItem(
                    value: i.query,
                    child: Text(
                      i.title,
                      style: Fonts.semibold14.copyWith(
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    )))
                .toList(),
            isExpanded: true,
            value: selectedValue,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
