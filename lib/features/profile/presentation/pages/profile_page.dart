import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/domain/entities/user.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../widgets/custom_profile_info_tile.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = 'profile_screen';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            context.read<AuthBloc>().add(UpdateUserData(state.user));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is ProfileError) {
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
        },

        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! Authenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = authState.user;
            return _buildProfileContent(context, user);
          },
        ),
      ),
    );
  }

  /// Returns "X years" calculated from an ISO date string, or null if unparseable.
  String? _calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return null;
    try {
      final dob = DateTime.parse(birthDate);
      final today = DateTime.now();

      int years = today.year - dob.year;
      int months = today.month - dob.month;
      int days = today.day - dob.day;

      // Fix days first: borrow from previous month
      if (days < 0) {
        months--;
        // Last day of the previous month relative to today
        final lastDayOfPrevMonth =
            DateTime(today.year, today.month, 0).day;
        days += lastDayOfPrevMonth;
      }
      // Fix months: borrow from years
      if (months < 0) {
        years--;
        months += 12;
      }

      // Build readable string
      final parts = <String>[];
      if (years > 0) parts.add('$years year${years > 1 ? 's' : ''}');
      if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
      if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
      if (parts.isEmpty) parts.add('0 days');
      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    
    Widget _buildNetworkAvatar(String? imageUrl, {double radius = 60}) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFF00B4D8),
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: radius,
              color: Colors.grey[400],
            );
          },
        ),
      ),
    );
  }
  // مفيش صورة خالص → icon بدل asset
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey[200],
    child: Icon(Icons.person, size: radius, color: Colors.grey[400]),
  );
}
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 20),

_buildNetworkAvatar(user.imageUrl, radius: 60),
      
        /* CircleAvatar(
          radius: 60,
          backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
              ? NetworkImage(user.imageUrl!)
              : const AssetImage(AppAssets.profile_1) as ImageProvider,
          onBackgroundImageError: (_, __) {},
        ), */
        const SizedBox(height: 15),

        Text(
          user.fullName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(user.emailAddress, style: const TextStyle(color: Colors.grey)),

        const SizedBox(height: 10),

        ProfileInfoTile(
          icon: Icons.person_outline,
          label: "Full Name",
          value: user.fullName,
        ),

        ProfileInfoTile(
          icon: Icons.email_outlined,
          label: "Email",
          value: user.emailAddress,
        ),

        ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: "Phone",
          value: user.phoneNumber?.isNotEmpty == true
              ? user.phoneNumber!
              : "Not set",
        ),

        ProfileInfoTile(
          icon: Icons.cake_outlined,
          label: "Birth Date",
          value: user.birthDate?.isNotEmpty == true
              ? user.birthDate!
              : "Not set",
        ),

        ProfileInfoTile(
          icon: Icons.hourglass_bottom,
          label: "Age",
          value: _calculateAge(user.birthDate) ??
              (user.age != null ? '${user.age} years' : "Not set"),
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: EditProfilePage(user: user),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B4D8),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
