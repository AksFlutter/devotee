import 'package:devotee/chat/api/apis.dart';
import 'package:devotee/chat/screens/chat_home_screen.dart';
import 'package:devotee/constants/color_constant.dart';
import 'package:devotee/constants/font_constant.dart';
import 'package:devotee/controller/edit_profile_controller.dart';
import 'package:devotee/controller/inbox_received_controller.dart';
import 'package:devotee/controller/inbox_sent_controller.dart';
import 'package:devotee/pages/dashboard/profile/edit_profile/edit_profile.dart';
import 'package:devotee/pages/dashboard/home/home_page.dart';
import 'package:devotee/pages/dashboard/inbox/inbox.dart';
import 'package:devotee/pages/dashboard/profile/my_shortlist_profile/my_shortlist_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../constants/widget/dialog.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../utils/connection_check/connectivity_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // PageController controller = PageController(initialPage: 4);
  var selected = 0;
  final EditProfileController _editProfileController =
      Get.put(EditProfileController());
  final InboxSentController inboxSentController =
      Get.put(InboxSentController());
  final InboxReceivedController inboxReceivedController =
      Get.put(InboxReceivedController());
  final ConnectivityService connectivityService =
      Get.put(ConnectivityService());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  void login() async {
    if (_editProfileController.member!.member!.matriID != null) {
      if (await APIs.userExists() && mounted) {
      } else {
        await APIs.createUser().then((value) {});
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _editProfileController.userDetails(context).then((value) => login());
    inboxSentController.inboxSent(context, "Pending");
    inboxReceivedController.inboxSent(context, "Pending");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            // Show the confirmation dialog
            bool shouldExit =
                await DialogConstant.showExitConfirmationDialog(context);
            return shouldExit;
          },
          child: PageView(
            controller: dashboardController.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Inbox(),
              ProfileEdit(),
              MyShorlistProfile(),
              HomeScreen(),
              Home(),
            ],
          )),
      bottomNavigationBar: StylishBottomBar(
        notchStyle: NotchStyle.circle,
        backgroundColor: AppColors.primaryColor,
        option: AnimatedBarOptions(
          iconSize: 30,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.Default,
        ),
        items: [
          BottomBarItem(
            icon: Image.asset(
              "assets/images/email.png",
              height: 28,
              width: 28,
            ),
            title: Text(
              'inbox',
              style:
                  FontConstant.styleSemiBold(fontSize: 0, color: Colors.white),
            ),
            backgroundColor: Colors.white,
            //  selectedIcon: Icon(Icons.chat)
          ),
          BottomBarItem(
            icon: Image.asset(
              "assets/images/users.png",
              height: 28,
              width: 24,
            ),
            title: Text(
              'Profile',
              style:
                  FontConstant.styleSemiBold(fontSize: 0, color: Colors.white),
            ),
            backgroundColor: Colors.white,
            //  selectedIcon: Icon(Icons.person)
          ),
          BottomBarItem(
            icon: Image.asset(
              "assets/images/love.png",
              height: 28,
              width: 28,
            ),
            title: Text(
              'Liked',
              style:
                  FontConstant.styleSemiBold(fontSize: 0, color: Colors.white),
            ),
            backgroundColor: Colors.white,
            // selectedIcon: Icon(Icons.favorite)
          ),
          BottomBarItem(
            icon: Image.asset(
              "assets/images/chat.png",
              height: 28,
              width: 30,
            ),
            title: Text(
              'Search',
              style:
                  FontConstant.styleSemiBold(fontSize: 0, color: Colors.white),
            ),
            // backgroundColor: Colors.white,
          ),
        ],
        fabLocation: StylishBarFabLocation.center,
        hasNotch: true,
        currentIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
            dashboardController.navigateToPage(index);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            dashboardController.navigateToPage(4);
          });
        },
        backgroundColor: const Color(0xff583689),
        child: const Icon(
          Icons.home_outlined,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
