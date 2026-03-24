import 'package:flutter/material.dart';
import 'package:clearpay/common/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RewardItem {
  final String id;
  bool isRedeemed;
  final Color color;
  final String title;
  final IconData icon;
  final int pointsCost;
  final String validity;
  final String category;
  final String description;

  RewardItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.color,
    required this.category,
    required this.validity,
    this.isRedeemed = false,
    required this.pointsCost,
    required this.description,
  });
}

class ActivityItem {
  final String id;
  final int points;
  final String title;
  final DateTime date;
  final IconData icon;
  final String subtitle;

  const ActivityItem({
    required this.id,
    required this.date,
    required this.icon,
    required this.title,
    required this.points,
    required this.subtitle,
  });

  bool get isEarned => points > 0;

  String get formattedPoints => isEarned ? '+$points points' : '$points points';

  String get formattedDate {
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month]} ${date.year}';
  }
}

class RewardCategory {
  final String name;
  final Color color;
  final IconData icon;
  const RewardCategory(
      {required this.name, required this.icon, required this.color});
}

extension TierExtension on RewardTier {
  String get label {
    switch (this) {
      case RewardTier.bronze:
        return 'Bronze';
      case RewardTier.silver:
        return 'Silver';
      case RewardTier.gold:
        return 'Gold';
      case RewardTier.platinum:
        return 'Platinum';
    }
  }

  int get threshold {
    switch (this) {
      case RewardTier.bronze:
        return 0;
      case RewardTier.silver:
        return 1000;
      case RewardTier.gold:
        return 2000;
      case RewardTier.platinum:
        return 3000;
    }
  }

  int get nextThreshold {
    switch (this) {
      case RewardTier.bronze:
        return 1000;
      case RewardTier.silver:
        return 2000;
      case RewardTier.gold:
        return 3000;
      case RewardTier.platinum:
        return 3000;
    }
  }

  RewardTier get next {
    switch (this) {
      case RewardTier.bronze:
        return RewardTier.silver;
      case RewardTier.silver:
        return RewardTier.gold;
      case RewardTier.gold:
        return RewardTier.platinum;
      case RewardTier.platinum:
        return RewardTier.platinum;
    }
  }

  Color get color {
    switch (this) {
      case RewardTier.bronze:
        return const Color(0xFFCD7F32);
      case RewardTier.silver:
        return const Color(0xFF9E9E9E);
      case RewardTier.gold:
        return Colors.amber;
      case RewardTier.platinum:
        return const Color(0xFF5B7FD4);
    }
  }
}

class Rewards extends StatefulWidget {
  const Rewards({super.key});
  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  int totalPoints = 2450;
  String selectedCategory = 'All';
  //final int _monthlyEarned = 125;
  late List<RewardItem> allRewards;
  late List<ActivityItem> activity;
  static const List<RewardCategory> categories = [
    RewardCategory(
      name: 'All',
      color: Color(0xFF334D8F),
      icon: FontAwesomeIcons.layerGroup,
    ),
    RewardCategory(
      name: 'Shopping',
      color: Color(0xFF1565C0),
      icon: FontAwesomeIcons.bagShopping,
    ),
    RewardCategory(
      name: 'Travel',
      color: Color(0xFFE65100),
      icon: FontAwesomeIcons.plane,
    ),
    RewardCategory(
      name: 'Food',
      color: Color(0xFFC62828),
      icon: FontAwesomeIcons.utensils,
    ),
    RewardCategory(
      name: 'Entertainment',
      color: Color(0xFF6A1B9A),
      icon: FontAwesomeIcons.film,
    ),
    RewardCategory(
      name: 'Utilities',
      color: Color(0xFF2E7D32),
      icon: FontAwesomeIcons.bolt,
    ),
  ];

  RewardTier get _tier {
    if (totalPoints >= 3000) return RewardTier.platinum;
    if (totalPoints >= 2000) return RewardTier.gold;
    if (totalPoints >= 1000) return RewardTier.silver;
    return RewardTier.bronze;
  }

  double get tierProgress {
    final tier = _tier;
    if (tier == RewardTier.platinum) return 1.0;
    final range = tier.nextThreshold - tier.threshold;
    final progress = totalPoints - tier.threshold;
    return (progress / range).clamp(0.0, 1.0);
  }

  int get _pointsToNext {
    final tier = _tier;
    if (tier == RewardTier.platinum) return 0;
    return tier.nextThreshold - totalPoints;
  }

  List<RewardItem> get filteredRewards => selectedCategory == 'All'
      ? allRewards
      : allRewards.where((r) => r.category == selectedCategory).toList();

  @override
  void initState() {
    super.initState();
    allRewards = [
      RewardItem(
        id: 'r1',
        pointsCost: 500,
        category: 'Shopping',
        title: 'Amazon Gift Card',
        color: Colors.blue[700]!,
        icon: FontAwesomeIcons.gift,
        validity: 'Valid till 30 Apr 2025',
        description: '10% off on your next purchase',
      ),
      RewardItem(
        id: 'r2',
        pointsCost: 750,
        title: 'Movie Tickets',
        color: Colors.red[600]!,
        category: 'Entertainment',
        icon: FontAwesomeIcons.ticket,
        validity: 'Valid till 15 May 2025',
        description: 'Buy 1 Get 1 Free on weekend shows',
      ),
      RewardItem(
        id: 'r3',
        pointsCost: 300,
        category: 'Food',
        title: 'Coffee Voucher',
        color: Colors.brown[600]!,
        icon: FontAwesomeIcons.mugHot,
        validity: 'Valid till 10 May 2025',
        description: 'Free coffee at Starbucks',
      ),
      RewardItem(
        id: 'r4',
        pointsCost: 1000,
        category: 'Travel',
        title: 'Flight Discount',
        color: Colors.orange[700]!,
        icon: FontAwesomeIcons.plane,
        validity: 'Valid till 01 Jun 2025',
        description: '₹500 off on domestic flights',
      ),
      RewardItem(
        id: 'r5',
        pointsCost: 400,
        category: 'Utilities',
        title: 'Cashback Voucher',
        color: Colors.green[700]!,
        icon: FontAwesomeIcons.bolt,
        validity: 'Valid till 20 May 2025',
        description: '5% cashback on utility bills',
      ),
    ];
    activity = [
      ActivityItem(
        id: 'a1',
        points: 50,
        title: 'Points Earned',
        subtitle: 'Online Shopping',
        date: DateTime(2025, 3, 15),
        icon: FontAwesomeIcons.bagShopping,
      ),
      ActivityItem(
        id: 'a2',
        points: -200,
        title: 'Redeemed',
        date: DateTime(2025, 3, 10),
        icon: FontAwesomeIcons.gift,
        subtitle: 'Amazon Gift Card',
      ),
      ActivityItem(
        id: 'a3',
        points: 75,
        title: 'Points Earned',
        subtitle: 'Bill Payment',
        date: DateTime(2025, 3, 5),
        icon: FontAwesomeIcons.fileInvoiceDollar,
      ),
      ActivityItem(
        id: 'a4',
        points: 100,
        title: 'Bonus Points',
        date: DateTime(2025, 3, 1),
        subtitle: 'Referral Reward',
        icon: FontAwesomeIcons.userPlus,
      ),
    ];
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: color,
        margin: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  void showRedeemSheet(RewardItem reward) {
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
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: reward.color.withOpacity(0.1),
                  ),
                  child: Icon(reward.icon, color: reward.color, size: 26),
                ),
                const SizedBox(height: 15),
                Text(
                  'Redeem Reward?',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  reward.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  reward.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
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
                            Text(
                              'Your Balance',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  size: 14,
                                  color: Colors.amber,
                                  FontAwesomeIcons.coins,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '$totalPoints pts',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Cost',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${reward.pointsCost} pts',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: reward.color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: totalPoints >= reward.pointsCost
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: totalPoints >= reward.pointsCost
                          ? Colors.green[100]!
                          : Colors.red[100]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        totalPoints >= reward.pointsCost
                            ? FontAwesomeIcons.circleInfo
                            : FontAwesomeIcons.triangleExclamation,
                        size: 14,
                        color: totalPoints >= reward.pointsCost
                            ? Colors.green[400]
                            : Colors.red[400],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          totalPoints >= reward.pointsCost
                              ? 'Balance after redeeming: ${totalPoints - reward.pointsCost} pts'
                              : 'Insufficient points. You need ${reward.pointsCost - totalPoints} more.',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: totalPoints >= reward.pointsCost
                                ? Colors.green[700]
                                : Colors.red[700],
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
                        onPressed: (totalPoints >= reward.pointsCost &&
                                !reward.isRedeemed)
                            ? () => confirmRedeem(ctx, reward)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: reward.color,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          reward.isRedeemed ? 'Redeemed' : 'Redeem',
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
        ),
      ),
    );
  }

  void confirmRedeem(BuildContext sheetCtx, RewardItem reward) {
    Navigator.pop(sheetCtx);
    setState(() {
      totalPoints -= reward.pointsCost;
      reward.isRedeemed = true;
      activity.insert(
        0,
        ActivityItem(
          title: 'Redeemed',
          icon: reward.icon,
          date: DateTime.now(),
          subtitle: reward.title,
          points: -reward.pointsCost,
          id: 'a_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
    });
    showSnackbar(
      '${reward.title} redeemed successfully! 🎉',
      Colors.green[700]!,
    );
  }

  void showRewardDetail(RewardItem reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                        color: reward.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(reward.icon, color: reward.color, size: 24),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            reward.description,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (reward.isRedeemed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Redeemed',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                detailRow(FontAwesomeIcons.coins, 'Cost',
                    '${reward.pointsCost} points',
                    valueColor: reward.color),
                const SizedBox(height: 10),
                detailRow(
                  FontAwesomeIcons.calendarDays,
                  'Validity',
                  reward.validity,
                ),
                const SizedBox(height: 10),
                detailRow(
                  FontAwesomeIcons.layerGroup,
                  'Category',
                  reward.category,
                ),
                const SizedBox(height: 10),
                detailRow(
                  FontAwesomeIcons.wallet,
                  'Your Balance',
                  '$totalPoints points',
                  valueColor: totalPoints >= reward.pointsCost
                      ? Colors.green[700]
                      : Colors.red[600],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: reward.isRedeemed
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            showRedeemSheet(reward);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: reward.color,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      reward.isRedeemed
                          ? 'Already Redeemed'
                          : 'Redeem for ${reward.pointsCost} pts',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
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

  Widget detailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
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
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
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

  void showAllRewards() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        minChildSize: 0.5,
        maxChildSize: 0.95,
        initialChildSize: 0.75,
        builder: (ctx, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    sheetHandle(),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Rewards',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334D8F).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$totalPoints pts',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334D8F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                  itemCount: allRewards.length,
                  itemBuilder: (_, i) => rewardCard(allRewards[i]),
                ),
              ),
            ],
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
          'Rewards',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  size: 12,
                  color: Colors.amber,
                  FontAwesomeIcons.coins,
                ),
                const SizedBox(width: 5),
                Text(
                  '$totalPoints pts',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pointsCard(),
            const SizedBox(height: 20),
            rewardCategories(),
            const SizedBox(height: 20),
            availableRewards(),
            const SizedBox(height: 20),
            recentActivity(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget pointsCard() {
    final tier = _tier;
    final isMaxTier = tier == RewardTier.platinum;

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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.indigo[800]!, Colors.indigo[600]!],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Points',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: tier.color.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              size: 10,
                              color: tier.color,
                              FontAwesomeIcons.crown,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              tier.label,
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
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        size: 30,
                        color: Colors.amber,
                        FontAwesomeIcons.coins,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        totalPoints >= 1000
                            ? '${(totalPoints ~/ 1000)},${(totalPoints % 1000).toString().padLeft(3, '0')}'
                            : '$totalPoints',
                        style: GoogleFonts.montserrat(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: tierProgress,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(tier.color),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMaxTier
                            ? 'Maximum tier reached 🏆'
                            : '$_pointsToNext points to ${tier.next.label}',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      if (!isMaxTier)
                        Text(
                          '${tier.nextThreshold}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rewardCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) => categoryCard(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryCard(RewardCategory cat) {
    final isSelected = selectedCategory == cat.name;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = cat.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: isSelected ? cat.color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? cat.color : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 1,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cat.color.withOpacity(isSelected ? 0.2 : 0.1),
              ),
              child: Icon(
                cat.icon,
                size: 24,
                color: isSelected ? cat.color : cat.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              cat.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: isSelected ? cat.color : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget availableRewards() {
    final rewards = filteredRewards;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Rewards',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: showAllRewards,
                child: Text(
                  'View All',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334D8F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (rewards.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                    size: 36,
                    color: Colors.grey[300],
                    FontAwesomeIcons.faceRollingEyes,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No rewards in this category',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            ...rewards.map((r) => rewardCard(r)),
        ],
      ),
    );
  }

  Widget rewardCard(RewardItem reward) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showRewardDetail(reward),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: reward.isRedeemed
                          ? Colors.grey[200]
                          : reward.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      reward.icon,
                      size: 24,
                      color:
                          reward.isRedeemed ? Colors.grey[400] : reward.color,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reward.title,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: reward.isRedeemed
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (reward.isRedeemed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Redeemed',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 9,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reward.description,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: totalPoints >= reward.pointsCost
                                    ? reward.color.withOpacity(0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${reward.pointsCost} pts',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: totalPoints >= reward.pointsCost
                                      ? reward.color
                                      : Colors.grey[400],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                reward.validity,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    size: 14,
                    FontAwesomeIcons.chevronRight,
                    color:
                        reward.isRedeemed ? Colors.grey[300] : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget recentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          ...activity.map((item) => activityItem(item)),
        ],
      ),
    );
  }

  Widget activityItem(ActivityItem item) {
    final color = item.isEarned ? Colors.green[600]! : Colors.red[600]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: color, size: 17),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
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
                item.formattedPoints,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.formattedDate,
                style: GoogleFonts.montserrat(
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
}
