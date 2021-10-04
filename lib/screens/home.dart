import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/res/colors.dart';
import 'package:unsplash_gallery/screens/bottom_nav_bar/feed_and_search.dart';
import 'package:unsplash_gallery/screens/bottom_nav_bar/profile.dart';
import 'package:unsplash_gallery/widgets/bottom_nav_bar.dart';
import 'package:unsplash_gallery/res/globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Sponsor? user;
  int currentTab = 0;
  bool isLoading = false;
  List<Photo> photoList = [];

  @override
  void initState() {
    super.initState();
    _getData();
    // _getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    // запрещает поворот изображения при повороте экрана
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final List<BottomNavBarItem> _tabs = [
      BottomNavBarItem(
        asset: FontAwesomeIcons.solidHeart,
        title: Text(S.of(context).navBarItemOne),
        activeColor: AppColors.dodgerBlue,
        inactiveColor: AppColors.manatee,
        textAlign: TextAlign.center,
      ),
      BottomNavBarItem(
        asset: FontAwesomeIcons.search,
        title: Text(S.of(context).navBarItemTwo),
        activeColor: AppColors.dodgerBlue,
        inactiveColor: AppColors.manatee,
        textAlign: TextAlign.center,
      ),
      BottomNavBarItem(
        asset: FontAwesomeIcons.user,
        title: Text(S.of(context).navBarItemThree),
        activeColor: AppColors.dodgerBlue,
        inactiveColor: AppColors.manatee,
        textAlign: TextAlign.center,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: [
          PhotoSearch(photoList, isSearch: false),
          // const FeedScreen(),
          PhotoSearch(photoList, isSearch: true),
          isLoading != true
              ? ProfilePage(user: user!, myProfile: true)
              : const Center(child: CircularProgressIndicator()),
          // const Center(child: ChangeTheme(),),
          // user == null ? const Center(child: CircularProgressIndicator()) : MyProfilePage(user: user!,),
          // isLoading != true ? PhotoListScreen(photoList) : Center(child: CircularProgressIndicator()),
          // isLoading != true ? PhotoSearch(photoList) : Center(child: CircularProgressIndicator()),
          // isLoading != true ? MyProfilePage(user: user!) : Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.ease, // animation
        onItemSelected: (index) async {
          setState(() {
            currentTab = index;
          });
        },
        items: _tabs,
        currentTab: currentTab,
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [],),
    );
  }

  // void _getMyProfile() async {
  //   var tempUser = await DataProvider.getMyProfile();
  //   setState(() {
  //     user = tempUser;
  //     globals.gMyProfile = user;
  //   });
  // }

  void _getData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var tempUser = await DataProvider.getMyProfile();
      PhotoList tempList = await DataProvider.getPhotos(1, 10);

      setState(() {
        user = tempUser;
        globals.gMyProfile = user;
        photoList.addAll(tempList.photos!);
        isLoading = false;
      });
    }
  }
}
