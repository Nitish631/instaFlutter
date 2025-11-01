import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freehit/Screens/HomeScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;
  late double width;
  bool isMoreOptionClicked = false;
  bool isNotificationClicked = false;
  bool isMessageClicked = false;
  bool isNewNotification = true;
  late List<_NavItem> _navItems;

  // ✅ Pages
  final List<Widget> _pages = const [
    HomeScreen(),
    Center(child: Text('🔍 Search Page', style: TextStyle(fontSize: 22))),
    Center(child: Text('🎬 Reels Page', style: TextStyle(fontSize: 22))),
    Center(child: Text('💬 Messages Page', style: TextStyle(fontSize: 22))),
    Center(
      child: Text('🔔 Notifications Page', style: TextStyle(fontSize: 22)),
    ),
    Center(child: Text('➕ Create Page', style: TextStyle(fontSize: 22))),
    Center(child: Text('👤 Profile Page', style: TextStyle(fontSize: 22))),
  ];

  // ✅ Sidebar nav items
  @override
  void initState() {
    super.initState();
    _navItems = [
      _NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: "Home",
      ),
      _NavItem(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search_rounded,
        label: "Search",
      ),
      _NavItem(
        icon: Icons.video_library_outlined,
        selectedIcon: Icons.video_library,
        label: "Reels",
      ),
      _NavItem(label: "Message", widget: _buildMessageIcon(fromNav: true)),
      _NavItem(
        label: "Notification",
        widget: _buildNotificationIcon(fromNav: true),
      ),
      _NavItem(
        icon: Icons.add_box_outlined,
        selectedIcon: Icons.add_box,
        label: "Create",
      ),
      _NavItem(
        icon: Icons.person_2_outlined,
        selectedIcon: Icons.person,
        label: "Profile",
      ),
    ];
  }

  // ✅ Bottom nav (for mobile)
  final List<_NavItem> _bottomNavItems = const [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: "Home",
    ),
    _NavItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded,
      label: "Search",
    ),
    _NavItem(
      icon: Icons.video_library_outlined,
      selectedIcon: Icons.video_library,
      label: "Reels",
    ),
    _NavItem(
      icon: Icons.add_box_outlined,
      selectedIcon: Icons.add_box,
      label: "Create",
    ),
    _NavItem(
      icon: Icons.person_2_outlined,
      selectedIcon: Icons.person,
      label: "Profile",
    ),
  ];

  int get currentPageIndex {
    if (width > 766) return _selectedIndex;
    switch (_selectedIndex) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 5;
      case 4:
        return 6;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top Bar (Mobile)
            if (width <= 766)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/ic_instagram.svg",
                      height: 30,
                      color: isDarkMode
                          ? AppColors.primaryColor
                          : AppColors.dark,
                    ),
                    Row(
                      children: [
                        // Notification icon
                        _buildNotificationIcon(),
                        const SizedBox(width: 27),
                        // Message icon
                        _buildMessageIcon(),
                      ],
                    ),
                  ],
                ),
              ),

            // ✅ Main body
            Expanded(
              child: Row(
                children: [
                  // ✅ Sidebar (Desktop)
                  if (width > 766)
                    Container(
                      width: (width <= 1264) ? 110 : 220,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.dark
                            : AppColors.primaryColor,
                        border: Border(
                          right: BorderSide(
                            color: isDarkMode
                                ? AppColors.primaryColor
                                : AppColors.dark,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Navigation items
                          Column(
                            children: List.generate(_navItems.length, (index) {
                              final item = _navItems[index];
                              final isSelected = _selectedIndex == index;
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: (width <= 1264) ? 0 : 6,
                                  horizontal: 8,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () =>
                                      setState(() => _selectedIndex = index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 15,
                                    ),
                                    child: width <= 1264
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _buildNavIcon(item, isSelected),
                                              const SizedBox(height: 5),
                                              _buildNavLabel(
                                                item.label,
                                                isSelected,
                                                11,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              _buildNavIcon(item, isSelected),
                                              const SizedBox(width: 10),
                                              _buildNavLabel(
                                                item.label,
                                                isSelected,
                                                16,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(
                              () => isMoreOptionClicked = !isMoreOptionClicked,
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                              child: width <= 1264
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (isMoreOptionClicked)
                                            ? Icon(Icons.more_horiz)
                                            : Icon(Icons.menu),
                                        const SizedBox(height: 5),
                                        _buildNavLabel(
                                          "More",
                                          isMoreOptionClicked,
                                          11,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        (isMoreOptionClicked)
                                            ? Icon(Icons.more_horiz)
                                            : Icon(Icons.menu),
                                        const SizedBox(height: 5),
                                        _buildNavLabel(
                                          "More",
                                          isMoreOptionClicked,
                                          16,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ✅ Main Page Content
                  Expanded(
                    child: Container(
                      color: isDarkMode
                          ? AppColors.black
                          : AppColors.primaryColor,
                      alignment: Alignment.center,
                      child: _pages[currentPageIndex],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Bottom Nav (Mobile)
            if (width <= 766)
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.dark : AppColors.primaryColor,
                  border: Border(
                    top: BorderSide(
                      width: 0.1,
                      color: isDarkMode
                          ? AppColors.primaryColor
                          : AppColors.dark,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_bottomNavItems.length, (index) {
                    final item = _bottomNavItems[index];
                    final isSelected = _selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          color: isDarkMode
                              ? AppColors.dark
                              : AppColors.primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNavIcon(item, isSelected),
                              const SizedBox(height: 4),
                              _buildNavLabel(item.label, isSelected, 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Custom Notification Icon (with red dot)
  Widget _buildNotificationIcon({bool fromNav = false}) {
    Widget icon = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.favorite_border,
          size: 27,
          color: isDarkMode ? AppColors.primaryColor : AppColors.black,
        ),
        if (isNewNotification)
          Positioned(
            right: 0,
            top: 2,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.5),
              ),
            ),
          ),
      ],
    );

    // When it's not from sidebar, wrap with InkWell
    return fromNav
        ? icon
        : InkWell(
            onTap: () {
              setState(() {
                isNotificationClicked = !isNotificationClicked;
                isNewNotification = !isNewNotification;
              });
            },
            child: icon,
          );
  }

  // ✅ Custom Message Icon (Instagram-like)
  Widget _buildMessageIcon({bool fromNav = false}) {
    Widget icon = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: isDarkMode ? AppColors.primaryColor : AppColors.black,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Transform.rotate(
            angle: 5.497,
            child: Icon(Icons.send, size: 15),
          ),
        ),
      ],
    );

    return fromNav
        ? icon
        : InkWell(
            onTap: () => setState(() => isMessageClicked = !isMessageClicked),
            child: icon,
          );
  }

  Widget _buildNavIcon(_NavItem item, bool isSelected) {
    // ✅ If a custom widget is provided (like heart or message icon), use that directly
    if (item.widget != null) return item.widget!;

    // ✅ If a profile image URL is available, show the circular avatar instead of icon
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 15,
        backgroundImage: NetworkImage(item.imageUrl!),
        backgroundColor: Colors.transparent,
      );
    }

    // ✅ Otherwise, show the default icon (selected or not)
    return Icon(
      isSelected ? item.selectedIcon : item.icon,
      size: 26,
      color: isSelected
          ? (isDarkMode ? AppColors.primaryColor : AppColors.dark)
          : (!isDarkMode ? AppColors.dark : AppColors.primaryColor),
    );
  }

  Widget _buildNavLabel(String label, bool isSelected, double fontSize) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
        color: isSelected
            ? (isDarkMode ? AppColors.primaryColor : AppColors.dark)
            : (!isDarkMode ? AppColors.dark : AppColors.primaryColor),
      ),
    );
  }
}

// ✅ Updated NavItem class
class _NavItem {
  final IconData? icon;
  final IconData? selectedIcon;
  final String label;
  final String? imageUrl;
  final Widget? widget; // new: allows using custom widget icons

  const _NavItem({
    this.icon,
    this.selectedIcon,
    this.widget,
    required this.label,
    this.imageUrl,
  });
}
