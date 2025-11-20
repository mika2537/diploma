import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/register_textfield_widget.dart';
import 'widgets/register_upload_tile.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _fullName = TextEditingController();
  final _vehicleMake = TextEditingController();
  final _vehicleModel = TextEditingController();
  final _vehicleYear = TextEditingController();
  final _licensePlate = TextEditingController();
  final _licenseNumber = TextEditingController();
  final _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Become a Driver"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegisterTextFieldWidget(
              label: "Full Name",
              controller: _fullName,
              hint: "Enter your fullname",
            ),

            RegisterTextFieldWidget(
              label: "Vehicle Make",
              controller: _vehicleMake,
              hint: "e.g., Toyota",
            ),

            RegisterTextFieldWidget(
              label: "Vehicle Model",
              controller: _vehicleModel,
              hint: "e.g., Camry",
            ),

            RegisterTextFieldWidget(
              label: "Vehicle Year",
              controller: _vehicleYear,
              hint: "e.g., 2020",
              keyboard: TextInputType.number,
            ),

            RegisterTextFieldWidget(
              label: "License Plate",
              controller: _licensePlate,
              hint: "e.g., ABC123",
            ),

            RegisterTextFieldWidget(
              label: "License Number",
              controller: _licenseNumber,
              hint: "Enter your license number",
            ),

            RegisterUploadTile(
              icon: Icons.image,
              label: "Upload License Image",
              onTap: () {},
            ),

            RegisterUploadTile(
              icon: Icons.image,
              label: "Upload Profile Picture",
              onTap: () {},
            ),

            RegisterTextFieldWidget(
              label: "Phone Number",
              controller: _phoneNumber,
              hint: "Enter your phone number",
              keyboard: TextInputType.phone,
            ),

            SizedBox(height: 3.h),

            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/driver-dashboard',
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Submit Application",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}