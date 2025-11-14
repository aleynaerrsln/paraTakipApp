// lib/screens/login_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/animated_panda.dart';
import '../widgets/lamp_light.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isPasswordFocused = false;
  bool _isLightOn = false;
  bool _showForm = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Ekran açıldığında animasyon başlat
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isLightOn = true;
        _showForm = true;
      });
      _animationController.forward();
    });
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Email ve şifre gerekli');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (mounted) {
        // Dashboard'a git
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    } else {
      _showError(result['error']);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF222222),
              Color(0xFF111111),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Lamba Işığı Efekti
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _isLightOn ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 600),
                  child: LampLight(isLightOn: _isLightOn),
                ),
              ),
            ),

            // Ana içerik
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Panda ve Form - STACK İLE BİRLEŞTİRİLDİ
                      AnimatedOpacity(
                        opacity: _showForm ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: AnimatedScale(
                          scale: _showForm ? 1.0 : 0.8,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              // Login Kartı (altta)
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: _buildLoginCard(),
                              ),

                              // Panda (üstte, formun tam kenarında)
                              Positioned(
                                top: -60,
                                child: _buildPandaAvatar(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Geri butonu
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPandaAvatar() {
    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedPanda(
        eyesClosed: _isPasswordFocused,
      ),
    );
  }

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 370,
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 60,
                offset: const Offset(0, 25),
              ),
            ],
          ),
          child: Column(
            children: [
              // Başlık
              const Text(
                'HOŞ GELDİN',
                style: TextStyle(
                  color: Color(0xFFFFF5D7),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 25),

              // Email Input
              _buildGlassTextField(
                controller: _emailController,
                label: 'Kullanıcı Adı:',
                keyboardType: TextInputType.emailAddress,
              ),

              // Şifre Input
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isPasswordFocused = hasFocus;
                  });
                },
                child: _buildGlassTextField(
                  controller: _passwordController,
                  label: 'Şifre:',
                  isPassword: true,
                ),
              ),

              const SizedBox(height: 10),

              // Giriş Butonu
              _buildGradientButton(),

              const SizedBox(height: 10),

              // Şifremi Unuttum Linki
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Şifremi Unuttum?',
                    style: TextStyle(
                      color: Color(0xFFEEE2B9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Kayıt Ol Linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hesabınız yok mu? ',
                    style: TextStyle(
                      color: Color(0xFFEEE2B9),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        color: Color(0xFFFFC93C),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFEEE2B9),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.65),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF333333), fontSize: 15),
            decoration: InputDecoration(
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFC93C),
            Color(0xFFFFA500),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _isLoading ? null : _login,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
              color: Color(0xFF2D2200),
            )
                : const Text(
              'Giriş Yap',
              style: TextStyle(
                color: Color(0xFF2D2200),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}