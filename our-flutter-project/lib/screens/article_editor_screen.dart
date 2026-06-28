import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';
import '../shared/app_modals.dart';

/// Article authoring form (design 5.10) with submit-success modal (5.11).
class ArticleEditorScreen extends StatefulWidget {
  const ArticleEditorScreen({super.key});

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ContentSection {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  void dispose() {
    title.dispose();
    content.dispose();
  }
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  static const _maxSections = 10;
  static const _maxTags = 10;

  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _conclusionController = TextEditingController();
  final _tagController = TextEditingController();

  final List<_ContentSection> _sections = [_ContentSection()];
  final List<String> _tags = [];
  String _category = 'mental';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _conclusionController.dispose();
    _tagController.dispose();
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty;

  void _addSection() {
    if (_sections.length >= _maxSections) return;
    setState(() => _sections.add(_ContentSection()));
  }

  void _removeSection(int i) {
    setState(() {
      _sections[i].dispose();
      _sections.removeAt(i);
    });
  }

  void _addTag() {
    final t = _tagController.text.trim().replaceAll('#', '');
    if (t.isEmpty || _tags.length >= _maxTags || _tags.contains(t)) return;
    setState(() {
      _tags.add(t);
      _tagController.clear();
    });
  }

  void _submit() {
    final readMinutes = (_sections.fold<int>(0, (sum, s) => sum + s.content.text.length) ~/ 600).clamp(1, 30);
    MockData.articles.insert(
      0,
      Article(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        excerpt: _summaryController.text.trim().isEmpty
            ? _titleController.text.trim()
            : _summaryController.text.trim(),
        body: [
          for (final s in _sections)
            if (s.title.text.trim().isNotEmpty || s.content.text.trim().isNotEmpty)
              '${s.title.text.trim()}\n${s.content.text.trim()}',
          if (_conclusionController.text.trim().isNotEmpty) _conclusionController.text.trim(),
        ].join('\n\n'),
        category: _category,
        readMinutes: readMinutes,
      ),
    );

    showSuccessModal(
      context,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.secondaryContainer,
      title: 'Gửi bài thành công',
      message: 'Bài viết đã được gửi để hệ thống kiểm duyệt theo quy định. '
          'Chúng tôi sẽ thông báo khi bài viết được phê duyệt.',
      buttonLabel: 'Đã hiểu',
      onClose: () => Navigator.of(context).pop(true),
    );
  }

  void _preview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _titleController.text.trim().isEmpty ? '(Chưa có tiêu đề)' : _titleController.text.trim(),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              if (_summaryController.text.trim().isNotEmpty) ...[
                Text(
                  _summaryController.text.trim(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppColors.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              for (final s in _sections)
                if (s.title.text.trim().isNotEmpty || s.content.text.trim().isNotEmpty) ...[
                  if (s.title.text.trim().isNotEmpty)
                    Text(
                      s.title.text.trim(),
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    s.content.text.trim(),
                    style: const TextStyle(fontSize: 15, height: 1.7),
                  ),
                  const SizedBox(height: 18),
                ],
              if (_conclusionController.text.trim().isNotEmpty)
                Text(
                  _conclusionController.text.trim(),
                  style: const TextStyle(fontSize: 15, height: 1.7),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tạo bài viết'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _label('Tiêu đề'),
          _counterField(_titleController, 'Nhập tiêu đề bài viết', 100, maxLines: 2),
          const SizedBox(height: 20),

          _label('Ảnh bìa'),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DottedContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_photo_alternate_outlined, size: 36, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text('Thêm ảnh bìa (16:9)',
                      style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _label('Tóm tắt'),
          _counterField(_summaryController, 'Mô tả ngắn gọn nội dung bài viết', 500, maxLines: 3),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label('Nội dung'),
              Text('${_sections.length}/$_maxSections phần',
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < _sections.length; i++) _sectionCard(i),
          if (_sections.length < _maxSections)
            DottedContainer(
              onTap: _addSection,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Thêm phần nội dung',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          const SizedBox(height: 24),

          _label('Kết luận'),
          _counterField(_conclusionController, 'Tóm lược, lời khuyên cuối bài', 500, maxLines: 3),
          const SizedBox(height: 24),

          _label('Thư mục'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: const [
              DropdownMenuItem(value: 'mental', child: Text('Nuôi dưỡng tinh thần')),
              DropdownMenuItem(value: 'physical', child: Text('Phát triển thể chất')),
              DropdownMenuItem(value: 'skills', child: Text('Bồi đắp kỹ năng')),
              DropdownMenuItem(value: 'alerts', child: Text('Sự kiện cảnh báo')),
            ],
            onChanged: (v) => setState(() => _category = v ?? 'mental'),
            decoration: _decoration(null),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label('Hashtag'),
              Text('${_tags.length}/$_maxTags',
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tagController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addTag(),
            decoration: _decoration('Nhập hashtag và nhấn +').copyWith(
              prefixIcon: const Icon(Icons.tag_rounded, color: AppColors.primary, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: _addTag,
              ),
            ),
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags
                  .map((t) => Chip(
                        label: Text('#$t'),
                        onDeleted: () => setState(() => _tags.remove(t)),
                        backgroundColor: AppColors.secondaryContainer,
                        labelStyle: const TextStyle(fontSize: 12, color: AppColors.primary),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _preview,
                  child: const Text('Xem trước'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isValid ? _submit : null,
                  child: const Text('Gửi bài viết'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Phần ${(i + 1).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const Spacer(),
              if (_sections.length > 1)
                GestureDetector(
                  onTap: () => _removeSection(i),
                  child: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _counterField(_sections[i].title, 'Tiêu đề phần', 100),
          const SizedBox(height: 10),
          _counterField(_sections[i].content, 'Nội dung phần', 1000, maxLines: 4),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
      );

  Widget _counterField(TextEditingController c, String hint, int max, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLength: max,
      maxLines: maxLines,
      decoration: _decoration(hint).copyWith(counterText: ''),
      onChanged: (_) => setState(() {}),
    );
  }

  InputDecoration _decoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surfaceContainerHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

/// Dashed-border container used for upload zones and "add" actions.
class DottedContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  const DottedContainer({super.key, required this.child, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: padding,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );
    final path = Path()..addRRect(rrect);
    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        canvas.drawPath(metric.extractPath(dist, dist + dash), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
