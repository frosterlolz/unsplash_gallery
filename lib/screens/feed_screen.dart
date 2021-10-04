// import 'dart:async';
//
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:unsplash_gallery/data_provider.dart';
// import 'package:unsplash_gallery/generated/l10n.dart';
// import 'package:unsplash_gallery/models/model.dart';
// import 'package:unsplash_gallery/utils/overlays.dart';
// import 'package:unsplash_gallery/widgets/buttons/change_theme.dart';
// import 'package:unsplash_gallery/widgets/photo_post/build_post.dart';
//
// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);
//
//   @override
//   _FeedScreenState createState() => _FeedScreenState();
// }
//
// class _FeedScreenState extends State<FeedScreen> {
//   StreamSubscription? subscription;
//   final ScrollController _scrollController = ScrollController();
//   int pageCount = 2;
//   bool isLoading = false;
//   List<Photo> photoList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     subscription =
//         Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent * 0.8) {
//         _getData(pageCount);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     // debouncer?.cancel();
//     subscription!.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   // void debounce(VoidCallback callback, {
//   //   Duration duration = const Duration(milliseconds: 1000),
//   // }) {
//   //   if (debouncer != null) {
//   //     debouncer!.cancel();
//   //   }
//   //
//   //   debouncer = Timer(duration, callback);
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Text(S
//             .of(context)
//             .mainTitle),
//         centerTitle: false,
//         actions: const [
//           // _search(),
//           ChangeTheme(),
//         ],),
//       body: _buildFeed(context, photoList),
//     );
//   }
//
//   _buildFeed(BuildContext context, List<Photo> photoList) =>
//       ListView.builder(
//         controller: _scrollController,
//         itemCount: photoList.length,
//         itemBuilder: (context, index) {
//           if (index == photoList.length) {
//             return Center(
//               child: Opacity(
//                 opacity: isLoading ? 1 : 0,
//                 child: const CircularProgressIndicator(),
//               ),
//             );
//           }
//           return Column(
//             children: <Widget>[
//               buildPhotoPost(context, photoList[index]),
//               const Divider(thickness: 2),
//             ],
//           );
//         },
//       );
//
//   void showConnectivitySnackBar(ConnectivityResult result) async {
//     bool hasInternet = false;
//     hasInternet = await InternetConnectionChecker().hasConnection;
//     final message = hasInternet ? S
//         .of(context)
//         .haveInternet : S
//         .of(context)
//         .noInternet;
//
//     Overlays.showOverlay(context, Text(message));
//   }
//
//   void _getData(int page) async {
//     if (!isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//
//       PhotoList tempList = await DataProvider.getPhotos(page, 10);
//
//       setState(() {
//         isLoading = false;
//         photoList.addAll(tempList.photos!);
//         pageCount++;
//       });
//     }
//   }
// }
//
//
//
// // mb can do beauty search
//
// //   Widget _search() {
// //     return IconButton(
// //       tooltip: S.of(context).search,
// //       icon: const Icon(Icons.search),
// //       onPressed: () {
// //         showSearch(context: context, delegate: SearchPhoto());
// //       },
// //     );
// //   }
// // }
//
// // class SearchPhoto extends SearchDelegate<Photo?>{
// //
// //   @override
// //   List<Widget>? buildActions(BuildContext context) => [IconButton(
// //     icon: const Icon(Icons.clear), onPressed: (){
// //       query = '';
// //   })];
// //
// //   @override
// //   Widget? buildLeading(BuildContext context) => IconButton(
// //       icon: AnimatedIcon(
// //         icon: AnimatedIcons.menu_arrow,
// //         progress: transitionAnimation,),
// //         onPressed: (){
// //         close(context, null);
// //         });
// //
// //   @override
// //   Widget buildResults(BuildContext context) {
// //     // сюда запихаем то, что должно отобразиться при нажатии на резалт ниже
// //     // TODO: implement buildResults
// //     throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildSuggestions(BuildContext context) {
// //     final suggestion = query.isEmpty
// //         ? Center(child: Text('Preview'))
// //         : Center(child: Text('Its too hard for me now('));
// //
// //     return suggestion; // we can add here ListView.builder
// //   }
// // }
