import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});
  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  static const List<NavItem> items = [
    NavItem(icon: FontAwesomeIcons.house, label: 'Home'),
    NavItem(icon: FontAwesomeIcons.wallet, label: 'Wallet'),
    NavItem(icon: FontAwesomeIcons.gift, label: 'Rewards'),
    NavItem(icon: FontAwesomeIcons.moneyBillTransfer, label: 'Transactions'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 75 + bottomPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      padding: EdgeInsets.only(
          top: 7, left: 10, right: 10, bottom: 7 + bottomPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) return const SizedBox(width: 15);
          final itemIndex = i ~/ 2;
          return icon(items[itemIndex].icon, itemIndex, items[itemIndex].label);
        }),
      ),
    );
  }

  Widget icon(IconData icon, int index, String title) {
    final app = Provider.of<AppState>(context);
    final isActive = index == app.pageIndex;
    final double fontSize = title.length > 9 ? 8.25 : 11;
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedAlign(
          curve: Curves.easeIn,
          alignment: const Alignment(0, 0),
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: 1,
            child: TextButton(
              onPressed: () => setState(() => app.setPageIndex = index),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 21,
                    color: isActive ? Color(0xFF334D8F) : Colors.grey[400],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: fontSize,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Color(0xFF334D8F) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String label;
  final IconData icon;
  const NavItem({required this.icon, required this.label});
}
