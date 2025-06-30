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
class _HomeContent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return const Center(
      child: Text('bismillah bisa plss'),
    );
  }
}

//widget sementara buat halaman lain
class PlaceholderWidget extends StatelessWidget{
  final String title;

  const PlaceholderWidget({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context){
    return Center(
      child: Text('halaman $title dibuat nanti'),
    );
  }
}
