import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/res/colors.dart';
import 'package:unsplash_gallery/screens/collection_screen.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/widgets/buttons/change_theme.dart';
import 'package:unsplash_gallery/widgets/collection_widget.dart';
import 'package:unsplash_gallery/widgets/header_widget.dart';
import 'package:unsplash_gallery/widgets/photo.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.user,
    this.myProfile = false,
  }) : super(key: key);

  final Sponsor user;
  final bool myProfile;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  int pageCollectionsCount = 1;
  int pageCount = 1;
  int pageLikedCount = 1;
  bool isLoading = false; // photos+LikedPhotos
  bool isLoadingCol = false; // collections
  List<Photo> userPhotos = [];
  List<Photo> userLikedPhotos = [];
  List<Collection> userColList = [];
  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    init(widget.user.username!, pageCount, pageCollectionsCount, pageLikedCount);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        switch(currentTab) {
          case 0: _getPhotoByUser(pageCount);
          break;
          case 1: _getLikedPhotoByUser(pageLikedCount);
          break;
        }
      }
    });
    _horizontalController.addListener(() {
      if (_horizontalController.position.pixels >=
          _horizontalController.position.maxScrollExtent * 0.8) {
        _getCollectionsByUser(pageCollectionsCount);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  final List<Tab> _tabs = const [
    Tab(
      icon: Icon(
        Icons.grid_on_sharp,
        // color: Colors.black,
      ),
    ),
    Tab(
      icon: Icon(
        FontAwesomeIcons.heart,
        // color: Colors.black,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: _buildAppBar()
        ),
        body: _buildTabController()
    ),
  );

  Widget _buildAppBar() => Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          // color: AppColors.mercury,
        ),
      ),
    ),
    child: AppBar(
      title: Text(widget.user.username ?? 'username Null',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        const ChangeTheme(),
        IconButton(icon: const Icon(Icons.menu,
          // color: Colors.black,
        ),
          onPressed: () => _onButtonPressed(),)
      ],
    ),
  );

  Widget _buildTabController() => DefaultTabController(
    length: 2,
    child: Stack(
      children: [
        Container(
          height: 200.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors:[AppColors.dodgerBlue, AppColors.alto]
            ),
          ),
        ),
        NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _){
              return [
                SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          _mainListBuilder(context, userColList),
                        ]
                    )
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                Material(
                  // color: Colors.white,
                  child: TabBar(
                    onTap:(index) async { // why here was async...
                      setState(() {currentTab = index;});
                    },
                    // labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorWeight: 1,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: _tabs,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      userPhotos.isEmpty
                          ? Container(
                            color: Theme.of(context).canvasColor,
                            child: Center(child: Text(S.of(context).noPhotos),))
                          : _gallery(userPhotos),
                      userLikedPhotos.isEmpty
                          ? Container(
                            color: Theme.of(context).canvasColor,
                            child: Center(child: Text(S.of(context).noLikedPhotos),))
                          : _gallery(userLikedPhotos),
                      // Container(),
                    ],
                  ),
                ),
              ],
            )
        ),
      ],
    ),
  );

  Widget _mainListBuilder(BuildContext context, List<Collection> collections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: попробовать изменить на isLoading чтобы была имитация загрузки и если коллекций нет - ...
        buildHeader(context, widget.user),
        // collections.isEmpty ? Container() :_buildSectionHeader(context),
        collections.isEmpty ? Container() :_buildCollectionsRow(context, collections),
      ],
    );
  }

  Widget _buildCollectionsRow(context, List<Collection> collections) {
    return Container(
      height: 85.0,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: ListView.builder(
        shrinkWrap: true,
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (context, int index) {
          if (index == collections.length) {
            return Center(
              child: Opacity(
                opacity: isLoading ? 1 : 0,
                child: const CircularProgressIndicator(),
              ),
            );
          }
          return GestureDetector(
            onTap: (){ setState((){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionListScreen(collections[index])
                  ));});},
            child: CollectionWidget(
                // TODO: default image... may be gray font
                photoLink: collections[index].coverPhoto?.urls?.small
                    ?? 'https://i.pinimg.com/originals/d8/42/e2/d842e2a8aecaffff34ae744a96896ac9.jpg',
                title: collections[index].title ?? ''),
          );
          },
      ),
    );
  }

  Widget _gallery(List<Photo> photoList) => Scaffold(
    body: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: photoList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == photoList.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return GestureDetector(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoPage(photo: photoList[index]))
          );},
          child: BigPhoto(
              photoLink: photoList[index].urls!.regular!,
              radius: 0, tag: 'grid_${photoList[index].id}'),
        );
      },
    ),
  );

  // Container _buildSectionHeader(BuildContext context) {
  //   return Container(
  //     // color: Colors.white,
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Text(
  //           S.of(context).collections,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _onButtonPressed() {
    {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )
          ),
          context: context,
          builder: (context){
            return SafeArea(
              child: Wrap( // совместно с isScrollControlled позволяет контролировать высотку ботом шита
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text(S.of(context).clearCache)),
                    onTap: clearCache,
                  ),
                ],
              ),
            );
          });
    }
  }

  void init(String username, page, colPage, likedPage) async {
    setState(() {
      isLoading = true;
      isLoadingCol = true;
    });
    PhotoList tempPhotosList = await DataProvider.getPhotoByUser(
        username, page, 10);
    CollectionList tempCollectionsList = await DataProvider.getCollectionsByUser(
        username, colPage, 10);
    PhotoList tempLikedPhotos = await DataProvider.getLikedPhotoByUser(
        username, likedPage, 10);

    setState(() {
      pageCollectionsCount++;
      pageCount++;
      pageLikedCount++;
      userPhotos.addAll(tempPhotosList.photos!);
      userColList.addAll(tempCollectionsList.collections!);
      userLikedPhotos.addAll(tempLikedPhotos.photos!);
      isLoading = false;
      isLoadingCol = false;
    });
  }

  void clearCache() {

    DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
  }

  void _getPhotoByUser(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotoByUser(widget.user.username!, page, 10);

      setState(() {
        isLoading = false;
        userPhotos.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _getCollectionsByUser(int page) async {
    if (!isLoadingCol) {
      setState(() {
        isLoadingCol = true;
      });
      var tempList = await DataProvider.getCollectionsByUser(widget.user.username!, page, 10);

      setState(() {
        isLoadingCol = false;
        userColList.addAll(tempList.collections!);
        pageCollectionsCount++;
      });
    }
  }

  void _getLikedPhotoByUser(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getLikedPhotoByUser(widget.user.username!, page, 10);

      setState(() {
        isLoading = false;
        userLikedPhotos.addAll(tempList.photos!);
        pageLikedCount++;
      });
    }
  }
}
