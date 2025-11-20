import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'widgets/profile_header_widget.dart';
import 'widgets/profile_option_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Миний профиль"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeaderWidget(),

            SizedBox(height: 4.h),

            Text(
              "Тохиргоо",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            ProfileOptionTile(
              icon: Icons.edit,
              title: "Мэдээлэл засах",
              onTap: () {
                // TODO: open edit profile
              },
            ),

            ProfileOptionTile(
              icon: Icons.directions_car_outlined,
              title: "Машины мэдээлэл",
              onTap: () {
                // TODO: car info page
              },
            ),

            ProfileOptionTile(
              icon: Icons.lock_outline,
              title: "Нууц үг солих",
              onTap: () {
                // TODO: change password
              },
            ),

            ProfileOptionTile(
              icon: Icons.history,
              title: "Миний аялалууд",
              onTap: () {
                // TODO: travel history
              },
            ),

            ProfileOptionTile(
              icon: Icons.payment_rounded,
              title: "Төлбөр & Дансууд",
              onTap: () {
                // TODO: payments page
              },
            ),

            SizedBox(height: 4.h),

            Text(
              "Бусад",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            ProfileOptionTile(
              icon: Icons.help_outline,
              title: "Тусламж",
              onTap: () {},
            ),

            ProfileOptionTile(
              icon: Icons.info_outline,
              title: "Аппын мэдээлэл",
              onTap: () {},
            ),

            ProfileOptionTile(
              icon: Icons.logout,
              title: "Гарах",
              isDestructive: true,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/driver-login',
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}