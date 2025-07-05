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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2272BB),
            Color.fromARGB(255, 179, 213, 252),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 180,
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
                    SizedBox(height: 1),
                    Text(
                      'Solusi Mobile Deteksi Kesegaran Bandeng\nBerbasis Citra Mata',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Card: What is ScanBang 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'What is ScanBang?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2272BB),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ScanBang adalah aplikasi mobile yang digunakan untuk mendeteksi tingkat kesegaran ikan bandeng secara otomatis berdasarkan citra mata menggunakan teknologi kecerdasan buatan',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //Card ciri-ciri Kesegaran Ikan
              FreshnessCard(),
              const SizedBox(height: 16),

              // Card: Fitur Unggulan (tanpa shadow)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fitur Unggulan',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double cardWidth = (constraints.maxWidth - 12) / 2;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _featureCard(cardWidth, Icons.camera_alt, 'Deteksi Otomatis', 'Dari kamera dan galeri'),
                              _featureCard(cardWidth, Icons.flash_on, 'Cepat', 'Gunakan model deep learning'),
                              _featureCard(cardWidth, Icons.touch_app, 'Mudah Digunakan', 'Cocok semua kalangan'),
                              _featureCard(cardWidth, Icons.pets, 'Spesifik Bandeng', 'Hasil lebih relevan'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _featureCard(double width, IconData icon, String title, String subtitle) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Color(0xFF1e66a8)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FreshnessCard extends StatelessWidget {
  const FreshnessCard({super.key});

  Widget _buildSection(String title, List<Map<String, String>> items, double cardWidth) {
    // Tentukan warna latar berdasarkan judul kategori
    Color bgColor;
    if (title == 'Sangat Segar') {
      bgColor = const Color(0xFF11395d);
    } else if (title == 'Segar') {
      bgColor = const Color(0xFF174f82);
    } else if (title == 'Kurang Segar') {
      bgColor = const Color(0xFF1e66a8);
    } else {
      bgColor = const Color(0xFFE3F2FD);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['description'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = (constraints.maxWidth - 12) / 2;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ciri-ciri Kesegaran Ikan',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSection('Sangat Segar', [
                  {'title': 'Bentuk', 'description': 'Bulat sempurna dan cembung.'},
                  {'title': 'Kejernihan', 'description': 'Sangat jernih, bening, tidak keruh.'},
                  {'title': 'Kornea', 'description': 'Transparan dan mengilap.'},
                  {'title': 'Warna Pupil', 'description': 'Hitam pekat, kontras jelas.'},
                ], cardWidth),
                _buildSection('Segar', [
                  {'title': 'Bentuk', 'description': 'Agak menonjol tapi tidak terlalu cembung.'},
                  {'title': 'Kejernihan', 'description': 'Sedikit buram, masih terlihat bagian pupil dan putih mata.'},
                  {'title': 'Kornea', 'description': 'Mulai menunjukkan tanda-tanda keabuan.'},
                  {'title': 'Warna Pupil', 'description': 'Mulai memudar, tidak terlalu hitam pekat.'},
                ], cardWidth),
                _buildSection('Kurang Segar', [
                  {'title': 'Bentuk', 'description': 'Cekung (masuk ke dalam), terlihat kempis.'},
                  {'title': 'Kejernihan', 'description': 'Keruh total, tidak bisa melihat bagian dalam mata dengan jelas.'},
                  {'title': 'Kornea', 'description': 'Berwarna putih susu atau abu-abu kusam.'},
                  {'title': 'Warna Pupil', 'description': 'Tidak jelas, menyatu dengan bagian lain mata.'},
                ], cardWidth),
              ],
            ),
          );
        },
      ),
    );
  }
}
