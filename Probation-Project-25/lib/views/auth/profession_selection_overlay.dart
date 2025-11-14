import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await authController.saveProfession(context, profession);

    if (!mounted) return;
    Navigator.pop(context);

    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        /// Background blur
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),

        /// Center Overlay
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Doctor Image
                    Image.asset(
                      'assets/images/doctor.jpeg',
                      height: screenWidth * 0.38, // responsive
                      fit: BoxFit.contain,
                    ),

                    /// Cloud Text Box
                    Transform.translate(
                      offset: Offset(-25.w, -15.h),
                      child: Container(
                        width: (screenWidth * 0.6).w,
                        height: (screenWidth * 0.35).h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/cloud.jpeg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Tell us your profession\nso we can help you better.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10.h),

                              /// Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      minimumSize: Size(70.w, 26.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _saveProfession('Student'),
                                    child: Text(
                                      "Student",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 6.w),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      minimumSize: Size(95.w, 26.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () => _saveProfession(
                                        'Working Professional'),
                                    child: Text(
                                      "Professional",
                                      style: TextStyle(
                                        fontSize: 10.sp,
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
