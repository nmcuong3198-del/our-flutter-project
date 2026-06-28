import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'article_detail_screen.dart';

/// Lists the articles the user has bookmarked (design 5.7 "Bài viết đã lưu").
class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    final saved = MockData.savedArticles;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bài viết đã lưu'),
      ),
      body: saved.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_border_rounded,
                      size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có bài viết nào được lưu',
                    style: TextStyle(fontSize: 15, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nhấn biểu tượng lưu trong bài viết để lưu lại đây.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: saved.length,
              itemBuilder: (_, i) => _SavedCard(
                article: saved[i],
                onChanged: () => setState(() {}),
              ),
            ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  final Article article;
  final VoidCallback onChanged;
  const _SavedCard({required this.article, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
          );
          onChanged();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bookmark, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${article.readMinutes} ${S.readMin}',
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_remove_outlined, color: AppColors.onSurfaceVariant),
                tooltip: 'Bỏ lưu',
                onPressed: () {
                  article.isSaved = false;
                  onChanged();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
