import 'package:flutter/material.dart';

class ModuleBanner extends StatelessWidget {
  final String label;
  final String title;
  final String? description;
  final String image;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Widget? trailing;

  const ModuleBanner({
    super.key,
    required this.label,
    required this.title,
    this.description,
    required this.image,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Color(0xBB081A2E), // High-fidelity dark gradient overlay matching web prototype
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B2035).withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top label in cyan/teal tracking
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Color(0xFF8CE0D0),
                  ),
                ),
                const SizedBox(height: 6),

                // Main headline
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),

                // Description
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD3E4F0),
                    ),
                  ),
                ],

                // Action button (White pill with navy text and icon)
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onAction,
                    icon: actionIcon != null
                        ? Icon(actionIcon, size: 15, color: const Color(0xFF0F324D))
                        : const SizedBox.shrink(),
                    label: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F324D),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F324D),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
