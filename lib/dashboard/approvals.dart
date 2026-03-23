import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PendingApproval {
  final String title;
  final String amount;
  final String type;
  final String dueDate;
  final String priority;
  final String description;
  const PendingApproval({
    required this.type,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.priority,
    required this.description,
  });
}

class ApprovalHistoryItem {
  final String date;
  final String title;
  final String amount;
  final bool isApproved;
  final String monthGroup;
  final String description;
  const ApprovalHistoryItem({
    required this.date,
    required this.title,
    required this.amount,
    required this.isApproved,
    required this.monthGroup,
    required this.description,
  });
}

final List<PendingApproval> initialPending = [
  PendingApproval(
    title: 'Electricity Bill',
    description: 'Monthly payment to Power Corp',
    amount: '₹1,450.00',
    type: 'Recurring Payment',
    dueDate: 'Due in 2 days',
    priority: 'high',
  ),
  PendingApproval(
    title: 'Netflix Subscription',
    description: 'Monthly subscription',
    amount: '₹649.00',
    type: 'Recurring Payment',
    dueDate: 'Due tomorrow',
    priority: 'medium',
  ),
  PendingApproval(
    title: 'Gym Membership',
    description: 'Monthly membership fee',
    amount: '₹1,800.00',
    type: 'Recurring Payment',
    dueDate: 'Due in 5 days',
    priority: 'low',
  ),
];

final List<ApprovalHistoryItem> initialHistory = [
  ApprovalHistoryItem(
    title: 'Mobile Bill',
    description: 'Monthly payment to Airtel',
    amount: '₹999.00',
    date: 'Mar 10, 2025',
    isApproved: true,
    monthGroup: 'March 2025',
  ),
  ApprovalHistoryItem(
    title: 'Internet Bill',
    description: 'Monthly broadband payment',
    amount: '₹1,499.00',
    date: 'Mar 5, 2025',
    isApproved: true,
    monthGroup: 'March 2025',
  ),
  ApprovalHistoryItem(
    title: 'Magazine Subscription',
    description: 'Annual subscription renewal',
    amount: '₹2,400.00',
    date: 'Mar 3, 2025',
    isApproved: false,
    monthGroup: 'March 2025',
  ),
  ApprovalHistoryItem(
    title: 'Electricity Bill',
    description: 'Monthly payment to Power Corp',
    amount: '₹1,350.00',
    date: 'Feb 28, 2025',
    isApproved: true,
    monthGroup: 'February 2025',
  ),
  ApprovalHistoryItem(
    title: 'Netflix Subscription',
    description: 'Monthly subscription',
    amount: '₹649.00',
    date: 'Feb 15, 2025',
    isApproved: true,
    monthGroup: 'February 2025',
  ),
  ApprovalHistoryItem(
    title: 'Gym Membership',
    description: 'Monthly membership fee',
    amount: '₹1,800.00',
    date: 'Feb 10, 2025',
    isApproved: true,
    monthGroup: 'February 2025',
  ),
];

class Approvals extends StatefulWidget {
  const Approvals({super.key});
  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  late List<PendingApproval> _pending;
  late List<ApprovalHistoryItem> _history;
  @override
  void initState() {
    super.initState();
    _pending = List.from(initialPending);
    _history = List.from(initialHistory);
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red[600]!;
      case 'medium':
        return Colors.orange[600]!;
      default:
        return Colors.green[600]!;
    }
  }

  IconData iconForTitle(String title) {
    if (title.contains('Electricity')) return FontAwesomeIcons.bolt;
    if (title.contains('Netflix') || title.contains('Magazine')) {
      return FontAwesomeIcons.tv;
    }
    if (title.contains('Gym')) return FontAwesomeIcons.dumbbell;
    if (title.contains('Mobile') || title.contains('Internet')) {
      return FontAwesomeIcons.wifi;
    }
    if (title.contains('Insurance') || title.contains('Health')) {
      return FontAwesomeIcons.heartPulse;
    }
    return FontAwesomeIcons.fileInvoice;
  }

  String todayLabel() {
    final now = DateTime.now();
    const months = [
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
    ];
    return '${now.day} ${months[now.month]}, ${now.year}';
  }

  String currentMonthGroup() {
    final now = DateTime.now();
    const months = [
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
    ];
    return '${months[now.month]} ${now.year}';
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget sheetActionRow({
    Color? confirmTextColor,
    required String cancelLabel,
    required Color confirmColor,
    required String confirmLabel,
    required VoidCallback onCancel,
    required VoidCallback? onConfirm,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              cancelLabel,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              confirmLabel,
              style: GoogleFonts.montserrat(
                color: confirmTextColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showApproveSheet(PendingApproval item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                sheetHandle(),
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[50],
                  ),
                  child: Icon(
                    size: 28,
                    color: Colors.green[600],
                    FontAwesomeIcons.circleCheck,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Approve Payment?',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'You are about to approve',
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  item.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount',
                                style: GoogleFonts.montserrat(
                                    fontSize: 11, color: Colors.grey[500])),
                            const SizedBox(height: 5),
                            Text(
                              item.amount,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Due',
                                style: GoogleFonts.montserrat(
                                    fontSize: 11, color: Colors.grey[500])),
                            const SizedBox(height: 5),
                            Text(
                              item.dueDate,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _priorityColor(item.priority),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        size: 14,
                        color: Colors.green[400],
                        FontAwesomeIcons.circleInfo,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'The payment will be processed immediately after approval.',
                          style: GoogleFonts.montserrat(
                              fontSize: 11, color: Colors.green[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                sheetActionRow(
                  cancelLabel: 'Cancel',
                  onCancel: () => Navigator.pop(ctx),
                  confirmLabel: 'Approve',
                  confirmColor: Colors.green[600]!,
                  onConfirm: () {
                    setState(() {
                      _pending.remove(item);
                      _history.insert(
                        0,
                        ApprovalHistoryItem(
                          title: item.title,
                          description: item.description,
                          amount: item.amount,
                          date: todayLabel(),
                          isApproved: true,
                          monthGroup: currentMonthGroup(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    showSnackbar('${item.title} approved successfully.',
                        Colors.green[600]!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeclineSheet(PendingApproval item) {
    final reasonController = TextEditingController();
    String? selectedReason;
    const reasons = [
      'Incorrect amount',
      'Duplicate request',
      'Not authorized by me',
      'Wrong payee',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sheetHandle(),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(FontAwesomeIcons.circleXmark,
                          color: Colors.red[600], size: 28),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Decline Payment?',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      '${item.title} • ${item.amount}',
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Reason for declining',
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
                    children: reasons.map((r) {
                      final isSelected = selectedReason == r;
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedReason = r),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.red[50] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.red[400]!
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            r,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.red[600]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedReason == 'Other') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      style: GoogleFonts.montserrat(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter reason…',
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF334D8F), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  sheetActionRow(
                    cancelLabel: 'Cancel',
                    onCancel: () => Navigator.pop(ctx),
                    confirmLabel: 'Decline',
                    confirmColor: Colors.red[600]!,
                    onConfirm: selectedReason == null
                        ? null
                        : () {
                            setState(() {
                              _pending.remove(item);
                              _history.insert(
                                0,
                                ApprovalHistoryItem(
                                  title: item.title,
                                  description: item.description,
                                  amount: item.amount,
                                  date: todayLabel(),
                                  isApproved: false,
                                  monthGroup: currentMonthGroup(),
                                ),
                              );
                            });
                            Navigator.pop(ctx);
                            showSnackbar(
                                '${item.title} declined.', Colors.red[600]!);
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDetailSheet(PendingApproval item) {
    final priorityColor = _priorityColor(item.priority);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sheetHandle(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        size: 24,
                        color: priorityColor,
                        iconForTitle(item.title),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(item.description,
                              style: GoogleFonts.montserrat(
                                  fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pending',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                detailRow(
                    FontAwesomeIcons.indianRupeeSign, 'Amount', item.amount),
                const SizedBox(height: 12),
                detailRow(FontAwesomeIcons.arrowsRotate, 'Type', item.type),
                const SizedBox(height: 12),
                detailRow(FontAwesomeIcons.clock, 'Due', item.dueDate,
                    valueColor: priorityColor),
                const SizedBox(height: 12),
                detailRow(
                  FontAwesomeIcons.chartBar,
                  'Priority',
                  item.priority[0].toUpperCase() + item.priority.substring(1),
                  valueColor: priorityColor,
                ),
                const SizedBox(height: 25),
                sheetActionRow(
                  cancelLabel: 'Decline',
                  onCancel: () {
                    Navigator.pop(ctx);
                    showDeclineSheet(item);
                  },
                  confirmLabel: 'Approve',
                  confirmColor: const Color(0xFF334D8F),
                  onConfirm: () {
                    Navigator.pop(ctx);
                    showApproveSheet(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.grey[600]),
        ),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
          'Approve to Pay',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          header(),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: const Color(0xFF334D8F),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[700],
                      labelStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'Pending (${_pending.length})'),
                        Tab(text: 'History (${_history.length})'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [pendingApprovalsTab(), approvalHistoryTab()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      size: 20,
                      color: Colors.white,
                      FontAwesomeIcons.userCheck,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_pending.length} Pending Approval${_pending.length == 1 ? '' : 's'}',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _pending.isEmpty
                              ? 'All caught up! No pending approvals.'
                              : 'You have transactions waiting for your approval',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingApprovalsTab() {
    if (_pending.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    size: 48,
                    color: Colors.green[300],
                    FontAwesomeIcons.circleCheck,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'All caught up!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    textAlign: TextAlign.center,
                    'No pending approvals at the moment.',
                    style: GoogleFonts.montserrat(
                        fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _pending.map((item) => approvalCard(item)).toList(),
      ),
    );
  }

  Widget approvalHistoryTab() {
    final Map<String, List<ApprovalHistoryItem>> grouped = {};
    for (final item in _history) {
      grouped.putIfAbsent(item.monthGroup, () => []).add(item);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries.expand((entry) {
          return [
            dateDivider(entry.key),
            ...entry.value.map((item) => buildHistoryCard(
                  item.title,
                  item.description,
                  item.amount,
                  item.date,
                  item.isApproved,
                )),
          ];
        }).toList(),
      ),
    );
  }

  Widget approvalCard(PendingApproval item) {
    final priorityColor = _priorityColor(item.priority);
    return GestureDetector(
      onTap: () => showDetailSheet(item),
      child: Container(
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
          border: Border.all(
            width: 1,
            color: priorityColor.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      size: 22,
                      color: priorityColor,
                      iconForTitle(item.title),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.description,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.amount,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Type',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            item.type,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            size: 12,
                            color: priorityColor,
                            FontAwesomeIcons.clock,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              item.dueDate,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: priorityColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  OutlinedButton(
                    onPressed: () => showDeclineSheet(item),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[600],
                      side: BorderSide(color: Colors.red[600]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(76, 38),
                      padding: const EdgeInsets.all(10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Decline',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  ElevatedButton(
                    onPressed: () => showApproveSheet(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334D8F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(80, 38),
                      padding: const EdgeInsets.all(10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                    ),
                    child: Text(
                      'Approve',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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

  Widget buildHistoryCard(String title, String description, String amount,
      String date, bool isApproved) {
    final statusColor = isApproved ? Colors.green[600]! : Colors.red[600]!;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconForTitle(title), color: statusColor, size: 22),
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
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          amount,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          date,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isApproved ? 'Approved' : 'Declined',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(thickness: 1, color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
