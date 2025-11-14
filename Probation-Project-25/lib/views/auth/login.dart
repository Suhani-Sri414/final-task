import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_ease_app/controller/auth_controller.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthController authController = AuthController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              /// ---------- LOGO ---------- ///
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Image.asset(
                    'assets/icons/mindeaselogo.png',
                    height: 300.h,
                    width: 300.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// ---------- MIND ---------- ///
              Positioned(
                top: 320.h,
                left: 115.w,
                child: Text(
                  'Mind',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 58, 95),
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// ---------- EASE ---------- ///
              Positioned(
                top: 320.h,
                left: 198.w,
                child: Text(
                  'Ease',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 33, 150, 84),
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// ---------- WELCOME TEXT ---------- ///
              Positioned(
                top: 380.h,
                left: 120.w,
                child: Text(
                  'Welcome back !',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 58, 95),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Positioned(
                top: 405.h,
                left: 100.w,
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 58, 95),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Positioned(
                top: 445.h,
                left: 115.w,
                child: Text(
                  'Its nice to see you again',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 31, 58, 95),
                    fontSize: 16.sp,
                  ),
                ),
              ),

              /// ---------- FORM ---------- ///
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.58,
                  left: 35.w,
                  right: 35.w,
                ),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// ------------ Email ------------ ///
                      FormBuilderTextField(
                        name: 'email',
                        decoration: _inputDecoration(
                          'Email address',
                          Icons.email,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Please enter your email',
                          ),
                          FormBuilderValidators.email(
                            errorText: 'Please enter a valid email',
                          ),
                          (value) {
                            if (value == null || value.isEmpty) return null;
                            if (!value.toLowerCase().endsWith('@gmail.com')) {
                              return 'Email must end with @gmail.com';
                            }
                            return null;
                          },
                        ]),
                      ),
                      SizedBox(height: 20.h),

                      /// ------------ Password ------------ ///
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
                            errorText: 'Please enter your password',
                          ),
                          FormBuilderValidators.match(
                            RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
                            ),
                            errorText:
                                'Must have 6 chars including letter, number & symbol',
                          ),
                        ]),
                      ),

                      SizedBox(height: 20.h),

                      /// ------------ Login Button ------------ ///
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              final data = _formKey.currentState!.value;
                              authController.login(
                                context,
                                data['email'].trim(),
                                data['password'].trim(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 33, 150, 84),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 13.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// ------------ Navigate to Register ------------ ///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account ?",
                            style: TextStyle(
                                color: Colors.black, fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 150, 84),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 31, 58, 95)),
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
