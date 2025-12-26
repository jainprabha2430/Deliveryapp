// import 'package:flutter/material.dart';
// import 'login_screen.dart';
//
// class OnboardingPage {
//   final String image;
//   OnboardingPage({required this.image});
// }
//
// final List<OnboardingPage> onboardingPages = [
//   OnboardingPage(image: 'assets/onboard1.png'),
//   OnboardingPage(image: 'assets/onboard2.png'),
//   OnboardingPage(image: 'assets/onboard3.png'),
// ];
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _nextPage() {
//     if (_currentPage < onboardingPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _goToLogin();
//     }
//   }
//
//   void _goToLogin() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: onboardingPages.length,
//             onPageChanged: (index) => setState(() => _currentPage = index),
//             itemBuilder: (context, index) {
//               return Image.asset(
//                 onboardingPages[index].image,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               );
//             },
//           ),
//           Positioned(
//             top: 35,
//             right: 15,
//             child: TextButton(
//               onPressed: _goToLogin,
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.grey.shade300,
//                 shape: const StadiumBorder(),
//               ),
//               child: Text(
//                 "Skip",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 5,
//             left: 25,
//             right: 25,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: List.generate(
//                     onboardingPages.length,
//                         (index) => buildDot(index),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _nextPage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF3949AB),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 28,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: Text(
//                     _currentPage == onboardingPages.length - 1
//                         ? "GET STARTED"
//                         : "NEXT",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDot(int index) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       margin: const EdgeInsets.only(right: 6),
//       height: 8,
//       width: _currentPage == index ? 26 : 8,
//       decoration: BoxDecoration(
//         color: _currentPage == index
//             ? Color(0xFF1A237E)
//             : Colors.green.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(6),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Eco-Friendly\nLogistics",
      "subtitle": "FUTURE OF DELIVERY",
      "desc": "Join our mission for sustainable and green logistics across the globe.",
      "color": const Color(0xFF22C55E),
      "image": "assets/onboard1.png"
    },
    {
      "title": "Real-time\nTracking",
      "subtitle": "LIVE PRECISION",
      "desc": "Monitor your orders in real-time with millisecond location updates.",
      "color": const Color(0xFF6366F1),
      "image": "assets/onboard2.png"
    },
    {
      "title": "Effortless\nOrdering",
      "subtitle": "SMOOTH CHECKOUT",
      "desc": "A seamless and secure ordering process designed for your ultimate convenience.",
      "color": const Color(0xFF3B82F6),
      "image": "assets/onboard3.png"
    },
  ];
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = _onboardingData[_currentPage]["color"];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          _buildBackgroundGlow(activeColor),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (v) => setState(() => _currentPage = v),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return AnimatedScale(
                        scale: _currentPage == index ? 1.0 : 0.75,
                        duration: const Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            _onboardingData[index]["image"],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildContentCard(activeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow(Color color) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      top: -100,
      left: _currentPage == 1 ? 150 : -100,
      child: Container(
        width: 450,
        height: 450,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.12),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _goToLogin, // Direct Skip to Login
            child: Text(
              "SKIP",
              style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Color color) {
    bool isLastPage = _currentPage == _onboardingData.length - 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _onboardingData[_currentPage]["subtitle"],
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _onboardingData[_currentPage]["title"],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _onboardingData[_currentPage]["desc"],
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey.shade400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress Indicators
              Row(
                children: List.generate(
                  _onboardingData.length,
                      (index) => _buildDot(index, color),
                ),
              ),
              // Dynamic Action Button
              _buildActionButton(color, isLastPage),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDot(int index, Color color) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildActionButton(Color color, bool isLastPage) {
    return GestureDetector(
      onTap: () {
        if (isLastPage) {
          _goToLogin();
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuart,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isLastPage ? 24 : 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Dark Premium Button
          borderRadius: isLastPage ? BorderRadius.circular(20) : BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLastPage)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  "GET STARTED",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            Icon(
              isLastPage ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}


