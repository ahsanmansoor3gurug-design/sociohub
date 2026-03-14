import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../supabase/supabase_initializer.dart';
import 'signup_screen.dart';
import 'city_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      if (SupabaseInitializer.isDemoMode) {
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CityScreen()),
          );
        }
        return;
      }

      try {
        await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CityScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed: ${e.toString()}"), backgroundColor: Colors.red),
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
      appBar: AppBar(
        title: Text("Login"), 
        backgroundColor: Colors.green[700],
        actions: [
          if (SupabaseInitializer.isDemoMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text("DEMO MODE", style: TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: Colors.orange,
              ),
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to SocioHub",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              SizedBox(height: 10),
              if (SupabaseInitializer.isDemoMode)
                Text(
                  "Using demo mode. Any email/password will work.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? "Enter email" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? "Password must be 6+ chars" : null,
              ),
              SizedBox(height: 25),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
                child: Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
