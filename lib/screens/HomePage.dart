import 'package:flutter/material.dart';
import '../widgets/MyAppBar.dart';
import '../widgets/PersistentBottomBar.dart';
import '../screens/DeteksiPage.dart';
import '../screens/PanduanPage.dart';
import '../utils/appbar_helper.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _currentIndex = 0;

  //daftar halaman
  final List<Widget> _pages = [
    _HomeContent(), //untuk halaman home, berarti bikin class _HomeContent
    const DeteksiPage(),
    const PanduanPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MyAppBar(
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

//class _homeContent
class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header (Teks di kiri, logo di kanan)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Teks
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selamat datang di',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ScanBang',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Solusi Mobile Deteksi Kesegaran\nBandeng Berbasis Citra Mata',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Logo
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Ciri-ciri Ikan Segar
          const Text(
            '🟢 Ciri-ciri Ikan Bandeng Segar:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCiriItem(Icons.check_circle, 'Mata jernih dan cembung'),
          _buildCiriItem(Icons.check_circle, 'Insang berwarna merah segar'),
          _buildCiriItem(Icons.check_circle, 'Daging kenyal dan tidak lembek'),
          _buildCiriItem(Icons.check_circle, 'Aroma segar khas laut'),

          const SizedBox(height: 25),

          // Ciri-ciri Ikan Tidak Segar
          const Text(
            '🔴 Ciri-ciri Ikan Bandeng Tidak Segar:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCiriItem(Icons.cancel, 'Mata keruh dan cekung'),
          _buildCiriItem(Icons.cancel, 'Insang pucat atau keabu-abuan'),
          _buildCiriItem(Icons.cancel, 'Daging lembek dan berair'),
          _buildCiriItem(Icons.cancel, 'Bau menyengat tidak sedap'),
        ],
      ),
    );
  }

  Widget _buildCiriItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: icon == Icons.check_circle ? Colors.green : Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}