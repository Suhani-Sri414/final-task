import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/images/mindeaselogo.png',height: 300,width: 300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 320, left: 115),
            child: const Text(
              'Mind',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),fontSize: 40,fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 320, left: 198),
            child: const Text(
              'Ease',
              style: TextStyle(
                color: Color.fromARGB(255, 33, 150, 84),fontSize: 40,fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 380, left: 120),
            child: const Text(
              'Welcome back !',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),fontSize: 21,fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 405, left: 100),
            child: const Text(
              'Login to your account',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),fontSize: 21,fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 445, left: 115),
            child: const Text(
              'Its nice to see you again',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),fontSize: 16,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.58,left: 35,right: 35,
              ),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
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
                    const SizedBox(height: 20),
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
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
                          ),
                          errorText:
                              'Must have 6 chars including letter, number & symbol',
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          final data = _formKey.currentState!.value;
                          authController.login(
                            context,
                            data['email'].trim(),
                            data['password'].trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 140,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: const Text(
                            " Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 33, 150, 84),fontWeight: FontWeight.bold,
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
