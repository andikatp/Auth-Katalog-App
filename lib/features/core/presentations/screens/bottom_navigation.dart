import 'package:auth_katalog_app/routers/app_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({required this.child, super.key});
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _selectedIndex = 0;

  final _navItems = [
    const NavItem(
      route: AppRoutePaths.dashboard,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    const NavItem(
      route: AppRoutePaths.profile,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Home',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 2,
              offset: Offset(0, 0.75),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 10,
          type: .fixed,
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: _navItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: TweenAnimationBuilder<double>(
                    key: ValueKey(item.route),
                    tween: Tween<double>(begin: 0.8, end: 1),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: Icon(item.activeIcon),
                  ),
                  label: item.label,
                ),
              )
              .toList(),
          onTap: (index) {
            setState(() => _selectedIndex = index);
            final selectedRoute = _navItems[index].route;
            context.go(selectedRoute);
          },
        ),
      ),
    );
  }
}

class NavItem {
  const NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
