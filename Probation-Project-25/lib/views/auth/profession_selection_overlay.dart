import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mind_ease_app/controller/auth_controller.dart';

class ProfessionSelectionOverlay extends StatefulWidget {
  const ProfessionSelectionOverlay({Key? key}) : super(key: key);

  @override
  State<ProfessionSelectionOverlay> createState() =>
      _ProfessionSelectionOverlayState();
}

class _ProfessionSelectionOverlayState
    extends State<ProfessionSelectionOverlay> {
  Future<void> _saveProfession(String profession) async {
    final authController = AuthController();

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await authController.saveProfession(context, profession);

    if (!mounted) return;
    Navigator.pop(context); // close loader

    // Navigate to home after saving
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Blurred background only — no black overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),

        // ✅ Foreground content
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 👨‍⚕️ Doctor image
                    Image.asset(
                      'assets/images/doctor.jpeg',
                      height: screenWidth * 0.38, // slightly smaller
                      fit: BoxFit.contain,
                    ),

                    // ☁️ Cloud bubble
                    Transform.translate(
                      offset: const Offset(-25, -15),
                      child: Container(
                        width: screenWidth * 0.6, // smaller width
                        height: screenWidth * 0.32, // smaller height
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/cloud.jpeg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 28,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Tell us your profession\nso we can help you better.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // ✅ Button Row (smaller + balanced)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      minimumSize:
                                          const Size(70, 26), // smaller buttons
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _saveProfession('Student'),
                                    child: const Text(
                                      "Student",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      minimumSize: const Size(95, 26),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => _saveProfession(
                                        'Working Professional'),
                                    child: const Text(
                                      "Professional",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
