import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/utils/overlays.dart';
import 'package:unsplash_gallery/widgets/about_widget.dart';
import 'package:unsplash_gallery/widgets/buttons/change_theme.dart';
import 'package:unsplash_gallery/widgets/photo.dart';
import 'package:unsplash_gallery/widgets/user_mini_block.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  StreamSubscription? subscription;
  final ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool isLoading = false;
  List<Photo> photoList = [];

  @override
  void initState() {
    super.initState();
    _getData(pageCount);
    subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getData(pageCount);
      }
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(S.of(context).mainTitle), centerTitle: false,
        actions: const [
          ChangeTheme(),
        ],),
      body: _buildFeed(context, photoList),
    );
  }

  _buildFeed (BuildContext context, List<Photo> photoList) => ListView.builder(
    controller: _scrollController,
    itemCount: photoList.length,
    itemBuilder: (context, index) {
      if (index == photoList.length) {
        return Center(
          child: Opacity(
            opacity: isLoading ? 1 : 0,
            child: const CircularProgressIndicator(),
          ),
        );
      }
      return Column(
        children: <Widget>[
          _buildPhotoPost(context, photoList[index]),
          const Divider(
            thickness: 2,
          ),
        ],
      );},
  );

  Widget _buildPhotoPost(context, Photo photo) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: (){_onBigPhotoTap(context, photo);},
                child: BigPhoto(photoLink: photo.urls!.regular!, tag: photo.id!, radius: 17)),
            DetailedBlock(photo, likeButton: true),
            buildAbout(photo, context),
          ]
      ),
    );
  }

  void _onBigPhotoTap(context, photo){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoPage(photo: photo))
    );
  }

  void showConnectivitySnackBar (ConnectivityResult result) async {
    bool hasInternet = false;
    hasInternet = await InternetConnectionChecker().hasConnection;
    final message = hasInternet ? S.of(context).haveInternet : S.of(context).noInternet;

    Overlays.showOverlay(context, Text(message));
  }

  void _getData(int page) async {
    if(!isLoading){
      setState(() {
        isLoading = true;
      });

      PhotoList tempList = await DataProvider.getPhotos(page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }
}
