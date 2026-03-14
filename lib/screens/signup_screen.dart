import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../supabase/supabase_initializer.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      if (SupabaseInitializer.isDemoMode) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Demo Mode: Account created! (No real email sent)"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      try {
        await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created! Please check your email for verification."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to Login screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup Failed: ${e.toString()}"), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up"), backgroundColor: Colors.green[700]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Join SocioHub",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? "Password must be 6+ chars" : null,
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
