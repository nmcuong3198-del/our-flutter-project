import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Reusable branded modal card matching the "Gentle Guardian" design system:
/// optional gradient top bar, icon circle, title, message, primary button,
/// optional secondary text link, and optional footer tag.
class BrandedModalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String? message;
  final Widget? messageWidget;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? footer;
  final bool showTopGradient;
  final Widget? headerImage;

  const BrandedModalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.primaryLabel,
    required this.onPrimary,
    this.iconColor = AppColors.primary,
    this.iconBgColor = AppColors.secondaryContainer,
    this.message,
    this.messageWidget,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
    this.showTopGradient = true,
    this.headerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLowest,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerImage != null)
            headerImage!
          else if (showTopGradient)
            Container(
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryContainer,
                    AppColors.secondaryContainer,
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 38),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                if (messageWidget != null)
                  messageWidget!
                else if (message != null)
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.55,
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPrimary,
                    child: Text(primaryLabel),
                  ),
                ),
                if (secondaryLabel != null) ...[
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(
                      secondaryLabel!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
                if (footer != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    footer!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a branded success modal. Returns when dismissed.
Future<void> showSuccessModal(
  BuildContext context, {
  required String title,
  required String message,
  IconData icon = Icons.check_circle_rounded,
  Color iconColor = AppColors.success,
  Color iconBgColor = const Color(0xFFD7F2DD),
  String buttonLabel = 'Đã hiểu',
  String? footer,
  VoidCallback? onClose,
}) {
  return showDialog(
    context: context,
    barrierColor: AppColors.primary.withValues(alpha: 0.2),
    builder: (ctx) => BrandedModalCard(
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
      title: title,
      message: message,
      footer: footer,
      primaryLabel: buttonLabel,
      onPrimary: () {
        Navigator.of(ctx).pop();
        onClose?.call();
      },
    ),
  );
}
