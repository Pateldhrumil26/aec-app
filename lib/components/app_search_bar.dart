import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Reusable search bar matching the official AE Connect prototype:
/// - Outer container: White background, subtle border, rounded corners (r=8)
/// - Left icon: Official AE Connect blue (#036E97) magnifying glass
/// - Clean transparent text field with NO inner outline/borders
/// - Optional soft-blue action button (e.g. 3-dots sort / filter)
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? actionButton;
  final FocusNode? focusNode;
  final bool autofocus;
  final double height;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.value,
    this.controller,
    this.onChanged,
    this.onClear,
    this.actionButton,
    this.focusNode,
    this.autofocus = false,
    this.height = 46,
  });

  bool get _hasText {
    if (value != null && value!.isNotEmpty) return true;
    if (controller != null && controller!.text.isNotEmpty) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final searchInput = Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF036E97), // Official brand blue/teal
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.navy,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                if (controller != null) {
                  controller!.clear();
                }
                if (onClear != null) {
                  onClear!();
                } else if (onChanged != null) {
                  onChanged!('');
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
              ),
            ),
        ],
      ),
    );

    if (actionButton != null) {
      return Row(
        children: [
          Expanded(child: searchInput),
          const SizedBox(width: 10),
          actionButton!,
        ],
      );
    }

    return searchInput;
  }

  /// Helper to build the matching 3-dots or filter action button on the right
  static Widget buildActionButton({
    required Widget child,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFFE8F5FC),
    Color borderColor = const Color(0xFFD0E7F5),
    double size = 46,
  }) {
    final box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: box,
      );
    }
    return box;
  }
}
