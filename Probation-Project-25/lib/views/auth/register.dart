import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_ease_app/controller/auth_controller.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthController authController = AuthController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      body: Stack(
        children: [
          /// Logo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Image.asset(
                'assets/icons/mindeaselogo.png',
                height: 300.h,
                width: 300.w,
              ),
            ),
          ),

          /// Mind text
          Positioned(
            top: 320.h,
            left: 117.w,
            child: Text(
              'Mind',
              style: TextStyle(
                color: const Color.fromARGB(255, 31, 58, 95),
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Ease text
          Positioned(
            top: 320.h,
            left: 200.w,
            child: Text(
              'Ease',
              style: TextStyle(
                color: const Color.fromARGB(255, 33, 150, 84),
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Join Us
          Positioned(
            top: 380.h,
            left: 160.w,
            child: Text(
              'Join Us',
              style: TextStyle(
                color: const Color.fromARGB(255, 31, 58, 95),
                fontSize: 21.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Scrollable Register Form
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.47,
              left: 35.w,
              right: 35.w,
            ),
            child: Column(
              children: [
                Text(
                  'Create your account',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 58, 95),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),

                /// Form
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'name',
                        decoration: _inputDecoration('User', Icons.person),
                        validator: FormBuilderValidators.required(
                          errorText: 'Please enter your name',
                        ),
                      ),
                      SizedBox(height: 15.h),

                      FormBuilderTextField(
                        name: 'email',
                        decoration:
                            _inputDecoration('Email address', Icons.email),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Please enter your email',
                          ),
                          FormBuilderValidators.email(
                            errorText: 'Please enter a valid email',
                          ),
                          (value) {
                            if (value == null || value.isEmpty) return null;
                            if (!value.trim().endsWith('@gmail.com')) {
                              return 'Only Gmail addresses are allowed';
                            }
                            return null;
                          },
                        ]),
                      ),
                      SizedBox(height: 15.h),

                      FormBuilderTextField(
                        name: 'password',
                        obscureText: !_isPasswordVisible,
                        decoration: _inputDecoration(
                          'Password',
                          Icons.lock,
                          suffix: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 31, 58, 95),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Please enter a password',
                          ),
                          FormBuilderValidators.minLength(
                            6,
                            errorText: 'Password must be at least 6 characters',
                          ),
                          FormBuilderValidators.match(
                            RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).+$',
                            ),
                            errorText:
                                'Must include letters, numbers, and symbols',
                          ),
                        ]),
                      ),
                      SizedBox(height: 15.h),

                      FormBuilderTextField(
                        name: 'confirm_password',
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: _inputDecoration(
                          'Confirm Password',
                          Icons.lock_reset,
                          suffix: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 31, 58, 95),
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (val) {
                          final pw =
                              _formKey.currentState?.fields['password']?.value;
                          if (val == null || val.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (val != pw) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// Sign Up button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final data = _formKey.currentState!.value;
                      authController.signup(
                        context,
                        data['name'],
                        data['email'],
                        data['password'],
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                    padding: EdgeInsets.symmetric(
                      horizontal: 130.w,
                      vertical: 13.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                /// Login text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'login'),
                      child: Text(
                        "Login here",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 33, 150, 84),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon:
          Icon(icon, color: const Color.fromARGB(255, 31, 58, 95), size: 22.sp),
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
