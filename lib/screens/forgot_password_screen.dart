// lib/screens/forgot_password_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _sendResetCode() async {
    if (_emailController.text.isEmpty) {
      _showError('Email gerekli');
      return;
    }

    // Email format kontrolü
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      _showError('Geçerli bir email adresi girin');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.forgotPassword(
      email: _emailController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (mounted) {
        // Başarılı - Reset ekranına git
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: _emailController.text,
              resetCode: result['data']['resetCode'], // Development için
            ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Geri butonu
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 40),

                // İkon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Başlık
                const Center(
                  child: Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Açıklama
                Center(
                  child: Text(
                    'Email adresinizi girin, size bir\nsıfırlama kodu gönderelim',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Email Input Card
                _buildEmailCard(),
                const SizedBox(height: 30),

                // Kod Gönder Butonu
                _buildSendCodeButton(),
                const SizedBox(height: 20),

                // Geri dön linki
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Giriş sayfasına dön',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email Adresi',
                style: TextStyle(
                  color: Color(0xFFEEE2B9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ornek@email.com',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.email, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendCodeButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFA500),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isLoading ? null : _sendResetCode,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
              color: Color(0xFF2D2200),
            )
                : const Text(
              'Kod Gönder',
              style: TextStyle(
                color: Color(0xFF2D2200),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
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
    super.dispose();
  }
}