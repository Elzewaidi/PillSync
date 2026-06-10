import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/injection_container.dart';
import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/features/auth/data/models/user_model.dart';
import 'package:pillsync/screens/home_screen/settings_tab/Edit_Profile_final/Edit_Profile_final.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final localDataSource = sl<AuthLocalDataSource>();
      final user = await localDataSource.getCachedUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ImageProvider _getProfileImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage(AppAssets.zewaidi);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return const AssetImage(AppAssets.zewaidi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text("Profile", style: AppStyles.font18SemiBoldBlack),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _getProfileImage(_user?.imageUrl),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _user?.fullName ?? "No Name",
                    style: AppStyles.font24BoldBlack,
                  ),
                  Text(
                    _user?.emailAddress ?? "No Email",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoTile(Icons.person_outline, "Full Name", _user?.fullName ?? "Not set"),
                  _buildInfoTile(Icons.email_outlined, "Email", _user?.emailAddress ?? "Not set"),
                  _buildInfoTile(Icons.phone_outlined, "Phone", _user?.phoneNumber ?? "Not set"),
                  _buildInfoTile(Icons.cake_outlined, "Age", _user?.age?.toString() ?? "Not set"),
                  _buildInfoTile(Icons.calendar_today_outlined, "Birth Date", _user?.birthDate ?? "Not set"),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.push(EditProfileScreen.routeName);
                        _loadUser(); // Refresh profile on return
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
