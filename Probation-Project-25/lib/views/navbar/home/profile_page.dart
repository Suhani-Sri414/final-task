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
  String profession = "";

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
    final prefs = await SharedPreferences.getInstance();
    final auth = AuthController();
    final userData = await auth.getUserDetails();

    setState(() {
      name = userData['name'] ?? prefs.getString('user_name') ?? "User";
      email = userData['email'] ?? prefs.getString('user_email') ?? "example@gmail.com";
      phone = prefs.getString('phone') ?? "";
      gender = prefs.getString('gender') ?? "";
      age = prefs.getString('age') ?? "";
      profession = userData['profession'] ?? "";
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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.05),

            Text(
              "My Profile",
              style: TextStyle(
                fontSize: 22 * t,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: h * 0.02),

            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18 * t,
                          ),
                        ),
                        Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14 * t,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03,
                        vertical: h * 0.01,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.03),

            Container(
              padding: EdgeInsets.all(w * 0.04),
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
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * t,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: h * 0.01,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  _buildInfoRow("Name", name, null),
                  _buildInfoRow("Email", email, null),
                  _buildInfoRow("Phone No", phone, phoneController, editable: true),
                  _buildInfoRow("Gender", gender, genderController, editable: true),
                  _buildInfoRow("Age", age, ageController, editable: true),
                  _buildInfoRow("Profession", profession, null),
                ],
              ),
            ),

            SizedBox(height: h * 0.03),

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
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05,
                    vertical: h * 0.015,
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
    bool editable = false,
  }) {
    final t = MediaQuery.of(context).textScaleFactor;
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.015),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14 * t,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: (isEditing && editable)
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.02,
                        vertical: w * 0.02,
                      ),
                    ),
                  )
                : Text(
                    value.isNotEmpty ? value : "-",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * t,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
