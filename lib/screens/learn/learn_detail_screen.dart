import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/repositories/learn_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/loading_screen.dart';
import 'package:skripsi_mobile/shared/image/image_error.dart';
import 'package:skripsi_mobile/theme.dart';

class LearnDetailScreen extends ConsumerStatefulWidget {
  const LearnDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends ConsumerState<LearnDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final learn = ref.watch(learnProvider(widget.id));

    return Scaffold(
      body: learn.when(
        error: (e, s) => ErrorScreen(message: e.toString()),
        loading: () =>
            LoadingScreen(message: 'Data artikel sedang dimuat nih..'),
        data: (l) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 240,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Image.network(
                    l.img,
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin - ${DateFormat('yyyy/MM/dd - hh:mm:ss').format(l.createdAt.toLocal())}',
                            style:
                                Fonts.regular12.copyWith(color: AppColors.grey),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(l.title, style: Fonts.bold18),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Column(
                              children: [
                                Text(l.excerpt, style: Fonts.regular14),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            child: MarkdownBody(
                                imageBuilder: (uri, title, alt) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      uri.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                    horizontalRuleDecoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.lightGrey)),
                                    h1: Fonts.bold18,
                                    h2: Fonts.bold16,
                                    h3: Fonts.semibold16,
                                    h4: Fonts.semibold14,
                                    p: Fonts.regular14),
                                data: ''' ${l.content} '''.trim()),
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Kategori:',
                                style: Fonts.regular14
                                    .copyWith(color: AppColors.grey),
                              ),
                              SizedBox(width: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Text(l.category, style: Fonts.regular14),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
