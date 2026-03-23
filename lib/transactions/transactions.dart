import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionItem {
  final String time;
  final Color color;
  final bool isDebit;
  final String title;
  final IconData icon;
  final String amount;
  final DateTime date;
  final String category;
  final String subtitle;
  final double amountValue;
  const TransactionItem({
    required this.time,
    required this.icon,
    required this.date,
    required this.title,
    required this.color,
    required this.amount,
    required this.isDebit,
    required this.subtitle,
    required this.category,
    required this.amountValue,
  });
}

final List<TransactionItem> allTransactions = [
  TransactionItem(
    title: 'Amazon Pay',
    subtitle: 'Shopping',
    amount: '- ₹1,200.00',
    time: '12:45 PM',
    icon: FontAwesomeIcons.bagShopping,
    color: Colors.blue[600]!,
    isDebit: true,
    date: DateTime(2025, 3, 15),
    amountValue: 1200,
    category: 'Shopping',
  ),
  TransactionItem(
    title: 'Food Delivery',
    subtitle: 'Food & Dining',
    amount: '- ₹450.00',
    time: '02:30 PM',
    icon: FontAwesomeIcons.utensils,
    color: Colors.orange[600]!,
    isDebit: true,
    date: DateTime(2025, 3, 15),
    amountValue: 450,
    category: 'Food',
  ),
  TransactionItem(
    title: 'Salary Credit',
    subtitle: 'Income',
    amount: '+ ₹45,000.00',
    time: '09:15 AM',
    icon: FontAwesomeIcons.buildingColumns,
    color: Colors.green[600]!,
    isDebit: false,
    date: DateTime(2025, 3, 14),
    amountValue: 45000,
    category: 'Income',
  ),
  TransactionItem(
    title: 'Uber Ride',
    subtitle: 'Transportation',
    amount: '- ₹350.00',
    time: '11:20 AM',
    icon: FontAwesomeIcons.car,
    color: Colors.purple[600]!,
    isDebit: true,
    date: DateTime(2025, 3, 14),
    amountValue: 350,
    category: 'Travel',
  ),
  TransactionItem(
    title: 'Netflix',
    subtitle: 'Entertainment',
    amount: '- ₹649.00',
    time: '06:30 PM',
    icon: FontAwesomeIcons.tv,
    color: Colors.red[600]!,
    isDebit: true,
    date: DateTime(2025, 3, 12),
    amountValue: 649,
    category: 'Expenses',
  ),
  TransactionItem(
    title: 'Electricity Bill',
    subtitle: 'Utilities',
    amount: '- ₹1,450.00',
    time: '03:45 PM',
    icon: FontAwesomeIcons.bolt,
    color: Colors.amber[700]!,
    isDebit: true,
    date: DateTime(2025, 3, 12),
    amountValue: 1450,
    category: 'Expenses',
  ),
  TransactionItem(
    title: 'Freelance Payment',
    subtitle: 'Income',
    amount: '+ ₹3,250.00',
    time: '10:15 AM',
    icon: FontAwesomeIcons.laptopCode,
    color: Colors.green[600]!,
    isDebit: false,
    date: DateTime(2025, 3, 12),
    amountValue: 3250,
    category: 'Income',
  ),
  TransactionItem(
    title: 'Gym Membership',
    subtitle: 'Health & Fitness',
    amount: '- ₹1,800.00',
    time: '08:20 AM',
    icon: FontAwesomeIcons.dumbbell,
    color: Colors.indigo[600]!,
    isDebit: true,
    date: DateTime(2025, 3, 10),
    amountValue: 1800,
    category: 'Expenses',
  ),
  TransactionItem(
    title: 'Interest Credit',
    subtitle: 'Income',
    amount: '+ ₹125.50',
    time: '12:00 AM',
    icon: FontAwesomeIcons.percent,
    color: Colors.green[600]!,
    isDebit: false,
    date: DateTime(2025, 3, 10),
    amountValue: 125.50,
    category: 'Income',
  ),
];

class Transactions extends StatefulWidget {
  const Transactions({super.key});
  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';
  String _sortBy = 'Date (Newest)';
  RangeValues _amountRange = const RangeValues(0, 50000);

  final List<String> _filterOptions = [
    'All',
    'Income',
    'Expenses',
    'Shopping',
    'Food',
    'Travel',
  ];

  final List<String> _sortOptions = [
    'Date (Newest)',
    'Date (Oldest)',
    'Amount (High to Low)',
    'Amount (Low to High)',
  ];

  List<TransactionItem> get _filtered {
    List<TransactionItem> result = List.from(allTransactions);
    if (_selectedFilter != 'All') {
      result = result.where((t) {
        if (_selectedFilter == 'Income') return !t.isDebit;
        if (_selectedFilter == 'Expenses') return t.isDebit;
        return t.category == _selectedFilter;
      }).toList();
    }
    if (_startDate != null) {
      result = result
          .where(
            (t) => t.date.isAfter(
              _startDate!.subtract(const Duration(days: 1)),
            ),
          )
          .toList();
    }
    if (_endDate != null) {
      result = result
          .where(
            (t) => t.date.isBefore(
              _endDate!.add(const Duration(days: 1)),
            ),
          )
          .toList();
    }
    result = result
        .where((t) =>
            t.amountValue >= _amountRange.start &&
            t.amountValue <= _amountRange.end)
        .toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              t.subtitle.toLowerCase().contains(q) ||
              t.amount.toLowerCase().contains(q))
          .toList();
    }

    switch (_sortBy) {
      case 'Date (Newest)':
        result.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Date (Oldest)':
        result.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Amount (High to Low)':
        result.sort((a, b) => b.amountValue.compareTo(a.amountValue));
        break;
      case 'Amount (Low to High)':
        result.sort((a, b) => a.amountValue.compareTo(b.amountValue));
        break;
    }

    return result;
  }

  //String get _dateLabel {
  //  if (_startDate != null && _endDate != null) {
  //    return '${fmt(_startDate!)} – ${fmt(_endDate!)}';
  //  }
  //  if (_startDate != null) return 'From ${fmt(_startDate!)}';
  //  if (_endDate != null) return 'Until ${fmt(_endDate!)}';
  //  return 'March 2025';
  //}

  String fmt(DateTime d) => '${d.day} ${monthShort(d.month)} ${d.year}';

  String monthShort(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  String _monthFull(int m) => const [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][m];

  int get _activeAdvancedFilters {
    int count = 0;
    if (_sortBy != 'Date (Newest)') count++;
    if (_amountRange.start != 0 || _amountRange.end != 50000) count++;
    return count;
  }

  void showDateRangeSheet() {
    int viewMonth = 3;
    int viewYear = 2025;
    DateTime? tempEnd = _endDate;
    DateTime? tempStart = _startDate;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final daysInMonth = DateUtils.getDaysInMonth(viewYear, viewMonth);
            final firstWeekday = DateTime(viewYear, viewMonth, 1).weekday % 7;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Date Range',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tempStart != null && tempEnd != null
                        ? '${fmt(tempStart!)} → ${fmt(tempEnd!)}'
                        : tempStart != null
                            ? 'From ${fmt(tempStart!)}'
                            : 'Tap a start date',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: const Color(0xFF334D8F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setSheetState(() {
                            if (viewMonth == 1) {
                              viewMonth = 12;
                              viewYear--;
                            } else {
                              viewMonth--;
                            }
                          });
                        },
                        icon: const Icon(FontAwesomeIcons.chevronLeft,
                            size: 14, color: Color(0xFF334D8F)),
                      ),
                      Text(
                        '${_monthFull(viewMonth)} $viewYear',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setSheetState(() {
                            if (viewMonth == 12) {
                              viewMonth = 1;
                              viewYear++;
                            } else {
                              viewMonth++;
                            }
                          });
                        },
                        icon: const Icon(FontAwesomeIcons.chevronRight,
                            size: 14, color: Color(0xFF334D8F)),
                      ),
                    ],
                  ),
                  Row(
                    children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                        .map((d) => Expanded(
                              child: Center(
                                child: Text(
                                  d,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (_, idx) {
                      if (idx < firstWeekday) return const SizedBox();
                      final day = idx - firstWeekday + 1;
                      final cellDate = DateTime(viewYear, viewMonth, day);
                      final isStart = tempStart != null &&
                          DateUtils.isSameDay(cellDate, tempStart);
                      final isEnd = tempEnd != null &&
                          DateUtils.isSameDay(cellDate, tempEnd);
                      final inRange = tempStart != null &&
                          tempEnd != null &&
                          cellDate.isAfter(tempStart!) &&
                          cellDate.isBefore(tempEnd!);

                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            if (tempStart == null ||
                                (tempStart != null && tempEnd != null)) {
                              tempStart = cellDate;
                              tempEnd = null;
                            } else {
                              if (cellDate.isBefore(tempStart!)) {
                                tempEnd = tempStart;
                                tempStart = cellDate;
                              } else {
                                tempEnd = cellDate;
                              }
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isStart || isEnd
                                ? const Color(0xFF334D8F)
                                : inRange
                                    ? const Color(0xFF334D8F).withOpacity(0.12)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: isStart || isEnd
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isStart || isEnd
                                    ? Colors.white
                                    : inRange
                                        ? const Color(0xFF334D8F)
                                        : Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _startDate = null;
                              _endDate = null;
                            });
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF334D8F)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Clear',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334D8F),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: tempStart == null
                              ? null
                              : () {
                                  setState(() {
                                    _startDate = tempStart;
                                    _endDate = tempEnd;
                                  });
                                  Navigator.pop(ctx);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334D8F),
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSearchSheet() {
    final controller = TextEditingController(text: _searchQuery);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Search Transactions',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: GoogleFonts.montserrat(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by name, category, amount…',
                    hintStyle: GoogleFonts.montserrat(
                        fontSize: 13, color: Colors.grey[400]),
                    prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass,
                        size: 16, color: Color(0xFF334D8F)),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.clear, size: 18, color: Colors.grey),
                      onPressed: () => controller.clear(),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = controller.text.trim();
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334D8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Search',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdvancedFiltersSheet() {
    String tempSort = _sortBy;
    RangeValues tempRange = _amountRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Advanced Filters',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            tempSort = 'Date (Newest)';
                            tempRange = const RangeValues(0, 50000);
                          });
                        },
                        child: Text(
                          'Reset All',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sort By',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sortOptions.map((opt) {
                      final sel = tempSort == opt;
                      return GestureDetector(
                        onTap: () => setSheetState(() => tempSort = opt),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFF334D8F)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            opt,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Range',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '₹${tempRange.start.toInt()} – ₹${tempRange.end.toInt()}',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334D8F),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(ctx).copyWith(
                      activeTrackColor: const Color(0xFF334D8F),
                      inactiveTrackColor:
                          const Color(0xFF334D8F).withOpacity(0.15),
                      thumbColor: const Color(0xFF334D8F),
                      overlayColor: const Color(0xFF334D8F).withOpacity(0.1),
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 8),
                    ),
                    child: RangeSlider(
                      values: tempRange,
                      min: 0,
                      max: 50000,
                      divisions: 100,
                      onChanged: (v) => setSheetState(() => tempRange = v),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = tempSort;
                          _amountRange = tempRange;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF334D8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF334D8F),
        title: Text(
          'Transactions',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: _showAdvancedFiltersSheet,
                icon: const Icon(FontAwesomeIcons.sliders,
                    color: Colors.white, size: 20),
              ),
              if (_activeAdvancedFilters > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_activeAdvancedFilters',
                        style: GoogleFonts.montserrat(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: _showSearchSheet,
              ),
              if (_searchQuery.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _transactionSummary(),
            const SizedBox(height: 20),
            _transactionFilters(),
            const SizedBox(height: 20),
            _transactionList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _transactionSummary() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Padding(padding: EdgeInsets.all(7.5)),
    );
  }

  Widget _transactionFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          //Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //  children: [
          //    Text(
          //      'Recent Transactions',
          //      style: GoogleFonts.montserrat(
          //        fontSize: 18,
          //        color: Colors.grey[800],
          //        fontWeight: FontWeight.w600,
          //      ),
          //    ),
          //    GestureDetector(
          //      onTap: showDateRangeSheet,
          //      child: Container(
          //        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //        decoration: BoxDecoration(
          //          color: _startDate != null
          //              ? const Color(0xFF334D8F).withOpacity(0.08)
          //              : Colors.white,
          //          borderRadius: BorderRadius.circular(20),
          //          border: _startDate != null
          //              ? Border.all(
          //                  color: const Color(0xFF334D8F).withOpacity(0.4),
          //                  width: 1.2,
          //                )
          //              : null,
          //          boxShadow: [
          //            BoxShadow(
          //              blurRadius: 10,
          //              spreadRadius: 1,
          //              color: Colors.black.withOpacity(0.05),
          //            ),
          //          ],
          //        ),
          //        child: Row(
          //          children: [
          //            Text(
          //              _dateLabel,
          //              style: GoogleFonts.montserrat(
          //                fontSize: 12,
          //                color: const Color(0xFF334D8F),
          //                fontWeight: FontWeight.w600,
          //              ),
          //            ),
          //            const SizedBox(width: 5),
          //            const Icon(
          //              FontAwesomeIcons.chevronDown,
          //              size: 12,
          //              color: Color(0xFF334D8F),
          //            ),
          //          ],
          //        ),
          //      ),
          //    ),
          //  ],
          //),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(FontAwesomeIcons.magnifyingGlass,
                    size: 12, color: Color(0xFF334D8F)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '"$_searchQuery"',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: const Color(0xFF334D8F),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => setState(() => _searchQuery = ''),
                  child: const Icon(Icons.close, size: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions
                  .map((f) => _buildFilterChip(f, _selectedFilter == f))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF334D8F),
        checkmarkColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (_) => setState(() => _selectedFilter = label),
      ),
    );
  }

  Widget _transactionList() {
    final transactions = _filtered;

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(FontAwesomeIcons.fileCircleXmark,
                  size: 40, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No transactions found',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try adjusting your filters or search query.',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final Map<String, List<TransactionItem>> grouped = {};
    for (final t in transactions) {
      final key = groupKey(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries.expand((entry) {
          return [
            dateDivider(entry.key),
            ...entry.value.map((t) => transactionItem(
                  t.title,
                  t.subtitle,
                  t.amount,
                  t.time,
                  t.icon,
                  t.color,
                  isDebit: t.isDebit,
                )),
          ];
        }).toList(),
      ),
    );
  }

  String groupKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) {
      return 'Today, ${date.day} ${monthShort(date.month)} ${date.year}';
    }
    if (d == yesterday) {
      return 'Yesterday, ${date.day} ${monthShort(date.month)} ${date.year}';
    }
    return '${date.day} ${monthShort(date.month)} ${date.year}';
  }

  Widget dateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(color: Colors.grey[300], thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget transactionItem(String title, String subtitle, String amount,
      String time, IconData icon, Color color,
      {required bool isDebit}) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDebit ? Colors.red[600] : Colors.green[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
