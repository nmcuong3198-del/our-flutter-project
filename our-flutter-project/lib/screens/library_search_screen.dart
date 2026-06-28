import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import 'article_detail_screen.dart';

/// Library search screen (design 5.3): query field, result count and article results.
class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({super.key});

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = MockData.searchArticles(_query);
    final hasQuery = _query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Tìm bài viết, chủ đề...',
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (hasQuery)
                GestureDetector(
                  onTap: () => setState(() {
                    _controller.clear();
                    _query = '';
                  }),
                  child: const Icon(Icons.close, size: 18, color: AppColors.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ),
      body: !hasQuery
          ? _buildSuggestions()
          : results.isEmpty
              ? _buildEmpty()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        '${results.length} bài viết',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: results.length,
                        itemBuilder: (_, i) => _SearchResultCard(article: results[i]),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSuggestions() {
    const suggestions = ['Dậy thì', 'Kinh nguyệt', 'Cảm xúc', 'Dinh dưỡng', 'Chiều cao'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gợi ý tìm kiếm',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions
                .map((s) => GestureDetector(
                      onTap: () => setState(() {
                        _controller.text = s;
                        _query = s;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả cho "$_query"',
            style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Article article;
  const _SearchResultCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${article.readMinutes} ${S.readMin}',
                      style: const TextStyle(fontSize: 11, color: AppColors.primary),
                    ),
                  ),
                  const Spacer(),
                  if (article.isSaved)
                    const Icon(Icons.bookmark, size: 18, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                article.excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
