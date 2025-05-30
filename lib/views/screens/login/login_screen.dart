import 'package:flutter/material.dart';
import 'package:krit_app/services/auth_service.dart';
import '../admin/admin_screen.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await Provider.of<AuthProvider>(context, listen: false)
          .login(_emailController.text, _passwordController.text);

      if (success) {
        Provider.of<AuthProvider>(context, listen: false).setAdminRole();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zalogowano pomyślnie!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Niepoprawna nazwa użytkownika lub hasło'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme().backgroundColor,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      'Panel Administratora',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      labelText: 'Nazwa użytkownika',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Podaj nazwę użytkownika";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Hasło',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Podaj hasło";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Zaloguj się",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
