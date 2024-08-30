import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/flashcard_repository.dart';
import 'package:skripsi_mobile/theme.dart';

class FlashcardDialog extends ConsumerWidget {
  const FlashcardDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcard = ref.watch(flashcardProvider);

    return AlertDialog(
      icon: const Icon(Icons.lightbulb),
      iconColor: AppColors.amber,
      title:
          Text("#LebihTahu${flashcard.value?.id ?? ''}", style: Fonts.bold16),
      content: flashcard.isLoading
          ? Container(
              height: 60,
              width: 540,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
            )
          : Text(
              flashcard.value?.content ?? '...',
              style: Fonts.regular14,
              textAlign: TextAlign.center,
            ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Nice Info!",
                style: Fonts.bold16
                    .copyWith(color: AppColors.greenPrimary, fontSize: 14)))
      ],
    );
  }
}
