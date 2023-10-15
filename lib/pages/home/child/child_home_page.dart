import 'package:example/constants.dart';
import 'package:example/pages/home/child/child_channel_page.dart';
import 'package:example/pages/home/child/child_video_page.dart';

import 'package:example/theme/colors.dart';
import 'package:example/utilities/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChildHomePage extends StatefulWidget {
  const ChildHomePage({super.key});

  @override
  State<ChildHomePage> createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryColor,
      appBar: CustomAppBar(),
      body: body(),
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }

  Widget body() {
    switch (_selectedIndex) {
      case 0:
        return const ChildVideoPage();
    }
    switch (_selectedIndex) {
      case 1:
        return const ChildChannelPage();
    }

    return Container();
  }

  Widget customBottomNavigationBar() {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
            backgroundColor: const Color(0xff424242),
            selectedItemColor: pink,
            selectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_display),
                label: 'Videos',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv), label: 'Channels'),
            ],
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
