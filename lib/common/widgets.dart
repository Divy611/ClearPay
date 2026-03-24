import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomLoader {
  static CustomLoader? customLoader;
  CustomLoader.createObject();
  factory CustomLoader() {
    customLoader ??= CustomLoader.createObject();
    return customLoader!;
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  void _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: buildLoader(context),
      ),
    );
  }

  void showLoader(BuildContext context) {
    if (_overlayEntry != null) return;
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState!.insert(_overlayEntry!);
  }

  void hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Widget buildLoader(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= Colors.black.withOpacity(0.35);
    return FullScreenLoader(backgroundColor: backgroundColor);
  }
}

class FullScreenLoader extends StatefulWidget {
  final Color backgroundColor;
  const FullScreenLoader({required this.backgroundColor});

  @override
  State<FullScreenLoader> createState() => FullScreenLoaderState();
}

class FullScreenLoaderState extends State<FullScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _fadeIn;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _pulse = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: widget.backgroundColor,
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: ScaleTransition(
              scale: _pulse,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF334D8F).withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334D8F).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.creditCard,
                        size: 24,
                        color: Color(0xFF334D8F),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'ClearPay',
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334D8F),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please wait…',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Platform.isIOS
                            ? const CupertinoActivityIndicator(radius: 12)
                            : LinearProgressIndicator(
                                minHeight: 4,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF334D8F),
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
      ),
    );
  }
}

class CustomScreenLoader extends StatefulWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  final String text;

  const CustomScreenLoader({
    super.key,
    this.width = 30,
    this.height = 30,
    this.text = 'ClearPay',
    this.backgroundColor = const Color(0xFFF8F8F8),
  });

  @override
  State<CustomScreenLoader> createState() => _CustomScreenLoaderState();
}

class _CustomScreenLoaderState extends State<CustomScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _pulse,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF334D8F).withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF334D8F).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator(radius: 12)
                    : const Padding(
                        padding: EdgeInsets.all(9),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF334D8F)),
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Text(
                widget.text,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334D8F),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loader() {
  return Center(
    child: Platform.isIOS
        ? const CupertinoActivityIndicator()
        : const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF334D8F)),
            ),
          ),
  );
}

class Search extends StatelessWidget implements PreferredSizeWidget {
  const Search({
    super.key,
    this.title,
    this.textController,
    this.onSearchChanged,
    this.onActionPressed,
    this.submitButtonText,
  });

  final Widget? title;
  final String? submitButtonText;
  final Function? onActionPressed;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? textController;

  @override
  Size get preferredSize => const Size.fromHeight(57);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF334D8F),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40),
            ),
            const Icon(FontAwesomeIcons.magnifyingGlass,
                size: 14, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: onSearchChanged,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by name…',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.55),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Colors.white,
              ),
            ),
            if (textController != null)
              IconButton(
                icon: Icon(Icons.close,
                    color: Colors.white.withOpacity(0.7), size: 16),
                onPressed: () {
                  textController!.clear();
                  onSearchChanged?.call('');
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36),
              ),
          ],
        ),
      ),
    );
  }
}
