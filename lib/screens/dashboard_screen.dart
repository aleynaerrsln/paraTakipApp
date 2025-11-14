// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';
import 'calendar_screen.dart';
import 'charts_screen.dart';
import 'statistics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic> _summary = {};
  List<dynamic> _recentTransactions = [];
  String _selectedFilter = 'all';
  String _userName = ''; // YENİ EKLENEN

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUserInfo(); // YENİ EKLENEN
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Filtre parametresi
    String? filterParam = _selectedFilter == 'all' ? null : _selectedFilter;

    // Özet bilgileri çek
    final summaryResult = await _apiService.getSummary(filter: filterParam);

    // İşlemleri çek
    final transactionsResult = await _apiService.getTransactions(filter: filterParam);

    setState(() {
      _isLoading = false;

      if (summaryResult['success']) {
        _summary = summaryResult['data'];
      } else {
        _showError(summaryResult['error']);
      }

      if (transactionsResult['success']) {
        _recentTransactions = transactionsResult['data'];
      } else {
        _showError(transactionsResult['error']);
      }
    });
  }
  Future<void> _loadUserInfo() async {
    final result = await _apiService.getUserInfo();

    if (result['success']) {
      setState(() {
        _userName = result['data']['name'] ?? '';
      });
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

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: const Text(
          'PARA TAKİP',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChartsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _apiService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hoşgeldin mesajı

              Text(
                _userName.isEmpty ? 'Hoş Geldin! 👋' : 'Hoş Geldin, $_userName! 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Filtre Butonları
              _buildFilterButtons(),
              const SizedBox(height: 20),

              // Özet Kartlar
              _buildSummaryCards(),
              const SizedBox(height: 30),

              // Son İşlemler Başlık
              const Text(
                'Son İşlemler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // İşlemler Listesi
              _buildTransactionsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // İşlem ekleme ekranına git
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );

          // Eğer işlem eklendiyse sayfayı yenile
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildFilterButtons() {
    final filters = [
      {'label': 'Tümü', 'value': 'all'},
      {'label': 'Bugün', 'value': 'today'},
      {'label': 'Bu Hafta', 'value': 'week'},
      {'label': 'Bu Ay', 'value': 'month'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter['value']!;
                });
                _loadData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        // Gelir Kartı
        _buildSummaryCard(
          'Gelir',
          _summary['totalIncome']?.toDouble() ?? 0,
          Colors.green,
          Icons.arrow_downward,
        ),
        const SizedBox(height: 15),

        // Gider Kartı
        _buildSummaryCard(
          'Gider',
          _summary['totalExpense']?.toDouble() ?? 0,
          Colors.red,
          Icons.arrow_upward,
        ),
        const SizedBox(height: 15),

        // Bakiye Kartı
        _buildSummaryCard(
          'Bakiye',
          _summary['balance']?.toDouble() ?? 0,
          Colors.blue,
          Icons.account_balance_wallet,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.6),
            color.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₺${_formatCurrency(amount)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_recentTransactions.isEmpty) {
      return Center(
        child: Column(
          children: const [
            SizedBox(height: 50),
            Icon(Icons.receipt_long, size: 60, color: Colors.white30),
            SizedBox(height: 10),
            Text(
              'Henüz işlem yok',
              style: TextStyle(color: Colors.white30, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _recentTransactions[index];
        final isIncome = transaction['type'] == 'income';

        return GestureDetector(
          onTap: () => _showTransactionOptions(transaction),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        transaction['date'] != null
                            ? transaction['date'].toString().substring(0, 10)
                            : 'Tarih yok',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isIncome ? '+' : '-'}₺${_formatCurrency(transaction['amount'].toDouble())}',
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTransactionOptions(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Başlık
              Text(
                transaction['description'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '₺${_formatCurrency(transaction['amount'].toDouble())}',
                style: TextStyle(
                  color: transaction['type'] == 'income'
                      ? Colors.green
                      : Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Düzenle Butonu
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Düzenle', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTransactionScreen(
                        transaction: transaction,
                      ),
                    ),
                  );
                  if (result == true) {
                    _loadData();
                  }
                },
              ),

              // Sil Butonu
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Sil', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(transaction['_id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(String transactionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'İşlem Silinecek',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Bu işlemi silmek istediğinize emin misiniz?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _deleteTransaction(transactionId);
    }
  }

  Future<void> _deleteTransaction(String transactionId) async {
    final result = await _apiService.deleteTransaction(transactionId);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İşlem silindi'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } else {
      _showError(result['error']);
    }
  }
}