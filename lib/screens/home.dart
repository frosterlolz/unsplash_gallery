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
import 'package:unsplash_gallery/widgets/buttons/change_theme.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
      // BottomNavBarItem(
      //   asset: FontAwesomeIcons.plus,
      //   title: Text(S.of(context).navBarItemThree),
      //   activeColor: AppColors.dodgerBlue,
      //   inactiveColor: AppColors.manatee,
      //   textAlign: TextAlign.center,
      // ),
    ];

    return Scaffold(
      appBar: currentTab == 2
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40), child: _buildAppBar())
          : null,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        margin: const EdgeInsets.only(top: 60),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25)),
          child: Drawer(
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ListTile(
                          title: Text(
                        user == null ? '' : user!.name!,
                        style: const TextStyle(fontSize: 18),
                      )),
                      const Divider(
                        thickness: 1.0,
                      ),
                      ListTile(
                        onTap: clearCache,
                          title: Row(children: [
                        const Icon(Icons.cached_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(S.of(context).clearCache)
                      ])),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Column(children: [
                      const Divider(
                        thickness: 1.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.settings_outlined),
                              const SizedBox(width: 5.0),
                              Text(S.of(context).settings),
                            ],
                          ),
                          const ChangeTheme(),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: IndexedStack(
        index: currentTab,
        children: [
          PhotoSearch(photoList, isSearch: false),
          // const FeedScreen(),
          PhotoSearch(photoList, isSearch: true),
          isLoading != true
              ? ProfilePage(user: user!, myProfile: true)
              : const Center(child: CircularProgressIndicator()),
          // isLoading != true
          //     ? RefreshScreen(user: user!, myProfile: true)
          //     : const Center(child: CircularProgressIndicator()),
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
    );
  }

  Widget _buildAppBar() => AppBar(
        title: Text(
          // TODO: change this
          user == null ? 'username Null' : user!.username!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0,
      );

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

  void clearCache() async {
    await DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
  }
}
