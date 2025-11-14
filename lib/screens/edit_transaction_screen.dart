// lib/screens/edit_transaction_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _apiService = ApiService();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  late String _selectedType;
  late String _selectedCategory;
  bool _isLoading = false;

  // Formatlama için
  final _formatter = NumberFormat('#,##0', 'tr_TR');

  final List<String> _categories = [
    'Maaş',
    'Freelance',
    'Yatırım',
    'Market',
    'Fatura',
    'Ulaşım',
    'Eğlence',
    'Sağlık',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();

    // Mevcut verileri doldur
    _descriptionController = TextEditingController(
        text: widget.transaction['description']
    );

    // Tutarı formatla
    final amount = widget.transaction['amount'];
    _amountController = TextEditingController(
        text: _formatter.format(amount is int ? amount : amount.toInt())
    );

    _selectedType = widget.transaction['type'];
    _selectedCategory = widget.transaction['category'] ?? 'Diğer';

    // Tutar girişi için formatlama
    _amountController.addListener(() {
      final text = _amountController.text;
      if (text.isEmpty) return;

      // Sadece rakamları al
      final cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanText.isEmpty) return;

      // Format uygula
      final number = int.parse(cleanText);
      final formatted = _formatter.format(number);

      // Cursor pozisyonunu koru
      final cursorPos = _amountController.selection.base.offset;
      final oldLength = text.length;

      if (text != formatted) {
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(
            offset: cursorPos + (formatted.length - oldLength),
          ),
        );
      }
    });
  }

  Future<void> _updateTransaction() async {
    if (_descriptionController.text.isEmpty || _amountController.text.isEmpty) {
      _showError('Açıklama ve tutar gerekli');
      return;
    }

    // Rakamları temizle ve parse et
    final cleanAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(cleanAmount);

    if (amount == null || amount <= 0) {
      _showError('Geçerli bir tutar girin');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.updateTransaction(
      transactionId: widget.transaction['_id'],
      description: _descriptionController.text,
      amount: amount,
      type: _selectedType,
      category: _selectedCategory,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (mounted) {
        Navigator.pop(context, true);
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
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: const Text('İşlemi Düzenle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tip Seçimi (Gelir/Gider)
            const Text(
              'İşlem Tipi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildTypeSelector(),
            const SizedBox(height: 30),

            // Açıklama
            _buildTextField(
              controller: _descriptionController,
              label: 'Açıklama',
              hint: 'Örn: Market alışverişi',
              icon: Icons.description,
            ),
            const SizedBox(height: 20),

            // Tutar
            _buildAmountTextField(),
            const SizedBox(height: 20),

            // Kategori
            const Text(
              'Kategori',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildCategorySelector(),
            const SizedBox(height: 40),

            // Güncelle Butonu
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeCard(
            'Gelir',
            'income',
            Icons.arrow_downward,
            Colors.green,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildTypeCard(
            'Gider',
            'expense',
            Icons.arrow_upward,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(String title, String type, IconData icon, Color color) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              color.withOpacity(0.6),
              color.withOpacity(0.3),
            ],
          )
              : LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: Icon(icon, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tutar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    child: Text(
                      '₺',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42A5F5).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isLoading ? null : _updateTransaction,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              'Güncelle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}