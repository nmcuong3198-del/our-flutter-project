import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

/// Height prediction feature: input form (design 4.8) and result view (4.9).
/// Uses the mid-parental (target height) method.
class HeightPredictionScreen extends StatefulWidget {
  final ChildProfile child;
  const HeightPredictionScreen({super.key, required this.child});

  @override
  State<HeightPredictionScreen> createState() => _HeightPredictionScreenState();
}

class _HeightPredictionScreenState extends State<HeightPredictionScreen> {
  final _currentController = TextEditingController();
  final _fatherController = TextEditingController();
  final _motherController = TextEditingController();

  double? _predicted; // null until computed

  @override
  void initState() {
    super.initState();
    final measurements = MockData.measurementsFor(widget.child.id);
    if (measurements.isNotEmpty) {
      _currentController.text = measurements.first.height.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _fatherController.dispose();
    _motherController.dispose();
    super.dispose();
  }

  double? _parse(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));

  bool get _isValid =>
      _parse(_fatherController) != null && _parse(_motherController) != null;

  void _predict() {
    final father = _parse(_fatherController)!;
    final mother = _parse(_motherController)!;
    // Mid-parental height (target height) formula.
    final double result = widget.child.isFemale
        ? (father + mother - 13) / 2
        : (father + mother + 13) / 2;
    setState(() => _predicted = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Dự báo chiều cao'),
      ),
      body: _predicted == null ? _buildInput() : _buildResult(),
    );
  }

  Widget _buildInput() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Text(
          'Ước tính chiều cao của ${widget.child.nickname} khi trưởng thành dựa trên '
          'chiều cao của bố mẹ.',
          style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        _NumberField(label: 'Chiều cao hiện tại của con', unit: 'cm', controller: _currentController),
        const SizedBox(height: 18),
        _NumberField(label: 'Chiều cao của bố', unit: 'cm', controller: _fatherController, onChanged: () => setState(() {})),
        const SizedBox(height: 18),
        _NumberField(label: 'Chiều cao của mẹ', unit: 'cm', controller: _motherController, onChanged: () => setState(() {})),
        const SizedBox(height: 24),
        _disclaimer(),
        const SizedBox(height: 28),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _isValid ? _predict : null,
            child: const Text('Dự báo'),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final predicted = _predicted!;
    final low = predicted - 8.5;
    final high = predicted + 8.5;
    final current = _parse(_currentController);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // Hero result card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              const Text(
                'Chiều cao dự báo khi trưởng thành',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                predicted.toStringAsFixed(0),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const Text('cm', style: TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Khoảng dao động: ${low.toStringAsFixed(0)} – ${high.toStringAsFixed(0)} cm',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Inputs summary
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              if (current != null)
                _summaryRow('Chiều cao hiện tại', '${current.toStringAsFixed(0)} cm'),
              _summaryRow('Chiều cao bố', '${_parse(_fatherController)!.toStringAsFixed(0)} cm'),
              _summaryRow('Chiều cao mẹ', '${_parse(_motherController)!.toStringAsFixed(0)} cm'),
              _summaryRow('Giới tính', widget.child.isFemale ? 'Nữ' : 'Nam', isLast: true),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _disclaimer(),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _predicted = null),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tính lại'),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13.5, color: AppColors.onSurfaceVariant)),
          Text(value,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kết quả chỉ mang tính tham khảo, dựa trên yếu tố di truyền. Chiều cao thực tế '
              'còn phụ thuộc vào dinh dưỡng, vận động và giấc ngủ.',
              style: TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const _NumberField({
    required this.label,
    required this.unit,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged?.call(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerHigh,
            suffixText: unit,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
