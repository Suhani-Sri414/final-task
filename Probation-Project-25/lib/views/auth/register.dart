import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/icons/mindeaselogo.png',
                height: 300,
                width: 300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 320, left: 117),
            child: const Text(
              'Mind',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 320, left: 200),
            child: const Text(
              'Ease',
              style: TextStyle(
                color: Color.fromARGB(255, 33, 150, 84),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 380, left: 160),
            child: const Text(
              'Join Us',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.47,
              left: 35,
              right: 35,
            ),
            child: Column(
              children: [
                const Text(
                  'Create your account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 31, 58, 95),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                      const SizedBox(height: 15),
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
                            if (!value.trim().endsWith('@gmail.com')) {
                              return 'Only Gmail addresses are allowed';
                            }
                            return null;
                          },
                        ]),
                      ),
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
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
                          final password =
                              _formKey.currentState?.fields['password']?.value;
                          if (val == null || val.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (val != password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 130,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'login'),
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 150, 84),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 31, 58, 95)),
      suffixIcon: suffix,
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
