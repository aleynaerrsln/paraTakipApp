// lib/screens/charts_screen.dart - LOCALIZED VERSION (TARIH FORMATLARI DÜZELTİLDİ)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with TickerProviderStateMixin {
  final _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _transactions = [];
  String _selectedFilter = 'month';

  bool _isPieChartExpanded = false;
  bool _isCategoryChartExpanded = false;
  bool _isTrendChartExpanded = false;

  AnimationController? _fadeController;
  AnimationController? _slideController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController!, curve: Curves.easeOutCubic),
    );

    _fadeController!.forward();
    _slideController!.forward();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.getTransactions(filter: _selectedFilter);

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _transactions = result['data'];
      }
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    return formatter.format(amount);
  }

  Map<String, double> _getCategoryData(String type) {
    Map<String, double> categoryMap = {};

    for (var transaction in _transactions) {
      if (transaction['type'] == type) {
        String category = transaction['category'] ?? 'Other';
        categoryMap[category] =
            (categoryMap[category] ?? 0) + transaction['amount'].toDouble();
      }
    }

    return categoryMap;
  }

  double _getTotalAmount(String type) {
    return _transactions
        .where((t) => t['type'] == type)
        .fold(0.0, (sum, t) => sum + t['amount'].toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: _buildModernAppBar(l10n),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFFF59E0B),
        backgroundColor: const Color(0xFF1E1E2C),
        child: _isLoading
            ? _buildLoadingState(l10n)
            : (_fadeAnimation != null && _slideAnimation != null
            ? FadeTransition(
          opacity: _fadeAnimation!,
          child: SlideTransition(
            position: _slideAnimation!,
            child: _buildContent(l10n),
          ),
        )
            : _buildContent(l10n)),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF1E1E2C),
      elevation: 0,
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
            child: const Icon(Icons.bar_chart, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.charts,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFF59E0B)),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF59E0B).withOpacity(0.2),
                  const Color(0xFFFBBF24).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFFF59E0B),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.loading,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernFilterButtons(l10n),
                const SizedBox(height: 25),
                _buildSummaryCards(l10n),
                const SizedBox(height: 30),
                _buildPieChartCard(l10n),
                const SizedBox(height: 20),
                _buildCategoryChartCard(l10n),
                const SizedBox(height: 20),
                _buildTrendChartCard(l10n),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernFilterButtons(AppLocalizations l10n) {
    final filters = [
      {'label': l10n.today, 'value': 'today', 'icon': Icons.today},
      {'label': l10n.week, 'value': 'week', 'icon': Icons.date_range},
      {'label': l10n.month, 'value': 'month', 'icon': Icons.calendar_month},
      {'label': l10n.all, 'value': 'all', 'icon': Icons.apps},
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter['value'] as String;
                  });
                  _loadData();
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                    )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.1),
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        filter['icon'] as IconData,
                        color: isSelected ? Colors.black87 : Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        filter['label'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(AppLocalizations l10n) {
    final totalIncome = _getTotalAmount('income');
    final totalExpense = _getTotalAmount('expense');
    final balance = totalIncome - totalExpense;

    return Row(
      children: [
        Expanded(
          child: _buildMiniSummaryCard(
            l10n.income,
            totalIncome,
            const Color(0xFF00E676),
            Icons.trending_up,
            0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMiniSummaryCard(
            l10n.expense,
            totalExpense,
            const Color(0xFFFF5252),
            Icons.trending_down,
            100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMiniSummaryCard(
            l10n.balance,
            balance,
            const Color(0xFFF59E0B),
            Icons.account_balance_wallet,
            200,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniSummaryCard(
      String title,
      double amount,
      Color color,
      IconData icon,
      int delayMs,
      ) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + delayMs),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '₺${_formatCurrency(amount)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPieChartCard(AppLocalizations l10n) {
    final totalIncome = _getTotalAmount('income');
    final totalExpense = _getTotalAmount('expense');
    final total = totalIncome + totalExpense;

    if (total == 0) {
      return _buildEmptyCard(l10n.pieChart, Icons.pie_chart, l10n);
    }

    return _buildExpandableCard(
      title: l10n.incomeExpenseDistribution,
      icon: Icons.pie_chart,
      isExpanded: _isPieChartExpanded,
      onToggle: () {
        setState(() {
          _isPieChartExpanded = !_isPieChartExpanded;
        });
      },
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 80,
                    sections: [
                      PieChartSectionData(
                        value: totalIncome,
                        title: '${((totalIncome / total) * 100).toStringAsFixed(0)}%',
                        color: const Color(0xFF00E676),
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        badgeWidget: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Color(0xFF00E676),
                            size: 20,
                          ),
                        ),
                        badgePositionPercentageOffset: 1.3,
                      ),
                      PieChartSectionData(
                        value: totalExpense,
                        title: '${((totalExpense / total) * 100).toStringAsFixed(0)}%',
                        color: const Color(0xFFFF5252),
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        badgeWidget: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5252).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Color(0xFFFF5252),
                            size: 20,
                          ),
                        ),
                        badgePositionPercentageOffset: 1.3,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.total,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₺${_formatCurrency(total)}',
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
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(l10n.income, const Color(0xFF00E676), totalIncome),
              _buildLegendItem(l10n.expense, const Color(0xFFFF5252), totalExpense),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChartCard(AppLocalizations l10n) {
    final expenseCategories = _getCategoryData('expense');

    if (expenseCategories.isEmpty) {
      return _buildEmptyCard(l10n.categoryAnalysis, Icons.category, l10n);
    }

    final sortedCategories = expenseCategories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _buildExpandableCard(
      title: l10n.expenseCategories,
      icon: Icons.category,
      isExpanded: _isCategoryChartExpanded,
      onToggle: () {
        setState(() {
          _isCategoryChartExpanded = !_isCategoryChartExpanded;
        });
      },
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: sortedCategories.first.value * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => const Color(0xFF1E1E2C),
                    tooltipRoundedRadius: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${sortedCategories[groupIndex].key}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '₺${_formatCurrency(rod.toY)}',
                            style: const TextStyle(
                              color: Color(0xFFF59E0B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= sortedCategories.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            sortedCategories[value.toInt()]
                                .key
                                .substring(0, sortedCategories[value.toInt()].key.length > 3 ? 3 : sortedCategories[value.toInt()].key.length)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: sortedCategories.first.value / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: sortedCategories.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFFFF5252).withOpacity(0.5),
                            const Color(0xFFFF5252),
                          ],
                        ),
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...sortedCategories.take(5).map((entry) {
            return _buildCategoryListItem(
              entry.key,
              entry.value,
              sortedCategories.first.value,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrendChartCard(AppLocalizations l10n) {
    Map<String, double> dailyExpenses = {};

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = DateFormat('dd/MM', Localizations.localeOf(context).languageCode).format(date); // ✅ DÜZELTİLDİ
      dailyExpenses[dateKey] = 0;
    }

    for (var transaction in _transactions) {
      final date = DateTime.parse(transaction['date']);
      final dateKey = DateFormat('dd/MM', Localizations.localeOf(context).languageCode).format(date); // ✅ DÜZELTİLDİ

      if (dailyExpenses.containsKey(dateKey) && transaction['type'] == 'expense') {
        dailyExpenses[dateKey] = dailyExpenses[dateKey]! + transaction['amount'].toDouble();
      }
    }

    final hasData = dailyExpenses.values.any((value) => value > 0);

    if (!hasData) {
      return _buildEmptyCard(l10n.trendAnalysis, Icons.trending_up, l10n);
    }

    final maxValue = dailyExpenses.values.reduce((a, b) => a > b ? a : b);

    return _buildExpandableCard(
      title: l10n.weeklyExpenseTrend,
      icon: Icons.trending_up,
      isExpanded: _isTrendChartExpanded,
      onToggle: () {
        setState(() {
          _isTrendChartExpanded = !_isTrendChartExpanded;
        });
      },
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxValue > 0 ? maxValue / 5 : 100,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= dailyExpenses.length) {
                      return const SizedBox();
                    }
                    final date = dailyExpenses.keys.toList()[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    );
                  },
                  interval: 1,
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: dailyExpenses.entries.toList().asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.value,
                  );
                }).toList(),
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                ),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: const Color(0xFFF59E0B),
                      strokeWidth: 2,
                      strokeColor: const Color(0xFF1E1E2C),
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF59E0B).withOpacity(0.3),
                      const Color(0xFFF59E0B).withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => const Color(0xFF1E1E2C),
                tooltipRoundedRadius: 12,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final date = dailyExpenses.keys.toList()[barSpot.x.toInt()];
                    return LineTooltipItem(
                      '$date\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '₺${_formatCurrency(barSpot.y)}',
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, double value, _child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: _child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    onTap: onToggle,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white.withOpacity(0.7),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: child,
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String title, IconData icon, AppLocalizations l10n) {
    return _buildExpandableCard(
      title: title,
      icon: icon,
      isExpanded: true,
      onToggle: () {},
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  size: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.insufficientData,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            Text(
              '₺${_formatCurrency(value)}',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryListItem(String category, double amount, double maxAmount) {
    final percentage = (amount / maxAmount) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₺${_formatCurrency(amount)}',
                style: const TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFFF5252).withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    super.dispose();
  }
}