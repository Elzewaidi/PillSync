import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:pillsync/utils/app_colors.dart';
import 'package:pillsync/utils/app_styles.dart';
import 'package:pillsync/utils/app_assets.dart';
import 'package:pillsync/injection_container.dart';
import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/features/auth/data/models/user_model.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pillsync/features/auth/presentation/bloc/auth_event.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _imagePath;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    dobCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final localDataSource = sl<AuthLocalDataSource>();
      final user = await localDataSource.getCachedUser();
      if (user != null) {
        _user = user;
        nameCtrl.text = user.fullName;
        emailCtrl.text = user.emailAddress;
        phoneCtrl.text = user.phoneNumber ?? "";
        dobCtrl.text = user.birthDate ?? "";
        ageCtrl.text = user.age?.toString() ?? "";
        _imagePath = user.imageUrl;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
      );
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_pic_${DateTime.now().millisecondsSinceEpoch}.png';
        final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
        if (mounted) {
          setState(() {
            _imagePath = savedImage.path;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to pick image: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dobCtrl.text.isNotEmpty
          ? (DateTime.tryParse(dobCtrl.text) ?? DateTime.now().subtract(const Duration(days: 365 * 22)))
          : DateTime.now().subtract(const Duration(days: 365 * 22)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
        final now = DateTime.now();
        int age = now.year - picked.year;
        if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
          age--;
        }
        ageCtrl.text = age.toString();
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_user != null) {
      final localDataSource = sl<AuthLocalDataSource>();
      final updatedUser = _user!.copyWith(
        fullName: nameCtrl.text.trim(),
        emailAddress: emailCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        birthDate: dobCtrl.text.trim(),
        age: int.tryParse(ageCtrl.text.trim()),
        imageUrl: _imagePath,
      );

      await localDataSource.updateCachedUser(updatedUser);

      // Update the AuthBloc so HomeScreen header reflects changes immediately
      if (mounted) {
        context.read<AuthBloc>().add(UpdateUserData(updatedUser));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully!"),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
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
        title: Text(
          "Edit Profile",
          style: AppStyles.font18SemiBoldBlack,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _getProfileImage(_imagePath),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: AppColors.white),
                          onPressed: () => _showImageSourceActionSheet(context),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showImageSourceActionSheet(context),
                    child: const Text(
                      "Change Photo",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditField("Full Name", nameCtrl),
                  _buildEditField("Email Address", emailCtrl),
                  _buildEditField("Phone Number", phoneCtrl),
                  _buildEditField(
                    "Date of Birth",
                    dobCtrl,
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  _buildEditField(
                    "Age",
                    ageCtrl,
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 55),
                            side: const BorderSide(color: AppColors.grey300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(0, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              suffixIcon: icon != null ? Icon(icon, color: AppColors.textHint, size: 20) : null,
              filled: true,
              fillColor: readOnly ? AppColors.grey100 : AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.grey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
