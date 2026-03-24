import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/auth/login.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/common/widgets.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  final VoidCallback loginCallback;
  const SignUp({super.key, required this.loginCallback});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  late final CustomLoader loader = CustomLoader();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    confirmController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.all(16),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF334D8F), Color(0xFF1A2747)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Sign up to get started!',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.white.withOpacity(0.7))),
                SizedBox(height: 40),
                textField(
                  label: 'Full Name',
                  controller: nameController,
                  icon: FontAwesomeIcons.user,
                ),
                SizedBox(height: 20),
                textField(
                  label: 'Email',
                  controller: emailController,
                  icon: FontAwesomeIcons.envelope,
                ),
                SizedBox(height: 20),
                textField(
                  label: 'Phone',
                  controller: phoneController,
                  icon: FontAwesomeIcons.phone,
                ),
                SizedBox(height: 20),
                textField(
                  isPassword: true,
                  label: 'Password',
                  icon: FontAwesomeIcons.lock,
                  controller: passwordController,
                  isPasswordVisible: isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 20),
                textField(
                  isPassword: true,
                  label: 'Confirm Password',
                  icon: FontAwesomeIcons.lock,
                  controller: confirmController,
                  isPasswordVisible: isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: TextButton(
                    onPressed: isLoading ? null : signUp,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF334D8F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Color(0xFF334D8F))
                        : Text(
                            'SIGN UP',
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(
                              loginCallback: auth.getCurrentUser,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Or sign up with',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialButton(FontAwesomeIcons.google),
                    SizedBox(width: 20),
                    socialButton(FontAwesomeIcons.apple),
                    SizedBox(width: 20),
                    socialButton(FontAwesomeIcons.facebook),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : label == 'Phone'
                ? TextInputType.phone
                : label == 'Email'
                    ? TextInputType.emailAddress
                    : TextInputType.name,
        style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: Colors.white.withOpacity(0.7),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    size: 18,
                    isPasswordVisible
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }

  Widget socialButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }

  Future<void> signUp() async {
    final confirm = confirmController.text;
    final name = nameController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    if (name.isEmpty) {
      showError('Please enter your full name.');
      return;
    }
    if (name.length > 40) {
      showError('Name cannot exceed 40 characters.');
      return;
    }
    if (email.isEmpty) {
      showError('Please enter your email address.');
      return;
    }
    if (password.isEmpty || confirm.isEmpty) {
      showError('Please fill in all fields.');
      return;
    }
    if (password.length < 8) {
      showError('Password must be at least 8 characters.');
      return;
    }
    if (password != confirm) {
      showError('Passwords do not match.');
      return;
    }
    setState(() => isLoading = true);
    loader.showLoader(context);
    final state = Provider.of<AuthState>(context, listen: false);
    final user = UserModel(
      balance: 0,
      phone: phone,
      email: email,
      displayName: name,
      profilePic:
          'https://images.pexels.com/photos/13221344/pexels-photo-13221344.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load',
    );
    await state.signUp(user, context: context, password: password);
    setState(() => isLoading = false);
    if (state.authStatus == AuthStatus.LOGGED_IN) {
      loader.hideLoader();
      Navigator.popUntil(context, (route) => route.isFirst);
      widget.loginCallback();
    } else {
      showError('Sign up failed. Please try again.');
    }
  }
}
