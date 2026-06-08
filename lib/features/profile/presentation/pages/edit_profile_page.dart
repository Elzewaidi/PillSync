import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../features/auth/domain/entities/user.dart';
import '../../../../utils/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/custom_profile_form_field.dart';

class EditProfilePage extends StatefulWidget {
  final User user; 

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthDateController;

  DateTime? _selectedBirthDate;
  File? _selectedImageFile;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.emailAddress);
    _phoneController = TextEditingController(
      text: widget.user.phoneNumber ?? '',
    );
    _birthDateController = TextEditingController(
      text: widget.user.birthDate ?? '',
    );

    if (widget.user.birthDate != null && widget.user.birthDate!.isNotEmpty) {
      try {
        _selectedBirthDate = DateTime.parse(widget.user.birthDate!);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }


  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);

    setState(() {
      _selectedImageFile = imageFile;
      _uploadedImageUrl = null;
    });


    context.read<ProfileBloc>().add(
      UploadProfileImageRequested(imageFile: imageFile),
    );
  }

  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.darkBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onSavePressed() {
    if (_isUploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait, image is still uploading...'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
        UpdateProfileRequested(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          birthDate: _birthDateController.text.isEmpty
              ? null
              : _birthDateController.text,
          imageUrl: _uploadedImageUrl,
          currentUser: widget.user,
        ),
      );
    }
  }

  Widget _buildProfileAvatar() {
  return Stack(
    alignment: Alignment.center,
    children: [
      // الصورة المختارة من الجهاز
      if (_selectedImageFile != null)
        CircleAvatar(
          radius: 55,
          backgroundImage: FileImage(_selectedImageFile!),
        )
      // صورة من imgbb (network)
      else if (widget.user.imageUrl != null && widget.user.imageUrl!.isNotEmpty)
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: Image.network(
              widget.user.imageUrl!,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00B4D8),
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 55,
                  color: Colors.grey[400],
                );
              },
            ),
          ),
        )
      // مفيش صورة خالص
      else
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.person, size: 55, color: Colors.grey[400]),
        ),

      // overlay أثناء الرفع
      if (_isUploadingImage)
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Uploading...',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ),

      // ✅ علامة النجاح
      if (_uploadedImageUrl != null && !_isUploadingImage)
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
        ),

      // زرار الكاميرا
      Positioned(
        bottom: 0,
        right: _uploadedImageUrl != null ? 20 : 0,
        child: GestureDetector(
          onTap: _isUploadingImage ? null : _pickImage,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
          ),
        ),
      ),
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileImageUploading) {
            setState(() {
              _isUploadingImage = true;
              _uploadedImageUrl = null;
            });
          }

          if (state is ProfileImageUploaded) {
            setState(() {
              _isUploadingImage = false;
              _uploadedImageUrl = state.imageUrl;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(' Image uploaded successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is ProfileError) {
            setState(() => _isUploadingImage = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }

          if (state is ProfileUpdated) {
        
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isSaving = state is ProfileLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  _buildProfileAvatar(),
                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed: _isUploadingImage ? null : _pickImage,
                    icon: Icon(
                      Icons.photo_library_outlined,
                      color: _isUploadingImage
                          ? Colors.grey
                          : AppColors.darkBlue,
                      size: 18,
                    ),
                    label: Text(
                      'Change Photo',
                      style: TextStyle(
                        color: _isUploadingImage
                            ? Colors.grey
                            : AppColors.darkBlue,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ProfileFormField(
                    label: "Full Name",
                    controller: _nameController,
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  ProfileFormField(
                    label: "Email Address",
                    controller: _emailController,
                    icon: Icons.email,
                    readOnly: true,
                    enabled: false,
                  ),

                  ProfileFormField(
                    label: "Phone Number",
                    controller: _phoneController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    hint: "+20 1XX XXX XXXX",
                  ),

                  ProfileFormField(
                    label: "Date of Birth",
                    controller: _birthDateController,
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: _pickBirthDate,
                    hint: "Select your birth date",
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: (isSaving || _isUploadingImage)
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: BorderSide(color: Colors.grey[400]!),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (isSaving || _isUploadingImage)
                              ? null
                              : _onSavePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlue,
                            minimumSize: const Size(0, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
