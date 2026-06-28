import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'article_detail_screen.dart';
import 'article_editor_screen.dart';
import 'library_search_screen.dart';

class LibraryScreen extends StatefulWidget {
  final int initialTab;
  const LibraryScreen({super.key, this.initialTab = 0});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Future<void> _openSearch() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LibrarySearchScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openEditor() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ArticleEditorScreen()),
    );
    if (created == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.initialTab,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(S.library),
          actions: [
            if (MockData.userCanWriteArticles)
              IconButton(
                icon: const Icon(Icons.edit_note_rounded),
                tooltip: 'Tạo bài viết',
                onPressed: _openEditor,
              ),
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Tìm kiếm',
              onPressed: _openSearch,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: S.catMental),
              Tab(text: S.catPhysical),
              Tab(text: S.catSkills),
              Tab(text: S.catAlerts),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ArticleList(category: 'mental'),
            _ArticleList(category: 'physical'),
            _ArticleList(category: 'skills'),
            _ArticleList(category: 'alerts'),
          ],
        ),
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  final String category;
  const _ArticleList({required this.category});

  @override
  Widget build(BuildContext context) {
    final articles = MockData.articlesByCategory(category);
    final readCount = articles.where((a) => a.isRead).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '$readCount/${articles.length} ${S.articlesRead}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: articles.isEmpty
              ? Center(
                  child: Text(
                    'Chưa có bài viết',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return _ArticleCard(article: articles[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(article: article),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (article.isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Nổi bật',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${article.readMinutes} ${S.readMin}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (article.isRead)
                    const Icon(Icons.check_circle,
                        size: 18, color: AppColors.checkedIn),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                article.excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    S.readMore,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
