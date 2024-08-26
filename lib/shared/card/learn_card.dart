import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/models/learn.dart';
import 'package:skripsi_mobile/screens/learn/learn_detail_screen.dart';
import 'package:skripsi_mobile/shared/image/image_error.dart';
import 'package:skripsi_mobile/theme.dart';

class LearnCard extends StatelessWidget {
  const LearnCard({super.key, required this.learn});

  final Learn learn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => LearnDetailScreen(id: learn.id)));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: Colors.grey[350]!, width: 1),
          ),
          child: Row(
            children: [
              Container(
                height: 72,
                width: 72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Image.network(
                  learn.img,
                  errorBuilder: (context, error, stackTrace) {
                    return const ImageError();
                  },
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator(
                      color: AppColors.greenPrimary,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          learn.title,
                          style: Fonts.semibold14,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        )),
                        SizedBox(width: 6),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(learn.category,
                              style: Fonts.regular12.copyWith(fontSize: 10)),
                        )
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            learn.excerpt,
                            style: Fonts.regular12,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('dd/MM/yyyy - hh:mm')
                                .format(learn.createdAt.toLocal()),
                            style:
                                Fonts.regular12.copyWith(color: AppColors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
