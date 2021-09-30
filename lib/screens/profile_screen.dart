// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:unsplash_gallery/data_provider.dart';
// import 'package:unsplash_gallery/generated/l10n.dart';
// import 'package:unsplash_gallery/models/model.dart';
// import 'package:unsplash_gallery/res/colors.dart';
// import 'package:unsplash_gallery/screens/collection_screen.dart';
// import 'package:unsplash_gallery/widgets/collection_widget.dart';
// import 'package:unsplash_gallery/widgets/header_widget.dart';
// import 'package:unsplash_gallery/widgets/photo.dart';
//
// class Profile extends StatefulWidget {
//   const Profile(this.userProfile, {Key? key}) : super(key : key);
//
//   final Sponsor userProfile;
//
//   @override
//   State<StatefulWidget> createState() => ProfileState();
// }
//
// class ProfileState extends State<Profile> with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   final ScrollController _horizontalController = ScrollController();
//   late Sponsor _userProfile;
//   int colPageCount = 1;
//   int pageCount = 1;
//   bool isLoading = false;
//   bool isLoadingCol = false;
//   List<Photo> userPhotos = [];
//   List<Collection> collectionsList = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _getCollectionsByUser(_userProfile.username!, colPageCount);
//
//
//     _userProfile = widget.userProfile;
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent * 0.8) {
//         _getPhotoByUser(_userProfile.username!, pageCount);
//       }
//     });
//     _horizontalController.addListener(() {
//       if (_horizontalController.position.pixels >=
//           _horizontalController.position.maxScrollExtent * 0.8) {
//         _getCollectionsByUser(_userProfile.username!, colPageCount);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _horizontalController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   final List<Tab> _tabs = const [
//     Tab(
//       icon: Icon(
//         Icons.grid_on_sharp,
//         color: Colors.black,
//       ),
//     ),
//     Tab(
//       icon: Icon(
//         FontAwesomeIcons.heart,
//         color: Colors.black,
//       ),
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) => Builder(
//     builder: (context) => Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(40),
//           child: _buildAppBar()
//       ),
//       body: _buildTabController()
//     ),
//   );
//
//   Widget _buildAppBar() => Container(
//     decoration: const BoxDecoration(
//       border: Border(
//         bottom: BorderSide(
//           color: AppColors.mercury,
//         ),
//       ),
//     ),
//     child: AppBar(
//       // backgroundColor: AppColors.white,
//       title: Text(S.of(context).mainTitle,
//         style: const TextStyle(
//             color: AppColors.black,
//             fontWeight: FontWeight.w600,
//             fontStyle: FontStyle.italic,
//         ),
//       ),
//       centerTitle: false,
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       actions: [
//         // IconButton(icon: Icon(Icons.add_box_outlined, color: Colors.black,),
//         //   onPressed: () => print("Add"),),
//         IconButton(icon: const Icon(Icons.menu, color: Colors.black,),
//           onPressed: () => _onButtonPressed(),)
//       ],
//     ),
//   );
//
//   Widget _buildTabController() => DefaultTabController(
//     length: 3,
//     child: Stack(
//       children: [
//         Container(
//           height: 200.0,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors:[AppColors.dodgerBlue, AppColors.alto]
//             ),
//           ),
//         ),
//         NestedScrollView(
//             controller: _scrollController,
//             headerSliverBuilder: (context, _){
//               return [
//                 SliverList(
//                     delegate: SliverChildListDelegate(
//                         [
//                           _mainListBuilder(context, collectionsList),
//                         ]
//                     )
//                 ),
//               ];
//             },
//             body: Column(
//               children: <Widget>[
//                 Material(
//                   color: Colors.white,
//                   child: TabBar(
//                     labelColor: Colors.black,
//                     unselectedLabelColor: Colors.grey[400],
//                     indicatorWeight: 1,
//                     indicatorColor: Colors.black,
//                     tabs: _tabs,
//                   ),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     children: [
//                       // userPhotos.isEmpty
//                       //     ? Container(color: Colors.white,
//                       //     child: Center(child: Text(S.of(context).noPhotos),))
//                       //     : _gallery(userPhotos),
//                       // likedPhotos.isEmpty
//                       //     ? Container(color: Colors.white,
//                       //     child: Center(child: Text(S.of(context).noLikedPhotos),))
//                       //     : _gallery(likedPhotos),
//                       // Container(),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//         ),
//       ],
//     ),
//   );
//
//   Widget _mainListBuilder(BuildContext context, List<Collection> collections) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildHeader(context, _userProfile),
//         collections.isEmpty ? Container() :_buildSectionHeader(context),
//         collections.isEmpty ? Container() :_buildCollectionsRow(context, collections),
//       ],
//     );
//   }
//
//   Widget _buildCollectionsRow(context, List<Collection> collections) {
//     return Container(
//       height: 85.0,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       color: AppColors.white,
//       child: ListView.builder(
//         shrinkWrap: true,
//         controller: _horizontalController,
//         scrollDirection: Axis.horizontal,
//         itemCount: collections.length,
//         itemBuilder: (context, int index) {
//           return collections.isEmpty
//               ? const CircularProgressIndicator()
//               : GestureDetector(
//             onTap: (){ setState((){
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CollectionListScreen(collections[index])
//                   ));});},
//             child: CollectionWidget(
//                 photoLink: collections[index].coverPhoto!.urls!.small!,
//                 title: collections[index].title ?? ''),
//           );
//           },
//       ),
//     );
//   }
//
//   Widget _gallery() => Scaffold(
//     body: GridView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         if (index == userPhotos.length) {
//           return Center(
//             child: Opacity(
//               opacity: isLoading ? 1 : 0,
//               child: const CircularProgressIndicator(),
//             ),
//           );
//         }
//         return BigPhoto(
//             photoLink: userPhotos[index].urls!.regular!,
//             radius: 0, tag: 'grid_${userPhotos[index].id}');
//         },
//       itemCount: userPhotos.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//       ),
//     ),
//   );
//
//   Container _buildSectionHeader(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             S.of(context).collections,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onButtonPressed() {
//     {
//       showModalBottomSheet(
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 topRight: Radius.circular(25),
//               )
//           ),
//           context: context,
//           builder: (context){
//             return SafeArea(
//               child: Wrap( // совместно с isScrollControlled позволяет контролировать высотку ботом шита
//                 children: <Widget>[
//                   ListTile(
//                     title: Center(child: Text(S.of(context).clearCache)),
//                     onTap: clearCache,
//                   ),
//                 ],
//               ),
//             );
//           });
//     }
//   }
//
//   void clearCache() {
//
//     DefaultCacheManager().emptyCache();
//     imageCache!.clear();
//     imageCache!.clearLiveImages();
//     setState(() {});
//   }
//
//   void _getPhotoByUser(String nickname, int page) async {
//     if (!isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//       var tempList = await DataProvider.getPhotoByUser(nickname, page, 10);
//
//       setState(() {
//         isLoading = false;
//         userPhotos.addAll(tempList.photos!);
//         pageCount++;
//       });
//     }
//   }
//
//   void _getCollectionsByUser(String username, int page) async {
//     if (!isLoadingCol) {
//       setState(() {
//         isLoadingCol = true;
//       });
//       var tempList = await DataProvider.getCollectionsByUser(username, page, 10);
//
//       setState(() {
//         isLoadingCol = false;
//         collectionsList.addAll(tempList.collections!);
//         colPageCount++;
//       });
//     }
//   }
//
//   void init (String username) async {
//     if (!isLoadingCol) {
//       setState(() {
//         isLoadingCol = true;
//       });
//       var tempList = await DataProvider.getPhotoByUser(username, 0, 10);
//       var tempColList = await DataProvider.getCollectionsByUser(username, 0, 10);
//
//       setState(() {
//         isLoadingCol = false;
//         userPhotos.addAll(tempList.photos!);
//         collectionsList.addAll(tempColList.collections!);
//         colPageCount++;
//         pageCount++;
//       });
//     }
//   }
//
// }