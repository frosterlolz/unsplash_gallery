import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/res/colors.dart';
import 'package:unsplash_gallery/screens/collection_screen.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/widgets/collection_widget.dart';
import 'package:unsplash_gallery/widgets/header_widget.dart';
import 'package:unsplash_gallery/widgets/photo.dart';
import 'package:unsplash_gallery/widgets/text_field_widget.dart';

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
  late StreamSubscription subscription;
  // final RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  int pageCollectionsCount = 1;
  int pageCount = 1;
  int pageLikedCount = 1;
  bool isLoading = false;
  bool isLoadingCol = false;
  List<Photo> userPhotos = [];
  List<Photo> userLikedPhotos = [];
  List<Collection> userColList = [];
  int currentTab = 0;
  String title = '';
  String description = '';
  bool _isPrivate = false;
  final List<Tab> _tabs = const [
    Tab(
      icon: Icon(
        Icons.grid_on_sharp,
      ),
    ),
    Tab(
      icon: Icon(
        FontAwesomeIcons.heart,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    init(
        widget.user.username!, pageCount, pageCollectionsCount, pageLikedCount);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        switch (currentTab) {
          case 0:
            _getPhotoByUser(pageCount);
            break;
          case 1:
            _getLikedPhotoByUser(pageLikedCount);
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Container(
              height: 200.0,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.5,
                  colors: [AppColors.alto, AppColors.dodgerBlue],
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        _mainListBuilder(context, userColList),
                      ])),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TabBar(
                          onTap: (index) => setState(() {
                            currentTab = index;
                          }),
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Center(
                                      child: Text(S.of(context).noPhotos),
                                    ),
                                  )
                                : _gallery(userPhotos),
                            userLikedPhotos.isEmpty
                                ? Container(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Center(
                                      child: Text(S.of(context).noLikedPhotos),
                                    ),
                                  )
                                : _gallery(userLikedPhotos),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
        collections.isEmpty
            ? Container()
            : _buildCollectionsRow(context, collections),
      ],
    );
  }

  Widget _buildCollectionsRow(context, List<Collection> collections) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 85.0,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(S.of(context).addCollection),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) =>
                                  SizedBox(
                            height: MediaQuery.of(context).size.height - 650,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFieldWidget(
                                  text: '',
                                  label: S.of(context).title,
                                  onChanged: (value) {
                                    title = value;
                                  },
                                ),
                                TextFieldWidget(
                                  onChanged: (value) {
                                    description = value;
                                  },
                                  text: '',
                                  label: S.of(context).description,
                                ),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(S.of(context).privateCollection),
                                  subtitle: Text(_isPrivate
                                      ? S.of(context).yes
                                      : S.of(context).no),
                                  value: _isPrivate,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isPrivate = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(S.of(context).create),
                            onPressed: () async {
                              // Navigator.of(context).pop();
                              OverlayState? overlayState = Overlay.of(context);
                              OverlayEntry overlayEntry = OverlayEntry(
                                builder: (context) => Positioned(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width, // получаем width всего экрана
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 16),
                                        decoration: BoxDecoration(
                                          // color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              overlayState!.insert(overlayEntry);
                              var tempCollection =
                                  await DataProvider.addCollection(
                                      title: title,
                                      description: description,
                                      private: _isPrivate);
                              Collection collection = tempCollection;
                              overlayEntry.remove();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CollectionListScreen(collection)));
                            },
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(S.of(context).cancel))
                        ],
                      )),
              child: const CollectionWidget(photoLink: '', title: 'Add'),
            ),
            ListView.builder(
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
                  onLongPress: () {
                    // TODO: delete collection and delete from array
                    print('1');
                  },
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CollectionListScreen(collections[index])));
                    });
                  },
                  child: CollectionWidget(
                      // TODO: default image... may be gray font
                      photoLink: collections[index].coverPhoto?.urls?.small ??
                          'https://i.pinimg.com/originals/d8/42/e2/d842e2a8aecaffff34ae744a96896ac9.jpg',
                      title: collections[index].title ?? ''),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _gallery(List<Photo> photoList) => Scaffold(
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoPage(
                            photo: photoList[index],
                            tag: widget.myProfile
                                ? 'mine_${photoList[index].id}'
                                : 'general_${photoList[index].id}')));
              },
              child: BigPhoto(
                  photoLink: photoList[index].urls!.regular!,
                  radius: 0,
                  tag: widget.myProfile
                      ? 'mine_${photoList[index].id}'
                      : 'general_${photoList[index].id}'),
            );
          },
        ),
      );

  // void _onButtonPressed() {
  //   showAdaptiveActionSheet(
  //       context: context,
  //       actions: [
  //         BottomSheetAction(
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(S.of(context).changeTheme),
  //                 const ChangeTheme(),
  //               ],
  //             ),
  //             onPressed: () {}),
  //         BottomSheetAction(
  //           title: Text(S.of(context).clearCache),
  //           onPressed: clearCache,
  //         ),
  //       ],
  //       cancelAction: CancelAction(title: Text(S.of(context).cancel)));

  // showModalBottomSheet(
  //   constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width - 30),
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(25),
  //       topRight: Radius.circular(25),
  //     )),
  //     context: context,
  //     builder: (context) {
  //       return SafeArea(
  //         child: Wrap(
  //           // совместно с isScrollControlled позволяет контролировать высотку ботом шита
  //           children: <Widget>[
  //             ListTile(
  //               title: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(S.of(context).changeTheme),
  //                   const ChangeTheme(),
  //                 ],
  //               ),
  //               onTap: () {},
  //             ),
  //             Divider(),
  //             ListTile(
  //               title: Text(S.of(context).clearCache),
  //               onTap: clearCache,
  //             ),
  //             Divider(),
  //           ],
  //         ),
  //       );
  //     });
  // }

  void init(String username, page, colPage, likedPage) async {
    setState(() {
      isLoading = true;
      isLoadingCol = true;
    });
    PhotoList tempPhotosList =
        await DataProvider.getPhotoByUser(username, page, 10);
    CollectionList tempCollectionsList =
        await DataProvider.getCollectionsByUser(username, colPage, 10);
    PhotoList tempLikedPhotos =
        await DataProvider.getLikedPhotoByUser(username, likedPage, 10);

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

  void _getPhotoByUser(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList =
          await DataProvider.getPhotoByUser(widget.user.username!, page, 10);

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
      var tempList = await DataProvider.getCollectionsByUser(
          widget.user.username!, page, 10);

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
      var tempList = await DataProvider.getLikedPhotoByUser(
          widget.user.username!, page, 10);

      setState(() {
        isLoading = false;
        userLikedPhotos.addAll(tempList.photos!);
        pageLikedCount++;
      });
    }
  }
  //
  // void _onRefresh() async {
  //   setState(() {
  //     isLoading = true;
  //     isLoadingCol = true;
  //   });
  //   PhotoList tempPhotosList =
  //       await DataProvider.getPhotoByUser(widget.user.username!, 1, 10);
  //   CollectionList tempCollectionsList =
  //       await DataProvider.getCollectionsByUser(widget.user.username!, 1, 10);
  //   PhotoList tempLikedPhotos =
  //       await DataProvider.getLikedPhotoByUser(widget.user.username!, 1, 10);
  //
  //   if (mounted) {
  //     setState(() {
  //       pageCollectionsCount++;
  //       pageCount++;
  //       pageLikedCount++;
  //       userPhotos = [];
  //       userColList = [];
  //       userLikedPhotos = [];
  //       userPhotos.addAll(tempPhotosList.photos!);
  //       userColList.addAll(tempCollectionsList.collections!);
  //       userLikedPhotos.addAll(tempLikedPhotos.photos!);
  //       isLoading = false;
  //       isLoadingCol = false;
  //     });
  //   }
  //   _refreshController.loadComplete();
  // }
}
