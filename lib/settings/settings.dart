import 'package:clearpay/auth/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String currency = '₹ INR';
  String language = 'English';

  final List<String> currencies = [
    '₹ INR',
    '\$ USD',
    '€ EUR',
    '£ GBP',
    '¥ JPY'
  ];
  final List<String> languages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Marathi'
  ];
  //final List<String> _defaultTabs = [
  //  'Dashboard',
  //  'Transactions',
  //  'Mandates',
  //  'Approvals'
  //];

  void customSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF334D8F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _sheetHandle() => Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  void _showPickerSheet({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            ...options.map((opt) {
              final isSel = opt == selected;
              return GestureDetector(
                onTap: () {
                  onSelected(opt);
                  Navigator.pop(ctx);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSel
                        ? const Color(0xFF334D8F).withOpacity(0.07)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel
                          ? const Color(0xFF334D8F).withOpacity(0.4)
                          : Colors.grey[200]!,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight:
                                isSel ? FontWeight.w600 : FontWeight.w500,
                            color: isSel
                                ? const Color(0xFF334D8F)
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      if (isSel)
                        const Icon(
                          FontAwesomeIcons.circleCheck,
                          size: 16,
                          color: Color(0xFF334D8F),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showConfirmSheet({
    required String title,
    required String subtitle,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
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
            _sheetHandle(),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: confirmColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: confirmColor, size: 26),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style:
                  GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
                    child: Text('Cancel',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(confirmLabel,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
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
          'Settings',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(height: 20),
            //section(
            //  icon: FontAwesomeIcons.bell,
            //  title: 'Notifications',
            //  color: Colors.orange[600]!,
            //  children: [
            //    toggleTile(
            //      icon: FontAwesomeIcons.arrowRightArrowLeft,
            //      iconColor: Colors.orange[600]!,
            //      title: 'Transaction Alerts',
            //      subtitle: 'Get notified on every debit/credit',
            //      value: _transactionAlerts,
            //      onChanged: (v) => setState(() => _transactionAlerts = v),
            //    ),
            //    divider(),
            //    toggleTile(
            //      icon: FontAwesomeIcons.fileContract,
            //      iconColor: Colors.orange[600]!,
            //      title: 'Mandate Reminders',
            //      subtitle: 'Alerts before upcoming auto-debits',
            //      value: _mandateReminders,
            //      onChanged: (v) => setState(() => _mandateReminders = v),
            //    ),
            //    divider(),
            //    toggleTile(
            //      icon: FontAwesomeIcons.userCheck,
            //      iconColor: Colors.orange[600]!,
            //      title: 'Approval Requests',
            //      subtitle: 'Notify when a payment needs approval',
            //      value: _approvalNotifs,
            //      onChanged: (v) => setState(() => _approvalNotifs = v),
            //    ),
            //    divider(),
            //    toggleTile(
            //      icon: FontAwesomeIcons.chartLine,
            //      iconColor: Colors.orange[600]!,
            //      title: 'Market Updates',
            //      subtitle: 'Daily stock & investment summaries',
            //      value: _marketUpdates,
            //      onChanged: (v) => setState(() => _marketUpdates = v),
            //    ),
            //  ],
            //),
            //const SizedBox(height: 15),
            section(
              icon: FontAwesomeIcons.gear,
              title: 'Preferences',
              color: Colors.teal[600]!,
              children: [
                pickerTile(
                  icon: FontAwesomeIcons.indianRupeeSign,
                  iconColor: Colors.teal[600]!,
                  title: 'Currency',
                  subtitle: 'Select your preferred currency',
                  value: currency,
                  onTap: () => _showPickerSheet(
                    title: 'Select Currency',
                    options: currencies,
                    selected: currency,
                    onSelected: (v) => setState(() => currency = v),
                  ),
                ),
                divider(),
                pickerTile(
                  icon: FontAwesomeIcons.language,
                  iconColor: Colors.teal[600]!,
                  title: 'Language',
                  subtitle: 'Choose your display language',
                  value: language,
                  onTap: () => _showPickerSheet(
                    title: 'Select Language',
                    options: languages,
                    selected: language,
                    onSelected: (v) => setState(() => language = v),
                  ),
                ),
                divider(),
                actionTile(
                  icon: FontAwesomeIcons.cloudArrowDown,
                  iconColor: Colors.teal[600]!,
                  title: 'Export Data',
                  subtitle: 'Download your transaction history as CSV',
                  onTap: () => customSnackbar('Preparing export…'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            section(
              icon: FontAwesomeIcons.circleInfo,
              title: 'About',
              color: Colors.blue[600]!,
              children: [
                actionTile(
                  icon: FontAwesomeIcons.fileLines,
                  iconColor: Colors.blue[600]!,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () => customSnackbar('Opening Terms of Service…'),
                ),
                divider(),
                actionTile(
                  icon: FontAwesomeIcons.shieldHalved,
                  iconColor: Colors.blue[600]!,
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  onTap: () => customSnackbar('Opening Privacy Policy…'),
                ),
                divider(),
                _buildInfoTile(
                  icon: FontAwesomeIcons.codeBranch,
                  iconColor: Colors.blue[600]!,
                  title: 'App Version',
                  value: 'v1.0.0 (build 42)',
                ),
              ],
            ),
            const SizedBox(height: 15),
            section(
              icon: FontAwesomeIcons.triangleExclamation,
              title: 'Danger Zone',
              color: Colors.red[600]!,
              children: [
                actionTile(
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  iconColor: Colors.red[600]!,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  titleColor: Colors.red[600],
                  onTap: () => _showConfirmSheet(
                    title: 'Log Out?',
                    subtitle:
                        'You will be signed out of your account on this device.',
                    confirmLabel: 'Log Out',
                    confirmColor: Colors.red[600]!,
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                    onConfirm: () {
                      final state =
                          Provider.of<AuthState>(context, listen: false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingPage(),
                        ),
                      );
                      state.logoutCallback();
                    },
                  ),
                ),
                // divider(),
                // actionTile(
                //   icon: FontAwesomeIcons.trash,
                //   iconColor: Colors.red[600]!,
                //   title: 'Delete Account',
                //   subtitle: 'Permanently remove all your data',
                //   titleColor: Colors.red[600],
                //   onTap: () => _showConfirmSheet(
                //     title: 'Delete Account?',
                //     subtitle:
                //         'This will permanently delete your account and all associated data. This action cannot be undone.',
                //     confirmLabel: 'Delete Account',
                //     confirmColor: Colors.red[600]!,
                //     icon: FontAwesomeIcons.trash,
                //     onConfirm: () =>
                //         customSnackbar('Account deletion requested.'),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDeveloperInfo(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget header() {
    var auth = Provider.of<AuthState>(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: const Icon(FontAwesomeIcons.user,
                size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.user!.displayName ?? 'Full Name',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  auth.user!.email ?? 'example@email.com',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          //IconButton(
          //  onPressed: () => customSnackbar('Edit profile coming soon.'),
          //  icon: Container(
          //    padding: const EdgeInsets.all(8),
          //    decoration: BoxDecoration(
          //      color: Colors.white.withOpacity(0.15),
          //      borderRadius: BorderRadius.circular(10),
          //    ),
          //    child: const Icon(FontAwesomeIcons.penToSquare,
          //        size: 16, color: Colors.white),
          //  ),
          //),
        ],
      ),
    );
  }

  Widget section({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 13, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
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
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget toggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF334D8F),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(FontAwesomeIcons.chevronRight,
                size: 13, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget pickerTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF334D8F).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334D8F),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(FontAwesomeIcons.chevronRight,
                size: 13, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() => Divider(
        height: 1,
        thickness: 1,
        indent: 68,
        endIndent: 16,
        color: Colors.grey[100],
      );

  Widget _buildDeveloperInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Developer',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
              border: Border.all(
                  color: const Color(0xFF334D8F).withOpacity(0.15), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF334D8F), Color(0xFF5B7FD4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF334D8F).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'AP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aditya Pandey',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2.5),
                          Text(
                            'Reg. Number: 225890264',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334D8F),
                            ),
                          ),
                          const SizedBox(height: 2.5),
                          Text(
                            'AI - A',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: Colors.grey[500],
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
}
