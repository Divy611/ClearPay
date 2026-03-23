import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MandateData {
  final String title;
  final String amount;
  final bool isActive;
  final String schedule;
  final String validity;
  final String priority;
  final String merchant;
  const MandateData({
    required this.title,
    required this.amount,
    required this.schedule,
    required this.validity,
    required this.isActive,
    required this.priority,
    required this.merchant,
  });
  MandateData copyWith({
    String? title,
    String? amount,
    bool? isActive,
    String? priority,
    String? validity,
    String? schedule,
    String? merchant,
  }) {
    return MandateData(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      schedule: schedule ?? this.schedule,
      merchant: merchant ?? this.merchant,
      validity: validity ?? this.validity,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
    );
  }
}

final List<MandateData> _initialMandates = [
  MandateData(
    title: 'Electricity Bill',
    merchant: 'Power Distribution Company',
    amount: 'Up to ₹2,000/month',
    schedule: 'Debit on 5th of every month',
    validity: 'Active till Dec 2025',
    isActive: true,
    priority: 'high',
  ),
  MandateData(
    title: 'Netflix Subscription',
    merchant: 'Netflix Entertainment Services',
    amount: 'Fixed ₹649/month',
    schedule: 'Debit on 15th of every month',
    validity: 'Active till Aug 2025',
    isActive: true,
    priority: 'medium',
  ),
  MandateData(
    title: 'Health Insurance',
    merchant: 'Star Health Insurance',
    amount: 'Fixed ₹5,000/quarter',
    schedule: 'Next debit on Jun 15, 2025',
    validity: 'Active till Jun 2026',
    isActive: true,
    priority: 'medium',
  ),
  MandateData(
    title: 'Gym Membership',
    merchant: 'Fitness First',
    amount: 'Fixed ₹1,800/month',
    schedule: 'Debit on 10th of every month',
    validity: 'Active till Sep 2025',
    isActive: true,
    priority: 'low',
  ),
  MandateData(
    title: 'Internet Bill',
    merchant: 'Airtel Broadband',
    amount: 'Up to ₹1,500/month',
    schedule: 'Debit on 7th of every month',
    validity: 'Active till Feb 2026',
    isActive: true,
    priority: 'low',
  ),
  MandateData(
    title: 'Old Mobile Plan',
    merchant: 'Jio Telecommunications',
    amount: 'Fixed ₹499/month',
    schedule: 'Last debited on Jan 10, 2025',
    validity: 'Expired on Feb 2025',
    isActive: false,
    priority: 'low',
  ),
  MandateData(
    title: 'Magazine Subscription',
    merchant: "Reader's Digest",
    amount: 'Fixed ₹1,200/year',
    schedule: 'Last debited on Dec 5, 2024',
    validity: 'Expired on Dec 2024',
    isActive: false,
    priority: 'low',
  ),
  MandateData(
    title: "Previous Gym",
    merchant: "Gold's Gym",
    amount: 'Fixed ₹2,200/month',
    schedule: 'Last debited on Nov 15, 2024',
    validity: 'Expired on Dec 2024',
    isActive: false,
    priority: 'low',
  ),
];

class Mandates extends StatefulWidget {
  const Mandates({super.key});
  @override
  State<Mandates> createState() => _MandatesState();
}

class _MandatesState extends State<Mandates> {
  late List<MandateData> _mandates;
  @override
  void initState() {
    super.initState();
    _mandates = List.from(_initialMandates);
  }

  List<MandateData> get _active => _mandates.where((m) => m.isActive).toList();

  List<MandateData> get _expired =>
      _mandates.where((m) => !m.isActive).toList();

  void showRevokeSheet(MandateData mandate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[50],
              ),
              child: Icon(
                size: 26,
                color: Colors.red[600],
                FontAwesomeIcons.triangleExclamation,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Revoke Mandate?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You are about to revoke the auto-debit mandate for',
              style:
                  GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              mandate.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              mandate.merchant,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red[100]!),
              ),
              child: Row(
                children: [
                  Icon(
                    size: 14,
                    color: Colors.red[400],
                    FontAwesomeIcons.circleInfo,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Future scheduled payments will be cancelled. This action cannot be undone.',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final idx = _mandates.indexOf(mandate);
                        if (idx != -1) {
                          _mandates[idx] = mandate.copyWith(
                            isActive: false,
                            validity: 'Expired on ${currentMonthYear()}',
                            priority: 'low',
                          );
                        }
                      });
                      Navigator.pop(ctx);
                      showSnackbar('${mandate.title} mandate revoked.',
                          Colors.red[600]!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Yes, Revoke',
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
      ),
    );
  }

  void showRenewSheet(MandateData mandate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF334D8F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(FontAwesomeIcons.arrowsRotate,
                  color: Color(0xFF334D8F), size: 24),
            ),
            const SizedBox(height: 15),
            Text(
              'Renew Mandate?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Reactivate the auto-debit mandate for',
              style:
                  GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              mandate.title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              mandate.merchant,
              style:
                  GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.circleInfo,
                      size: 14, color: Colors.blue[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'The mandate will be renewed with the same terms. You can revoke it anytime.',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final idx = _mandates.indexOf(mandate);
                        if (idx != -1) {
                          _mandates[idx] = mandate.copyWith(
                            isActive: true,
                            validity: 'Active till Dec 2026',
                            priority: 'low',
                          );
                        }
                      });
                      Navigator.pop(ctx);
                      showSnackbar('${mandate.title} mandate renewed.',
                          const Color(0xFF334D8F));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334D8F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Yes, Renew',
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
      ),
    );
  }

  void _showDetailSheet(MandateData mandate) {
    final priorityColor = _priorityColor(mandate.priority, mandate.isActive);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: sheetHandle()),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: mandate.isActive
                        ? priorityColor.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getIconForTitle(mandate.title),
                    color: mandate.isActive ? priorityColor : Colors.grey[500],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mandate.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        mandate.merchant,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        mandate.isActive ? Colors.green[50] : Colors.grey[200],
                  ),
                  child: Text(
                    mandate.isActive ? 'Active' : 'Expired',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: mandate.isActive
                          ? Colors.green[600]
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            detailRow(
                FontAwesomeIcons.indianRupeeSign, 'Amount', mandate.amount),
            const SizedBox(height: 10),
            detailRow(
                FontAwesomeIcons.calendarDays, 'Schedule', mandate.schedule),
            const SizedBox(height: 10),
            detailRow(FontAwesomeIcons.clock, 'Validity', mandate.validity),
            const SizedBox(height: 10),
            detailRow(
              FontAwesomeIcons.chartBar,
              'Priority',
              mandate.priority[0].toUpperCase() + mandate.priority.substring(1),
              valueColor: priorityColor,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: mandate.isActive
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        showRevokeSheet(mandate);
                      },
                      icon: const Icon(FontAwesomeIcons.ban,
                          size: 14, color: Colors.white),
                      label: Text(
                        'Revoke Mandate',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        showRenewSheet(mandate);
                      },
                      icon: const Icon(
                        size: 14,
                        color: Colors.white,
                        FontAwesomeIcons.arrowsRotate,
                      ),
                      label: Text(
                        'Renew Mandate',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF334D8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddMandateSheet() {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final merchantCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final scheduleCtrl = TextEditingController();
    final validityCtrl = TextEditingController();
    String selectedPriority = 'low';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: sheetHandle()),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Add New Mandate',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      formField(titleCtrl, 'Mandate Title',
                          FontAwesomeIcons.fileContract,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Title is required'
                              : null),
                      const SizedBox(height: 10),
                      formField(merchantCtrl, 'Merchant / Provider',
                          FontAwesomeIcons.buildingColumns,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Merchant is required'
                              : null),
                      const SizedBox(height: 10),
                      formField(amountCtrl, 'Amount (e.g. Fixed ₹649/month)',
                          FontAwesomeIcons.indianRupeeSign,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Amount is required'
                              : null),
                      const SizedBox(height: 10),
                      formField(
                          scheduleCtrl,
                          'Schedule (e.g. Debit on 5th of every month)',
                          FontAwesomeIcons.calendarDays,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Schedule is required'
                              : null),
                      const SizedBox(height: 10),
                      formField(
                          validityCtrl,
                          'Validity (e.g. Active till Dec 2026)',
                          FontAwesomeIcons.clock,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Validity is required'
                              : null),
                      const SizedBox(height: 15),
                      Text(
                        'Priority',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: ['low', 'medium', 'high'].map((p) {
                          final isSelected = selectedPriority == p;
                          final pColor = _priorityColor(p, true);
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setSheetState(
                                () => selectedPriority = p,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: p != 'high' ? 8 : 0,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? pColor.withOpacity(0.15)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1.5,
                                    color: isSelected
                                        ? pColor
                                        : const Color.fromRGBO(0, 0, 0, 0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    p[0].toUpperCase() + p.substring(1),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? pColor
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final newMandate = MandateData(
                                isActive: true,
                                priority: selectedPriority,
                                title: titleCtrl.text.trim(),
                                amount: amountCtrl.text.trim(),
                                merchant: merchantCtrl.text.trim(),
                                schedule: scheduleCtrl.text.trim(),
                                validity: validityCtrl.text.trim(),
                              );
                              setState(() => _mandates.add(newMandate));
                              Navigator.pop(ctx);
                              showSnackbar(
                                '${newMandate.title} mandate added.',
                                const Color(0xFF334D8F),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334D8F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Add Mandate',
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
              ),
            ),
          ),
        );
      },
    );
  }

  Color _priorityColor(String priority, bool isActive) {
    switch (priority) {
      case 'high':
        return Colors.red[600]!;
      case 'medium':
        return Colors.orange[600]!;
      default:
        return isActive ? Colors.green[600]! : Colors.grey[600]!;
    }
  }

  String currentMonthYear() {
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

  Widget sheetHandle() => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      );

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
          ),
        ),
      ],
    );
  }

  Widget formField(TextEditingController controller, String hint, IconData icon,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: GoogleFonts.montserrat(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 12,
          color: Colors.grey[400],
        ),
        prefixIcon: Icon(icon, size: 15, color: const Color(0xFF334D8F)),
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
          borderSide: const BorderSide(color: Color(0xFF334D8F), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
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
          'Mandates',
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
                        Tab(text: 'Active (${_active.length})'),
                        Tab(text: 'Expired (${_expired.length})'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        activeMandatesTab(),
                        expiredMandatesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddMandateSheet,
        backgroundColor: const Color(0xFF334D8F),
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
                      FontAwesomeIcons.fileContract,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_active.length} Active Mandate${_active.length == 1 ? '' : 's'}',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Automatic payments authorized by you',
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

  Widget activeMandatesTab() {
    if (_active.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: emptyState(
          'No active mandates',
          'Tap the + button below to add a new mandate.',
          FontAwesomeIcons.fileContract,
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _active
            .map((m) => mandateCard(
                  m.title,
                  m.merchant,
                  m.amount,
                  m.schedule,
                  m.validity,
                  m.isActive,
                  m.priority,
                  mandate: m,
                ))
            .toList(),
      ),
    );
  }

  Widget expiredMandatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._expired.map((m) => mandateCard(
                m.title,
                m.merchant,
                m.amount,
                m.schedule,
                m.validity,
                m.isActive,
                m.priority,
                mandate: m,
              )),
          emptyState(
            'No more expired mandates',
            'Older expired mandates are automatically removed after 6 months.',
            FontAwesomeIcons.clockRotateLeft,
          ),
        ],
      ),
    );
  }

  Widget mandateCard(
    String title,
    String merchant,
    String amount,
    String schedule,
    String validity,
    bool isActive,
    String priority, {
    MandateData? mandate,
  }) {
    Color priorityColor = _priorityColor(priority, isActive);

    return GestureDetector(
      onTap: mandate != null ? () => _showDetailSheet(mandate) : null,
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
            color:
                isActive ? priorityColor.withOpacity(0.3) : Colors.grey[300]!,
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
                      color: isActive
                          ? priorityColor.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      getIconForTitle(title),
                      size: 24,
                      color: isActive ? priorityColor : Colors.grey[600],
                    ),
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
                        ),
                        const SizedBox(height: 5),
                        Text(
                          merchant,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isActive ? Colors.green[50] : Colors.grey[200],
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Expired',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.green[600] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.indianRupeeSign,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          'Amount:',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          amount,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.calendarDays,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          'Schedule:',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            schedule,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[800],
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? priorityColor.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.clock,
                            size: 12,
                            color: isActive ? priorityColor : Colors.grey[600]),
                        const SizedBox(width: 5),
                        Text(
                          validity,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? priorityColor : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (isActive && mandate != null)
                    OutlinedButton(
                      onPressed: () => showRevokeSheet(mandate),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[600]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                      child: Text(
                        'Revoke',
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (!isActive && mandate != null)
                    OutlinedButton(
                      onPressed: () => showRenewSheet(mandate),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF334D8F),
                        side: const BorderSide(color: Color(0xFF334D8F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                      child: Text(
                        'Renew',
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.w600),
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

  Widget emptyState(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
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
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData getIconForTitle(String title) {
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
}
