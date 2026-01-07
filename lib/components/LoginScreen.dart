import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatbot_app/components/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String userName = prefs.getString('userName') ?? 'User';
      bool isRegistered = prefs.getBool('isRegistered') ?? false;

      String userType = prefs.getString('userType') ?? 'patient';
      bool isDoctorRegistered = prefs.getBool('isDoctorRegistered') ?? false;

      if (isDoctorRegistered && userType == 'doctor') {
        // Navigate to doctor's user list
        Get.offAllNamed('/usersList');
      } else if (isRegistered) {
        // Navigate to patient chat screen
        Get.offNamed('/chat', arguments: {
          'greetingMessage': "Welcome back, $userName!",
          'relationship': '',
        });
      } else {
        // Not registered, show message and go to role selection
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No account found. Please register first.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/roleSelection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during login: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Back Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: gray950, size: 20),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: blueCustom.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.login_rounded,
                        size: 80,
                        color: blueCustom,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: gray950,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Login to continue to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: gray500,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueCustom,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: blueCustom.withOpacity(0.6),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: gray500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.offAllNamed('/roleSelection'),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blueCustom,
                            ),
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
      ),
    );
  }
}

// import 'package:chatbot_app/pages/RegisterScreen.dart';
// import 'package:chatbot_app/pages/ChatScreen.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       String username = _usernameController.text;
//       String password = _passwordController.text;

//       // Simulated authentication check
//       if (username == "admin" && password == "123456") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatScreen(greetingMessage: "Welcome, $username!"),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid username or password")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const Text(
//                 'Hello there!',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 18, 118)),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Welcome',
//                 style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 18, 118)),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Sign in to continue',
//                 style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 28, 18, 118)),
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _usernameController,
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                         labelText: "Username",
//                         labelStyle: const TextStyle(color: Colors.black54),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your username';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 25),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         labelStyle: const TextStyle(color: Colors.black54),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 40),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _login,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromARGB(255, 34, 22, 142),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: const Text('Login'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegisterScreen()),
//                     );
//                   },
//                   child: const Text(
//                     "Don't have an account? Register",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 28, 18, 118),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:chatbot_app/pages/RegisterScreen.dart';
// import 'package:chatbot_app/pages/ChatScreen.dart';
// import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:chatbot_app/pages/const.dart';  // Import the constants


// // import 'package:chatbot_app/pages/const.dart'; 
// // void fetchData() async {
// //   var http;
// //   final response = await http.get(Uri.parse("$baseUrl/messages/get-all"));
// //   print(response.body);
// // }


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       String username = _usernameController.text;
//       String password = _passwordController.text;

//       // Simulated authentication check
//       if (username == "admin" && password == "123456") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatScreen(greetingMessage: "Welcome, $username!"),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid username or password")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // White background
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
//           children: <Widget>[
//             const Text(
//               'Hello there!',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 18, 118)),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Welcome',
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 18, 118)),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Sign in to continue',
//               style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 28, 18, 118) ),
//               textAlign: TextAlign.center, 
//             ),
//             const SizedBox(height: 30),

//             // Login Form
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _usernameController,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       labelText: "Username",
//                       labelStyle: const TextStyle(color: Colors.black54),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your username';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 25),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: const TextStyle(color: Colors.black54),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity, // Make button full width
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 34, 22, 142),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: const Text('Login'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Register Navigation
//             Align(
//               alignment: Alignment.centerLeft, // Align to left
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => RegisterScreen()),
//                   );
//                 },
//                 child: const Text(
//                   "Don't have an account? Register",
//                   style: TextStyle(
//                     fontSize: 20, // Reduced size for better UI
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 28, 18, 118),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

