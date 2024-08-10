import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/screens/models/ui/input_card.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class WasteTypeInput extends StatelessWidget {
  const WasteTypeInput(
      {super.key,
      required this.type,
      required this.updateType,
      required this.isSelected});

  final InputCard<WasteType> type;
  final void Function(WasteType) updateType;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => updateType(type.value),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenAccent : AppColors.white,
          border: Border.all(width: 1, color: Colors.grey[350]!),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              type.img,
              height: 48,
              width: 48,
            ),
            SizedBox(height: 6),
            Text(type.title, style: Fonts.regular12)
          ],
        ),
      ),
    );
  }
}
