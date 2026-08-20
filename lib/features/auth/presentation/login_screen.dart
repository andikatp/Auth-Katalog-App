import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = .new();
  final TextEditingController _passwordController = .new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const .all(16),
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
