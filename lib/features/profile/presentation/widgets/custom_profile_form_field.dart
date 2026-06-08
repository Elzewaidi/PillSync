import 'package:flutter/material.dart';
import 'package:pillsync/utils/app_colors.dart';


class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? hint;
  final String? Function(String?)? validator;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.keyboardType,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          style: enabled
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled ? AppColors.darkBlue : Colors.grey,
            ),
            suffixIcon: readOnly && onTap != null
                ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
                : null,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBlue, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
