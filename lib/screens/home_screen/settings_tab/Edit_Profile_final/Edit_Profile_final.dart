import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameCtrl = TextEditingController(text: "John Doe");
  final emailCtrl = TextEditingController(text: "john.doe@example.com");

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150",
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            TextButton(onPressed: () {}, child: const Text("Change Photo")),
            const SizedBox(height: 20),
            _buildEditField("Full Name", nameCtrl),
            _buildEditField("Email Address", emailCtrl),
            _buildEditField(
              "Phone Number",
              TextEditingController(text: "+1 234 567 890"),
            ),
            _buildEditField(
              "Date of Birth",
              TextEditingController(text: "15 / 08 / 1990"),
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text("Change Password"),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(0, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController ctrl, {
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFECEFF1)),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
