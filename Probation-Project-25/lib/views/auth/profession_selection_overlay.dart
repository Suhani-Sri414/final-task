import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionSelectionOverlay extends StatefulWidget {
  const ProfessionSelectionOverlay({Key? key}) : super(key: key);

  @override
  State<ProfessionSelectionOverlay> createState() =>
      _ProfessionSelectionOverlayState();
}

class _ProfessionSelectionOverlayState
    extends State<ProfessionSelectionOverlay> {
  Future<void> _saveProfession(String profession) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profession', profession);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // allow home bg to stay visible
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Blur the existing background (home page remains visible)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // ✅ Foreground content
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 👨‍⚕️ Doctor image
                Image.asset(
                  'assets/images/doctor.jpeg',
                  width: 180,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 20),

                // ☁️ Cloud image container (profession selection)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cloud background
                    Image.asset(
                      'assets/images/cloud.jpeg', // your cloud image
                      width: 250,
                      height: 220,
                      fit: BoxFit.contain,
                    ),

                    // Selection buttons on top of cloud
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Select Your Profession",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _saveProfession('Student'),
                          child: const Text("🎓 I'm a Student"),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () =>
                              _saveProfession('Working Professional'),
                          child: const Text("💼 I'm a Working Professional"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
