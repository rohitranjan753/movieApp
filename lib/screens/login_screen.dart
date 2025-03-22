import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool isSuccess = authProvider.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(TextConstants.icorrectPasswordText,style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/login_lottie.json', height: 200),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text(
                TextConstants.loginText,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const Text(
                TextConstants.loginSubText,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: TextConstants.emailHintText,
                  border: OutlineInputBorder(),
                  labelText: TextConstants.emailLabelText,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return TextConstants.emailEmptyText;
                  }
                  final emailRegex =
                      RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return TextConstants.validEmailText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: TextConstants.passwordHintText,
                  border: OutlineInputBorder(),
                  labelText: TextConstants.passwordLabelText,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return TextConstants.passwordEmptyText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => submitForm(context),
                    child: const Text(TextConstants.loginButtonText),
                  ),
                ),
              ),
                
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
