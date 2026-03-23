import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatWithAI extends StatefulWidget {
  const ChatWithAI({super.key});
  @override
  State<ChatWithAI> createState() => _ChatWithAIState();
}

class _ChatWithAIState extends State<ChatWithAI>
    with SingleTickerProviderStateMixin {
  late Animation<double> pulseAnimation;
  late AnimationController pulseController;
  final TextEditingController notifyController = TextEditingController();

  final List<FeatureItem> _features = const [
    FeatureItem(
      title: 'Stock Insights',
      color: Color(0xFF4CAF50),
      icon: FontAwesomeIcons.chartLine,
      subtitle: 'Real-time market analysis\n& investment advice',
    ),
    FeatureItem(
      title: 'Expense Planning',
      color: Color(0xFF2196F3),
      icon: FontAwesomeIcons.piggyBank,
      subtitle: 'Smart budgeting &\nsavings strategies',
    ),
    FeatureItem(
      title: 'AI Advisor',
      color: Color(0xFF9C27B0),
      icon: FontAwesomeIcons.robot,
      subtitle: 'Personalised financial\nguidance 24/7',
    ),
    FeatureItem(
      title: 'Tax Planning',
      color: Color(0xFFFF9800),
      icon: FontAwesomeIcons.fileInvoiceDollar,
      subtitle: 'Optimise returns &\nreduce liabilities',
    ),
  ];

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    pulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    pulseController.dispose();
    notifyController.dispose();
    super.dispose();
  }

  void showNotifySheet() {
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
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334D8F).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    size: 25,
                    FontAwesomeIcons.bell,
                    color: Color(0xFF334D8F),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Get Notified',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.center,
                  'Be the first to know when AI Chat launches.\nWe\'ll send you a heads-up.',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: notifyController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.montserrat(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: const Icon(
                      size: 15,
                      FontAwesomeIcons.envelope,
                      color: Color(0xFF334D8F),
                    ),
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
                        width: 1.5,
                        color: Color(0xFF334D8F),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = notifyController.text.trim();
                      Navigator.pop(ctx);
                      notifyController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            email.isEmpty
                                ? 'You\'re on the waitlist!'
                                : 'We\'ll notify you at $email',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF334D8F),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(15),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334D8F),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Notify Me',
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
          'AI Finance Chat',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Coming Soon',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(height: 25),
            featuresSection(),
            const SizedBox(height: 25),
            mockChatPreview(),
            const SizedBox(height: 25),
            notifyButton(),
            const SizedBox(height: 30),
          ],
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          ScaleTransition(
            scale: pulseAnimation,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    spreadRadius: 4,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ],
              ),
              child: const Icon(
                size: 38,
                color: Colors.white,
                FontAwesomeIcons.robot,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Your AI Finance Advisor',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            'Ask anything about stocks, budgets,\ntax, and investments — all in one chat.',
            style: GoogleFonts.montserrat(
              height: 1.5,
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
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
                    size: 18,
                    color: Colors.white,
                    FontAwesomeIcons.screwdriverWrench,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We\'re building something great',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'AI Chat is under development.',
                        style: GoogleFonts.montserrat(
                          height: 1.4,
                          fontSize: 11,
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
    );
  }

  Widget featuresSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you can do',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
              crossAxisSpacing: 15,
            ),
            itemCount: _features.length,
            itemBuilder: (_, i) => featureCard(_features[i]),
          ),
        ],
      ),
    );
  }

  Widget featureCard(FeatureItem f) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        border: Border.all(color: f.color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: f.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f.icon, size: 17, color: f.color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                f.title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                f.subtitle,
                style: GoogleFonts.montserrat(
                  height: 1.4,
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mockChatPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF334D8F),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          size: 16,
                          color: Colors.white,
                          FontAwesomeIcons.robot,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ClearPay AI',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Your personal finance assistant',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF69F0AE),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Online',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      aiBubble(
                          'Hello! I\'m your AI finance advisor. How can I help you today?'),
                      const SizedBox(height: 10),
                      userBubble('Should I invest in index funds right now?'),
                      const SizedBox(height: 10),
                      aiBubble(
                        'Based on your spending pattern, you have ₹8,200 available to invest. Index funds are a great long-term option — here\'s what I recommend…',
                      ),
                      const SizedBox(height: 10),
                      userBubble('How can I reduce my monthly expenses?'),
                      const SizedBox(height: 10),
                      aiBubble(
                        'I noticed your dining & entertainment spending is 34% above your goal. Reducing it by ₹1,500/month could save ₹18,000 annually',
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ask about your finances…',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(FontAwesomeIcons.paperPlane,
                                size: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334D8F),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF334D8F).withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FontAwesomeIcons.lock,
                              size: 11, color: Colors.white),
                          const SizedBox(width: 7),
                          Text(
                            'Available soon',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aiBubble(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF334D8F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(FontAwesomeIcons.robot,
              size: 13, color: Color(0xFF334D8F)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userBubble(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF334D8F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF334D8F).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(FontAwesomeIcons.user,
              size: 12, color: Color(0xFF334D8F)),
        ),
      ],
    );
  }

  Widget notifyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Development Progress',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '72%',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334D8F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.72,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF334D8F)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Almost there! Core features are complete. Fine-tuning AI responses and security.',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey[500],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class FeatureItem {
  final Color color;
  final String title;
  final IconData icon;
  final String subtitle;
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.subtitle,
  });
}
