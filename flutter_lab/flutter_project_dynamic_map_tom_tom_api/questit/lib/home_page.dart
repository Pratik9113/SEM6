import 'package:flutter/material.dart';
import 'package:questit/home_section_page.dart';
import 'package:questit/pages/carbon_emission_page.dart';
import 'package:questit/pages/map/map_page_version.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [
    HomeSectionPage(),
    MapPageVersion(),
    CarbonEmissionPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.co2_sharp),
            label: 'Emission',
          ),
        ],
      ),
    );
  }
}
