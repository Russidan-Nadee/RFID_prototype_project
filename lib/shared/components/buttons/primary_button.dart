import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final IconData? icon;
  final double width;
  final double height;
  final double borderRadius;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.icon,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('กำลังโหลด...'),
                  ],
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[Icon(icon), SizedBox(width: 8)],
                    Text(text),
                  ],
                ),
      ),
    );
  }
}
