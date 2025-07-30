import 'package:flutter/material.dart';
import '../../../core/constant/app_constant.dart';


class StatusChip extends StatelessWidget {
  final String status;
  final bool isAnimated;

  const StatusChip({
    Key? key,
    required this.status,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.getStatusColor(status);
    
    Widget chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (isAnimated) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: chip,
      );
    }

    return chip;
  }
}