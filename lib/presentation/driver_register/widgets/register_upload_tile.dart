import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RegisterUploadTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const RegisterUploadTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 22.sp),
            SizedBox(width: 3.w),
            Text(label),
          ],
        ),
      ),
    );
  }
}