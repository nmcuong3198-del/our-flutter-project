import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import '../shared/app_modals.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.article.isRead = true;
  }

  // 5.5 — rating modal with feedback + "Để sau", then 5.6 thank-you.
  void _showRatingDialog() {
    int tempRating = widget.article.rating;
    final feedback = TextEditingController();
    showDialog(
      context: context,
      barrierColor: AppColors.onBackground.withValues(alpha: 0.4),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  S.rateArticle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ý kiến của bạn giúp chúng tôi cải thiện nội dung tốt hơn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < tempRating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: AppColors.tertiaryFixedDim,
                        size: 38,
                      ),
                      onPressed: () => setDialogState(() => tempRating = i + 1),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedback,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Chia sẻ thêm cảm nhận... (tuỳ chọn)',
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: tempRating == 0
                        ? null
                        : () {
                            setState(() => widget.article.rating = tempRating);
                            Navigator.pop(ctx);
                            showSuccessModal(
                              context,
                              icon: Icons.favorite_rounded,
                              iconColor: AppColors.primary,
                              iconBgColor: AppColors.secondaryContainer,
                              title: 'Cảm ơn bạn đã đánh giá!',
                              message: 'Phản hồi của bạn sẽ giúp chúng tôi mang lại '
                                  'trải nghiệm tốt hơn.',
                              buttonLabel: 'Đóng',
                            );
                          },
                    child: const Text('Gửi'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Để sau',
                      style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 5.7 — save/bookmark with success modal.
  void _toggleSave() {
    setState(() => widget.article.isSaved = !widget.article.isSaved);
    if (widget.article.isSaved) {
      showSuccessModal(
        context,
        icon: Icons.bookmark_added_rounded,
        iconColor: AppColors.success,
        iconBgColor: const Color(0xFFD7F2DD),
        title: 'Lưu thành công!',
        message: 'Bài viết đã được lưu vào mục "Bài viết đã lưu" của bạn.',
        buttonLabel: 'Đóng',
      );
    }
  }

  // 5.8 — share modal with recipient, then 5.9 success.
  void _shareArticle() {
    final recipient = TextEditingController();
    showDialog(
      context: context,
      barrierColor: AppColors.onBackground.withValues(alpha: 0.4),
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                S.shareArticle,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Gửi bài viết này đến bạn bè và người thân của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: recipient,
                decoration: InputDecoration(
                  labelText: 'Người nhận',
                  hintText: 'Nhập email hoặc tên người nhận',
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showSuccessModal(
                      context,
                      icon: Icons.send_rounded,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.secondaryContainer,
                      title: 'Chia sẻ thành công!',
                      message: 'Cảm ơn bạn đã chia sẻ kiến thức hữu ích này đến cộng đồng.',
                      buttonLabel: 'Đóng',
                    );
                  },
                  child: const Text('Gửi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final related = MockData.articlesByCategory(article.category)
        .where((a) => a.id != article.id)
        .take(2)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Bài viết')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      _categoryIcon(article.category),
                      size: 140,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _categoryLabel(article.category),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.schedule, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              '${article.readMinutes} ${S.readMin}',
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expert author box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryFixed,
                          child: Icon(Icons.verified_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ThS. BS. Nguyễn Mai Anh',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              SizedBox(height: 2),
                              Text('Chuyên gia Nhi khoa • Đã kiểm duyệt',
                                  style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    article.body,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (article.rating > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Text('Đánh giá của bạn: ',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          ...List.generate(
                            article.rating,
                            (_) => const Icon(Icons.star_rounded, size: 18, color: AppColors.tertiaryFixedDim),
                          ),
                        ],
                      ),
                    ),

                  // 3-button action bar
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.star_border_rounded,
                          label: 'Đánh giá',
                          onTap: _showRatingDialog,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: article.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          label: 'Lưu',
                          filled: article.isSaved,
                          onTap: _toggleSave,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.share_rounded,
                          label: 'Chia sẻ',
                          onTap: _shareArticle,
                        ),
                      ),
                    ],
                  ),

                  if (related.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Bài viết liên quan',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...related.map((r) => _RelatedCard(article: r)),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'mental':
        return Icons.favorite_rounded;
      case 'physical':
        return Icons.fitness_center_rounded;
      case 'skills':
        return Icons.menu_book_rounded;
      case 'alerts':
        return Icons.notifications_active_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'mental':
        return S.catMental;
      case 'physical':
        return S.catPhysical;
      case 'skills':
        return S.catSkills;
      case 'alerts':
        return S.catAlerts;
      default:
        return cat;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: filled ? Colors.white : AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedCard extends StatelessWidget {
  final Article article;
  const _RelatedCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.article_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
