// lib/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic> _statistics = {};

  final _formatter = NumberFormat('#,##0', 'tr_TR');

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.getStatistics();

    setState(() {
      _isLoading = false;

      if (result['success']) {
        _statistics = result['data'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('İstatistikler'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genel Bilgiler
            _buildSectionTitle('Genel Bilgiler'),
            const SizedBox(height: 15),
            _buildStatCard(
              'Toplam İşlem',
              '${_statistics['totalTransactions'] ?? 0}',
              Icons.receipt_long,
              Colors.blue,
            ),
            const SizedBox(height: 30),

            // Ortalamalar
            _buildSectionTitle('Ortalama Harcamalar'),
            const SizedBox(height: 15),
            _buildAverageCards(),
            const SizedBox(height: 30),

            // Aylık Karşılaştırma
            _buildSectionTitle('Bu Ay vs Geçen Ay'),
            const SizedBox(height: 15),
            _buildMonthComparison(),
            const SizedBox(height: 30),

            // En Büyük İşlemler
            _buildSectionTitle('En Büyük İşlemler'),
            const SizedBox(height: 15),
            _buildBiggestTransactions(),
            const SizedBox(height: 30),

            // En Çok Harcanan Kategoriler
            _buildSectionTitle('En Çok Harcanan Kategoriler'),
            const SizedBox(height: 15),
            _buildTopCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Column(
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
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageCards() {
    final daily = (_statistics['dailyAverage'] ?? 0).toDouble();
    final weekly = (_statistics['weeklyAverage'] ?? 0).toDouble();
    final monthly = (_statistics['currentMonthTotal'] ?? 0).toDouble();

    return Column(
      children: [
        _buildAverageCard('Günlük Ortalama', daily, Icons.today),
        const SizedBox(height: 10),
        _buildAverageCard('Haftalık Ortalama', weekly, Icons.date_range),
        const SizedBox(height: 10),
        _buildAverageCard('Bu Ay Toplam', monthly, Icons.calendar_month),
      ],
    );
  }

  Widget _buildAverageCard(String title, double amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '₺${_formatter.format(amount.toInt())}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthComparison() {
    final currentMonth = (_statistics['currentMonthTotal'] ?? 0).toDouble();
    final lastMonth = (_statistics['lastMonthTotal'] ?? 0).toDouble();
    final comparison = (_statistics['monthComparison'] ?? 0).toDouble();

    final isIncrease = comparison > 0;
    final percentage = lastMonth > 0 ? ((comparison / lastMonth) * 100).abs() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bu Ay',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₺${_formatter.format(currentMonth.toInt())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Geçen Ay',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₺${_formatter.format(lastMonth.toInt())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isIncrease
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isIncrease ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 10),
                Text(
                  '${isIncrease ? '+' : '-'}${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: isIncrease ? Colors.red : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  isIncrease ? 'Artış' : 'Azalış',
                  style: TextStyle(
                    color: isIncrease ? Colors.red : Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiggestTransactions() {
    final biggestIncome = (_statistics['biggestIncome'] ?? 0).toDouble();
    final biggestExpense = (_statistics['biggestExpense'] ?? 0).toDouble();

    return Column(
      children: [
        Container(
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
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_downward, color: Colors.green),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'En Büyük Gelir',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                '₺${_formatter.format(biggestIncome.toInt())}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_upward, color: Colors.red),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'En Büyük Gider',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                '₺${_formatter.format(biggestExpense.toInt())}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategories() {
    final categories = _statistics['topCategories'] as List? ?? [];

    if (categories.isEmpty) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Henüz kategori verisi yok',
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Column(
      children: categories.map((category) {
        String name = category['_id'] ?? 'Diğer';
        double amount = (category['total'] ?? 0).toDouble();
        int count = category['count'] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$count işlem',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₺${_formatter.format(amount.toInt())}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}