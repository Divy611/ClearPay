import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/requestState.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:clearpay/transactions/requestModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Request extends StatefulWidget {
  const Request({super.key});
  @override
  State<Request> createState() => RequestState();
}

class RequestState extends State<Request> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchRequests());
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> fetchRequests() async {
    setState(() => isLoading = true);
    final auth = Provider.of<AuthState>(context, listen: false);
    final requests = Provider.of<RequestsState>(context, listen: false);
    await requests.fetchRequests(auth.userModel!.userId!);
    if (mounted) setState(() => isLoading = false);
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        margin: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white),
        ),
      ),
    );
  }

  Widget sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  void showNewRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UserSearchSheet(
        onUserSelected: (user) {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateRequestScreen(
                recipientId: user.userId!,
                recipientName: user.displayName ?? 'Unknown',
              ),
            ),
          ).then((_) => fetchRequests());
        },
      ),
    );
  }

  void showCancelConfirmSheet(String requestId, String recipientName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[50],
              ),
              child: Icon(
                size: 26,
                FontAwesomeIcons.ban,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Cancel Request?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your request to $recipientName will be cancelled.',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      'Keep',
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
                    onPressed: () {
                      Navigator.pop(ctx);
                      handleCancelRequest(requestId);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel Request',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
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

  void showDeclineConfirmSheet(String requestId, String requesterName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange[50],
              ),
              child: Icon(
                size: 28,
                color: Colors.orange[600],
                FontAwesomeIcons.circleXmark,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Decline Request?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              '$requesterName will be notified that you declined.',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      'Back',
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
                    onPressed: () {
                      Navigator.pop(ctx);
                      handleDeclineRequest(requestId);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.orange[600],
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Decline',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
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

  void showPayConfirmSheet(RequestModel request) {
    final auth = Provider.of<AuthState>(context, listen: false);
    final balance = auth.userModel?.balance ?? 0;
    final amount = double.tryParse(request.amount ?? '0') ?? 0;
    final hasEnough = balance >= amount;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF334D8F).withOpacity(0.1),
              ),
              child: const Icon(
                size: 25,
                color: Color(0xFF334D8F),
                FontAwesomeIcons.moneyBillTransfer,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Confirm Payment',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              'You are about to pay ${request.requesterName}',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  summaryCol(
                    'Your Balance',
                    '₹$balance',
                    Colors.grey[800]!,
                    align: CrossAxisAlignment.start,
                  ),
                  summaryCol(
                    'Amount',
                    '₹${request.amount}',
                    const Color(0xFF334D8F),
                    align: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hasEnough ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasEnough ? Colors.green[100]! : Colors.red[100]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    size: 14,
                    color: hasEnough ? Colors.green[400] : Colors.red[400],
                    hasEnough
                        ? FontAwesomeIcons.circleInfo
                        : FontAwesomeIcons.triangleExclamation,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hasEnough
                          ? 'Balance after payment: ₹${(balance - amount).toInt()}'
                          : 'Insufficient balance. You need ₹${(amount - balance).toStringAsFixed(0)} more.',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: hasEnough ? Colors.green[700] : Colors.red[700],
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
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      'Cancel',
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
                    onPressed: hasEnough
                        ? () {
                            Navigator.pop(ctx);
                            handlePayRequest(request);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334D8F),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                    child: Text(
                      'Pay ₹${request.amount}',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
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

  Widget summaryCol(String label, String value, Color valueColor,
      {required CrossAxisAlignment align}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500]),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Future<void> handleCancelRequest(String requestId) async {
    final requests = Provider.of<RequestsState>(context, listen: false);
    try {
      await requests.updateRequestStatus(requestId, 'declined');
      await fetchRequests();
      showSnackbar('Request cancelled.', Colors.green[700]!);
    } catch (e) {
      showSnackbar('Failed to cancel: $e', Colors.red[600]!);
    }
  }

  Future<void> handleDeclineRequest(String requestId) async {
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    try {
      await requestsState.updateRequestStatus(requestId, 'declined');
      await fetchRequests();
      showSnackbar('Request declined.', Colors.orange[700]!);
    } catch (e) {
      showSnackbar('Failed to decline: $e', Colors.red[600]!);
    }
  }

  Future<void> handlePayRequest(RequestModel request) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    final transactionState =
        Provider.of<TransactionState>(context, listen: false);
    try {
      await requestsState.processPayment(request, authState, transactionState);
      await fetchRequests();
      showSnackbar('Payment of ₹${request.amount} sent! ✓', Colors.green[700]!);
    } catch (e) {
      showSnackbar(e.toString(), Colors.red[600]!);
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays == 0) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int m) => const [
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

  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<RequestsState>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF334D8F),
        title: Text('Money Requests',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF334D8F)))
          : Column(
              children: [
                tabBar(requests),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      pendingRequestsTab(requests),
                      completedRequestsTab(requests),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNewRequestSheet,
        backgroundColor: const Color(0xFF334D8F),
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget tabBar(RequestsState requestsState) {
    final pendingCount = requestsState.pendingSentRequests.length +
        requestsState.pendingReceivedRequests.length;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    size: 16,
                    color: Colors.white,
                    FontAwesomeIcons.clockRotateLeft,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$pendingCount Pending Request${pendingCount == 1 ? '' : 's'}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TabBar(
            indicatorWeight: 3,
            controller: tabController,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
          ),
        ],
      ),
    );
  }

  Widget pendingRequestsTab(RequestsState requestsState) {
    return RefreshIndicator(
      onRefresh: fetchRequests,
      color: const Color(0xFF334D8F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Requests From You'),
            const SizedBox(height: 15),
            requestsState.pendingSentRequests.isEmpty
                ? emptyState(
                    'No pending requests sent',
                    'You haven\'t sent any payment requests yet.',
                    FontAwesomeIcons.paperPlane,
                  )
                : Column(
                    children: requestsState.pendingSentRequests
                        .map((request) => requestCard(
                              request.recipientName!,
                              'Request ID: ${request.id!.substring(0, 8)}',
                              '₹${request.amount}',
                              request.note ?? 'No note',
                              formatDate(request.createdAt!),
                              isPending: true,
                              isFromYou: true,
                              onCancel: () => showCancelConfirmSheet(
                                  request.id!, request.recipientName!),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 25),
            sectionTitle('Requests To You'),
            const SizedBox(height: 15),
            requestsState.pendingReceivedRequests.isEmpty
                ? emptyState(
                    'No pending requests received',
                    'You don\'t have any payment requests to handle.',
                    FontAwesomeIcons.checkCircle,
                  )
                : Column(
                    children: requestsState.pendingReceivedRequests
                        .map((request) => requestCard(
                              request.requesterName!,
                              'Request ID: ${request.id!.substring(0, 8)}',
                              '₹${request.amount}',
                              request.note ?? 'No note',
                              formatDate(request.createdAt!),
                              isPending: true,
                              isFromYou: false,
                              onDecline: () => showDeclineConfirmSheet(
                                  request.id!, request.requesterName!),
                              onPay: () => showPayConfirmSheet(request),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget completedRequestsTab(RequestsState requestsState) {
    return RefreshIndicator(
      onRefresh: fetchRequests,
      color: const Color(0xFF334D8F),
      child: requestsState.completedRequests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.clockRotateLeft,
                      size: 50, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text('No completed requests yet',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Recent Activity'),
                  const SizedBox(height: 15),
                  ...requestsState.completedRequests.map((request) {
                    final isFromYou = request.requesterId ==
                        Provider.of<AuthState>(context, listen: false)
                            .userModel!
                            .userId;
                    final isAccepted = request.status == 'completed';
                    return requestCard(
                      isFromYou
                          ? request.recipientName!
                          : request.requesterName!,
                      'Request ID: ${request.id!.substring(0, 8)}',
                      '₹${request.amount}',
                      request.note ?? 'No note',
                      '${isAccepted ? 'Completed' : 'Declined'} · ${formatDate(request.createdAt!)}',
                      isPending: false,
                      isFromYou: isFromYou,
                      isAccepted: isAccepted,
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        color: Colors.grey[800],
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget requestCard(
    String name,
    String requestId,
    String amount,
    String note,
    String time, {
    required bool isPending,
    required bool isFromYou,
    bool isAccepted = false,
    VoidCallback? onCancel,
    VoidCallback? onDecline,
    VoidCallback? onPay,
  }) {
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
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF334D8F).withOpacity(0.1),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: const Color(0xFF334D8F),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 5),
                      Text(requestId,
                          style: GoogleFonts.montserrat(
                              fontSize: 12, color: Colors.grey[600])),
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
                        color:
                            isFromYou ? Colors.orange[600] : Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(time,
                        style: GoogleFonts.montserrat(
                            fontSize: 10, color: Colors.grey[500])),
                  ],
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
                children: [
                  Icon(
                    size: 14,
                    color: Colors.grey[600],
                    FontAwesomeIcons.noteSticky,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isPending) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  if (isFromYou)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancel Request',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDecline,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Decline',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPay,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF334D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Pay Now',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isAccepted ? Colors.green[50] : Colors.red[50],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      size: 12,
                      color: isAccepted ? Colors.green[600] : Colors.red[600],
                      isAccepted
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.xmark,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isAccepted ? 'Completed' : 'Declined',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAccepted ? Colors.green[600] : Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget emptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.green[400]),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchSheet extends StatefulWidget {
  final void Function(UserModel user) onUserSelected;
  const UserSearchSheet({required this.onUserSelected});
  @override
  State<UserSearchSheet> createState() => UserSearchSheetState();
}

class UserSearchSheetState extends State<UserSearchSheet> {
  final TextEditingController searchController = TextEditingController();
  List<UserModel> _results = [];
  bool _isSearching = false;

  DateTime? _lastSearchTime;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      if (mounted) {
        setState(() {
          _results = [];
          _isSearching = false;
        });
      }
      return;
    }
    final searchTime = DateTime.now();
    _lastSearchTime = searchTime;
    if (mounted) setState(() => _isSearching = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted || _lastSearchTime != searchTime) return;
    final authState = Provider.of<AuthState>(context, listen: false);
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    final results =
        await requestsState.searchUsers(trimmed, authState.userModel!.userId!);
    if (!mounted || _lastSearchTime != searchTime) return;
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Request Money From',
              style: GoogleFonts.montserrat(
                fontSize: 17,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                autofocus: true,
                onChanged: search,
                style: GoogleFonts.montserrat(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by name…',
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14, color: Colors.grey[400]),
                  prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass,
                      size: 16, color: Color(0xFF334D8F)),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close,
                              size: 16, color: Colors.grey[400]),
                          onPressed: () {
                            searchController.clear();
                            search('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF334D8F)),
                ),
              )
            else if (_results.isEmpty &&
                searchController.text.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No users found for "${searchController.text.trim()}"',
                    style: GoogleFonts.montserrat(
                        fontSize: 13, color: Colors.grey[500]),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey[100]),
                  itemBuilder: (_, i) {
                    final user = _results[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF334D8F).withOpacity(0.1),
                        child: Text(
                          (user.displayName ?? '?')[0].toUpperCase(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF334D8F)),
                        ),
                      ),
                      title: Text(user.displayName ?? 'Unknown',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey[800])),
                      subtitle: Text(user.email ?? '',
                          style: GoogleFonts.montserrat(
                              fontSize: 12, color: Colors.grey[500])),
                      trailing: const Icon(FontAwesomeIcons.chevronRight,
                          size: 14, color: Color(0xFF334D8F)),
                      onTap: () => widget.onUserSelected(user),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CreateRequestScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const CreateRequestScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
  });

  @override
  State<CreateRequestScreen> createState() => CreateRequestScreenState();
}

class CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  bool isProcessing = false;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> createRequest() async {
    final rawAmount = amountController.text.trim();
    if (rawAmount.isEmpty) {
      showSnackbar('Please enter an amount.', Colors.red[600]!);
      return;
    }
    final amount = double.tryParse(rawAmount);
    if (amount == null || amount <= 0) {
      showSnackbar(
          'Please enter a valid amount greater than 0.', Colors.red[600]!);
      return;
    }
    if (amount > 1000000) {
      showSnackbar('Amount cannot exceed ₹10,00,000.', Colors.red[600]!);
      return;
    }
    setState(() => isProcessing = true);
    try {
      final req = Provider.of<RequestsState>(context, listen: false);
      final authState = Provider.of<AuthState>(context, listen: false);
      final request = RequestModel(
        amount: amount.toInt().toString(),
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
        requesterId: authState.userModel!.userId,
        requesterName: authState.userModel!.displayName,
        recipientId: widget.recipientId,
        recipientName: widget.recipientName,
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      );
      await req.createRequest(request);
      if (!mounted) return;
      Navigator.pop(context);
      showSnackbar(
          'Request for ₹${amount.toInt()} sent to ${widget.recipientName}!',
          Colors.green[700]!);
    } catch (e) {
      if (!mounted) return;
      setState(() => isProcessing = false);
      showSnackbar('Failed to send request: $e', Colors.red[600]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF334D8F),
        title: Text(
          'Request Money',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            size: 18,
            color: Colors.white,
            FontAwesomeIcons.chevronLeft,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.05))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF334D8F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.recipientName.isNotEmpty
                            ? widget.recipientName[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF334D8F)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Requesting from',
                          style: GoogleFonts.montserrat(
                              fontSize: 13, color: Colors.grey[600])),
                      const SizedBox(height: 5),
                      Text(widget.recipientName,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text('Amount',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.05))
                ],
              ),
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('₹',
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: const Color(0xFF334D8F),
                            fontWeight: FontWeight.w600)),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text('Note',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800])),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.05))
                ],
              ),
              child: TextField(
                controller: noteController,
                maxLines: 3,
                maxLength: 120,
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'What\'s this for?',
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isProcessing ? null : createRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF334D8F),
                  disabledBackgroundColor:
                      const Color(0xFF334D8F).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Send Request',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
  }
}
