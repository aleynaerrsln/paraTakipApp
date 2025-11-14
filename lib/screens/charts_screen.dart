// lib/screens/charts_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _categoryData = [];

  final _formatter = NumberFormat('#,##0', 'tr_TR');

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() {
      _isLoading = true;
    });

    // Kategori özeti (sadece gider)
    final categoryResult = await _apiService.getCategorySummary(type: 'expense');

    setState(() {
      _isLoading = false;

      if (categoryResult['success']) {
        _categoryData = categoryResult['data'];
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Grafikler ve Analiz'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pasta Grafik - Kategorilere Göre Gider
            _buildSectionTitle('Kategorilere Göre Harcama'),
            const SizedBox(height: 20),
            _buildPieChart(),
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

  Widget _buildPieChart() {
    if (_categoryData.isEmpty) {
      return _buildEmptyState('Henüz gider verisi yok');
    }

    // Renk paleti
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];

    // Toplam hesapla
    double total = _categoryData.fold(0, (sum, item) => sum + (item['total'] ?? 0));

    return Column(
      children: [
        // Pasta Grafik
        Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(15),
          ),
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: _categoryData.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                double value = (item['total'] ?? 0).toDouble();
                double percentage = (value / total) * 100;

                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: value,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Açıklama Listesi
        ..._categoryData.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          String category = item['_id'] ?? 'Diğer';
          double amount = (item['total'] ?? 0).toDouble();
          double percentage = (amount / total) * 100;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '(${percentage.toStringAsFixed(0)}%)',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 60, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}