// lib/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59E0B)),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        // ✅ TITLE'I ROW YAPIP İKON EKLEDİM
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.analytics, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.statistics,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B)))
          : SingleChildScrollView(
        // ... geri kalan kod aynı
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genel Bilgiler
            _buildSectionTitle(l10n.generalInfo),
            const SizedBox(height: 15),
            _buildStatCard(
              l10n.totalTransactions,
              '${_statistics['totalTransactions'] ?? 0}',
              Icons.receipt_long,
              const Color(0xFFF59E0B), // ✅ MAVİDEN TURUNCU/ALTIN
            ),
            const SizedBox(height: 30),

            // Ortalamalar
            _buildSectionTitle(l10n.averageExpenses),
            const SizedBox(height: 15),
            _buildAverageCards(l10n),
            const SizedBox(height: 30),

            // Aylık Karşılaştırma
            _buildSectionTitle(l10n.monthComparison),
            const SizedBox(height: 15),
            _buildMonthComparison(l10n),
            const SizedBox(height: 30),

            // En Büyük İşlemler
            _buildSectionTitle(l10n.biggestTransactions),
            const SizedBox(height: 15),
            _buildBiggestTransactions(l10n),
            const SizedBox(height: 30),

            // En Çok Harcanan Kategoriler
            _buildSectionTitle(l10n.topExpenseCategories),
            const SizedBox(height: 15),
            _buildTopCategories(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white, // ✅ GRİDEN BEYAZA DEĞİŞTİ
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

  Widget _buildAverageCards(AppLocalizations l10n) {
    final daily = (_statistics['dailyAverage'] ?? 0).toDouble();
    final weekly = (_statistics['weeklyAverage'] ?? 0).toDouble();
    final monthly = (_statistics['currentMonthTotal'] ?? 0).toDouble();

    return Column(
      children: [
        _buildAverageCard(l10n.dailyAverage, daily, Icons.today),
        const SizedBox(height: 10),
        _buildAverageCard(l10n.weeklyAverage, weekly, Icons.date_range),
        const SizedBox(height: 10),
        _buildAverageCard(l10n.thisMonthTotal, monthly, Icons.calendar_month),
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
          Icon(icon, color: const Color(0xFFF59E0B), size: 30), // ✅ TURUNCU
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

  Widget _buildMonthComparison(AppLocalizations l10n) {
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
                  Text(
                    l10n.thisMonth,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
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
                  Text(
                    l10n.lastMonth,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
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
                  isIncrease ? l10n.increase : l10n.decrease,
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

  Widget _buildBiggestTransactions(AppLocalizations l10n) {
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
              Expanded(
                child: Text(
                  l10n.biggestIncome,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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
              Expanded(
                child: Text(
                  l10n.biggestExpense,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildTopCategories(AppLocalizations l10n) {
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
            l10n.noCategoryData,
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Column(
      children: categories.map((category) {
        String name = category['_id'] ?? l10n.other;
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
                      '$count ${l10n.transactionsCount}',
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