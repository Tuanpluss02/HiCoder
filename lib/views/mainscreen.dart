import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/views/profile.dart';
import 'package:ionicons/ionicons.dart';

import 'components/fab_container.dart';
import 'feeds.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Ionicons.home,
      'page': const Feeds(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Ionicons.search,
      // 'page': Search(),
      'page': const Feeds(),
      'index': 1,
    },
    {
      'title': 'New Post',
      'icon': Ionicons.add_circle,
      'page': const Feeds(),
      'index': 2,
    },
    {
      'title': 'Notification',
      'icon': CupertinoIcons.bell_solid,
      // 'page': Activities(),
      'page': const Feeds(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': CupertinoIcons.person_fill,
      'page': const UserProfile(),
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            for (Map item in pages)
              item['index'] == 2
                  ? buildFab()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        icon: Icon(
                          item['icon'],
                          color: item['index'] != _page
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black
                              : Theme.of(context).colorScheme.secondary,
                          size: 25.0,
                        ),
                        onPressed: () => navigationTapped(item['index']),
                      ),
                    ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  buildFab() {
    return const SizedBox(
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
      child: FabContainer(
        icon: Ionicons.add_outline,
        mini: true,
      ),
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
