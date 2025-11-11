import 'package:flutter/material.dart';
import 'package:mind_ease_app/controller/auth_controller.dart';
import 'package:mind_ease_app/controller/profile_controller.dart';
import 'package:mind_ease_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String phone = "";
  String gender = "";
  String age = "";

  bool isEditing = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  
  Future<void> _loadUserData() async {
    final auth = AuthController();
    final userData = await auth.getUserDetails();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = userData['name'] ?? "User";
      email = userData['email'] ?? "example@gmail.com";
      phone = prefs.getString('phone') ?? "";
      gender = prefs.getString('gender') ?? "";
      age = prefs.getString('age') ?? "";
    });

    phoneController.text = phone;
    genderController.text = gender;
    ageController.text = age;
  }

  Future<void> _saveProfile() async {
  final auth = AuthController();
  final userData = await auth.getUserDetails();

  final user = UserModel(
    name: userData['name'] ?? '',
    email: userData['email'] ?? '',
    token: userData['token'],
  );

  final profileController = ProfileController();

  bool success = await profileController.updateProfile(
    user: user,
    phone: phoneController.text,
    gender: genderController.text,
    age: ageController.text,
  );

  if (success) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('gender', genderController.text);
    await prefs.setString('age', ageController.text);

    setState(() {
      phone = phoneController.text;
      gender = genderController.text;
      age = ageController.text;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update profile')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8F9),borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    icon: Icon(isEditing ? Icons.close : Icons.edit, size: 16),
                    label: Text(isEditing ? "Cancel" : "Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (isEditing)
                        ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow("Name", name, null, isEditable: false),
                  _buildInfoRow("Email", email, null, isEditable: false),
                  _buildInfoRow("Phone No", phone, phoneController),
                  _buildInfoRow("Gender", gender, genderController),
                  _buildInfoRow("Age", age, ageController),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthController().logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String value,
    TextEditingController? controller, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: isEditing && isEditable
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                  )
                : Text(
                    value.isNotEmpty ? value : "-",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
