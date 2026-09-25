import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/neumorphic_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginMode = true;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Kemaskini 1: Buat Getters untuk Firebase supaya tidak menghalang UI semasa init
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseDatabase get _database => FirebaseDatabase.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ralat Sistem"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLoginMode && name.isEmpty)) {
      _showErrorDialog("Sila isi semua ruangan yang diperlukan.");
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLoginMode) {
        // =============== LOGIK LOGIN FIREBASE ===============
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // =============== LOGIK REGISTER FIREBASE ===============
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await _database.ref().child('users').child(uid).set({
            'uid': uid,
            'name': name,
            'email': email,
            'role': 'staff',
            'createdAt': ServerValue.timestamp,
          });
        }

        if (!mounted) return;

        setState(() {
          isLoginMode = true;
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akaun berjaya didaftar! Sila sign in.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Berlaku masalah pada Firebase Auth.");
    } catch (e) {
      _showErrorDialog("Error tak dijangka: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. LOGO SHIELD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: NeoColors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.white, offset: Offset(-8, -8), blurRadius: 16),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(8, 8), blurRadius: 16),
                  ],
                ),
                child: const Icon(Icons.security_rounded, size: 40, color: NeoColors.primary),
              ),
              const SizedBox(height: 32),

              // 2. TAJUK
              Text(
                isLoginMode ? "Welcome" : "Create Account",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: NeoColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                isLoginMode ? "Sign in to manage your lab assets" : "Register to start managing assets",
                style: const TextStyle(color: NeoColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // 3. BORANG INPUT
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: NeoColors.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, offset: Offset(-8, -8), blurRadius: 16),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(8, 8), blurRadius: 16),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLoginMode) ...[
                      const Text("FULL NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NeoColors.textSecondary)),
                      const SizedBox(height: 8),
                      _buildInputField(_nameController, "Name", Icons.person_outline),
                      const SizedBox(height: 20),
                    ],
                    const Text("OFFICIAL EMAIL", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NeoColors.textSecondary)),
                    const SizedBox(height: 8),
                    _buildInputField(_emailController, "E-mail", Icons.email_outlined),
                    const SizedBox(height: 20),
                    const Text("PASSWORD", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NeoColors.textSecondary)),
                    const SizedBox(height: 8),
                    _buildInputField(_passwordController, "••••••••", Icons.lock_outline, obscureText: true),
                    if (isLoginMode) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?", style: TextStyle(color: NeoColors.primary, fontSize: 13)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. BUTANG SIGN IN / REGISTER
              GestureDetector(
                onTap: isLoading ? null : _handleSubmit,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: NeoColors.background,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                      BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: NeoColors.primary)
                        : Text(
                            isLoginMode ? "SIGN IN" : "REGISTER",
                            style: const TextStyle(color: NeoColors.primary, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. TUKAR MODE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLoginMode ? "Don't have an account? " : "Already have an account? ",
                    style: const TextStyle(color: NeoColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoginMode = !isLoginMode;
                      });
                    },
                    child: Text(
                      isLoginMode ? "Register" : "Sign In",
                      style: const TextStyle(color: NeoColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: NeoColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: NeoColors.textSecondary),
          border: InputBorder.none,
          icon: Icon(icon, color: NeoColors.textSecondary, size: 20),
        ),
      ),
    );
  }
}