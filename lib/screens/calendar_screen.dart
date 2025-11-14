// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _apiService = ApiService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<String, dynamic> _monthlySummary = {};
  List<dynamic> _selectedDayTransactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadMonthData();
  }

  Future<void> _loadMonthData() async {
    setState(() {
      _isLoading = true;
    });

    // Ayın ilk ve son günü
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    final startDate = firstDay.toIso8601String();
    final endDate = lastDay.toIso8601String();

    // Aylık özet
    final summaryResult = await _apiService.getSummary(
      startDate: startDate,
      endDate: endDate,
    );

    if (summaryResult['success']) {
      setState(() {
        _monthlySummary = summaryResult['data'];
      });
    }

    setState(() {
      _isLoading = false;
    });

    // Seçili günün işlemlerini yükle
    _loadDayTransactions(_selectedDay!);
  }

  Future<void> _loadDayTransactions(DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

    final result = await _apiService.getTransactions(
      startDate: startOfDay.toIso8601String(),
      endDate: endOfDay.toIso8601String(),
    );

    if (result['success']) {
      setState(() {
        _selectedDayTransactions = result['data'];
      });
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Takvim'),
      ),
      body: Column(
        children: [
          // Aylık Özet Kartı
          _buildMonthlySummaryCard(),

          // Takvim
          _buildCalendar(),

          // Seçili Günün İşlemleri
          Expanded(
            child: _buildSelectedDayTransactions(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummaryCard() {
    final income = (_monthlySummary['totalIncome'] ?? 0).toDouble();
    final expense = (_monthlySummary['totalExpense'] ?? 0).toDouble();
    final balance = (_monthlySummary['balance'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.6),
            Colors.blue.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy', 'tr_TR').format(_focusedDay),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Gelir', income, Colors.green),
              _buildSummaryItem('Gider', expense, Colors.red),
              _buildSummaryItem('Bakiye', balance, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '₺${_formatCurrency(amount)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        locale: 'tr_TR',
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _loadDayTransactions(selectedDay);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _loadMonthData();
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(color: Colors.red),
          defaultTextStyle: const TextStyle(color: Colors.white),
          selectedDecoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white70),
          weekendStyle: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSelectedDayTransactions() {
    if (_selectedDayTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text(
              'Bu günde işlem yok',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _selectedDayTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _selectedDayTransactions[index];
        final isIncome = transaction['type'] == 'income';

        return Container(
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
                      transaction['category'] ?? 'Diğer',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}₺${_formatCurrency((transaction['amount'] ?? 0).toDouble())}',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}