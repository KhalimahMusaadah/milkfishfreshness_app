import 'package:flutter/material.dart';
import '../widgets/MyAppBar.dart';
import '../widgets/PersistentBottomBar.dart';
import '../screens/DeteksiPage.dart';
import '../screens/PanduanPage.dart';
import '../utils/appbar_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const DeteksiPage(),
    const PanduanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? null
          : MyAppBar(
              title: getAppBarTitle(_currentIndex),
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: PersistentBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                // HEADER BIRU
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'ScanBang',
                        style: TextStyle(
                          fontFamily: 'Nectarine',
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Solusi Mobile Deteksi Kesegaran Bandeng\nBerbasis Citra Mata',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 160),
              ],
            ),

            // CARD MELAYANG DENGAN ATAS MELENGKUNG KE DALAM
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: RoundedTopClipper(),
                child: Material(
                  elevation: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'What is ScanBang?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'ScanBang is a mobile-based application that uses eye image recognition to determine the freshness of milkfish. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
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

// Custom clipper untuk melengkungkan bagian atas card ke dalam
class RoundedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Mulai dari titik kiri atas (sedikit ke bawah)
    path.moveTo(0, 40);

    // Buat lengkungan ke bawah di bagian atas
    path.quadraticBezierTo(
      size.width / 2, -40, // titik kontrol di atas layar (untuk lengkungan dalam)
      size.width, 40,       // titik akhir lengkungan
    );

    // Buat sisi bawah card
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
