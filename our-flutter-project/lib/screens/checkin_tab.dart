import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme.dart';
import '../models/models.dart';

class CheckinTab extends StatefulWidget {
  final ChildProfile child;

  const CheckinTab({super.key, required this.child});

  @override
  State<CheckinTab> createState() => _CheckinTabState();
}

class _CheckinTabState extends State<CheckinTab> {
  final Set<String> _selectedEmotions = {};
  String? _selectedBodyStatus;
  final Set<String> _selectedSymptoms = {};
  final _notesController = TextEditingController();
  bool _saved = false;

  List<_EmoItem> get _emotions => [
        _EmoItem('😄', S.emotionHappy),
        _EmoItem('🙂', S.emotionNormal),
        _EmoItem('😕', S.emotionTired),
        _EmoItem('😢', S.emotionSad),
        _EmoItem('😡', S.emotionAngry),
        _EmoItem('😰', S.emotionWorried),
        _EmoItem('😴', S.emotionSluggish),
        _EmoItem('❓', S.emotionOther),
      ];

  List<_BodyItem> get _bodyOptions => widget.child.isFemale
      ? [
          _BodyItem(Icons.water_drop, S.bodyInPeriod),
          _BodyItem(Icons.opacity, S.bodyDischarge),
          _BodyItem(Icons.check_circle_outline, S.bodyNotInPeriod),
          _BodyItem(Icons.trending_up, S.bodyPuberty),
        ]
      : [
          _BodyItem(Icons.nights_stay, S.bodyNocturnal),
          _BodyItem(Icons.flash_on, S.bodyTension),
          _BodyItem(Icons.check_circle_outline, S.bodyNone),
          _BodyItem(Icons.trending_up, S.bodyPuberty),
        ];

  List<_SymItem> get _symptoms => [
        _SymItem(Icons.fitness_center, S.symptomHealthy),
        _SymItem(Icons.battery_alert, S.symptomTired),
        _SymItem(Icons.psychology, S.symptomHeadache),
        _SymItem(Icons.sick, S.symptomStomach),
        _SymItem(Icons.accessibility_new, S.symptomBack),
        _SymItem(Icons.emoji_nature, S.symptomNausea),
        _SymItem(Icons.rotate_left, S.symptomDizzy),
        _SymItem(Icons.face, S.symptomAcne),
        _SymItem(Icons.sentiment_dissatisfied, S.symptomIrritable),
        _SymItem(Icons.more_horiz, S.symptomOther),
      ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(S.saved),
        backgroundColor: AppColors.checkedIn,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotions
          _SectionTitle(S.emotionTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _emotions.map((e) {
              final selected = _selectedEmotions.contains(e.label);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedEmotions.remove(e.label)
                      : _selectedEmotions.add(e.label);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.pending,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(e.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Body status
          _SectionTitle(S.bodyTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _bodyOptions.map((b) {
              final selected = _selectedBodyStatus == b.label;
              return GestureDetector(
                onTap: () => setState(() => _selectedBodyStatus = b.label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          selected ? AppColors.secondary : AppColors.pending,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(b.icon,
                          size: 20,
                          color: selected
                              ? AppColors.secondary
                              : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        b.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Symptoms
          _SectionTitle(S.symptomsTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _symptoms.map((s) {
              final selected = _selectedSymptoms.contains(s.label);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedSymptoms.remove(s.label)
                      : _selectedSymptoms.add(s.label);
                }),
                child: Chip(
                  avatar: Icon(s.icon,
                      size: 18,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondary),
                  label: Text(s.label),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  backgroundColor: selected
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          selected ? AppColors.accent : AppColors.pending,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Notes
          _SectionTitle(S.notesTitle),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: S.notesHint,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pending),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pending),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saved ? null : _save,
              icon: Icon(_saved ? Icons.check : Icons.save),
              label: Text(_saved ? S.saved : S.save),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _EmoItem {
  final String emoji;
  final String label;
  _EmoItem(this.emoji, this.label);
}

class _BodyItem {
  final IconData icon;
  final String label;
  _BodyItem(this.icon, this.label);
}

class _SymItem {
  final IconData icon;
  final String label;
  _SymItem(this.icon, this.label);
}
