import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/utils/overlays.dart';
import 'package:unsplash_gallery/widgets/photo_post/build_post.dart';
import 'package:unsplash_gallery/widgets/refresh_widget.dart';
import 'package:unsplash_gallery/widgets/search_widget.dart';

class PhotoSearch extends StatefulWidget {
  final List<Photo> defaultList;
  final bool isSearch;

  const PhotoSearch(this.defaultList, {Key? key, this.isSearch = false})
      : super(key: key);

  @override
  _PhotoSearchState createState() => _PhotoSearchState();
}

class _PhotoSearchState extends State<PhotoSearch> {
  StreamSubscription? subscription;
  final ScrollController _scrollController = ScrollController();
  int pageCount = 2;
  bool isLoading = false;
  List<Photo> photoList = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    photoList = widget.defaultList;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        query == '' ? _getData(pageCount) : _getSearchData(query, pageCount);
      }
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    debouncer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void debounce(VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title:
          widget.isSearch ? buildSearch() : Text(S
              .of(context)
              .mainTitle),
          centerTitle: widget.isSearch,
        ),
        body: _buildFeed(context, photoList),
        // body: RefreshWidget(
        //   onRefresh: _getDataRefresh,
        //   child: _buildFeed(context, photoList),
        // ),
      );

  _buildFeed(BuildContext context, List<Photo> photoList) =>
      ListView.builder(
        shrinkWrap: true,
        primary: false,
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
              buildPhotoPost(
                context,
                photoList[index],
                widget.isSearch,
              ),
              const Divider(thickness: 2),
            ],
          );
        },
      );

  void showConnectivitySnackBar(ConnectivityResult result) async {
    bool hasInternet = false;
    hasInternet = await InternetConnectionChecker().hasConnection;
    final message =
    hasInternet ? S
        .of(context)
        .haveInternet : S
        .of(context)
        .noInternet;

    Overlays.showOverlay(context, Text(message));
  }

  Future<void> _getData(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotos(page, 10);
      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _getSearchData(String query, int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getSearchPhoto(query, page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  Widget buildSearch() =>
      SearchWidget(
        text: query,
        hintText:
        '${S
            .of(context)
            .search} ${S
            .of(context)
            .photo
            .toLowerCase()}',
        onChanged: searchPhoto,
      );

  Future searchPhoto(String query) async =>
      debounce(() async {
        final data = (query == ''
            ? await DataProvider.getPhotos(1, 10)
            : await DataProvider.getSearchPhoto(query, 1, 10));
        if (!mounted) return;
        setState(() {
          pageCount = 2;
          this.query = query;
          photoList = data.photos!;
        });
      });

  Future<void> _getDataRefresh() async {
    {
      print('refresh works fine');
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        var tempList = await DataProvider.getPhotos(1, 10);
        setState(() {
          isLoading = false;
          photoList = [];
          photoList.addAll(tempList.photos!);
          pageCount++;
        });
      }
    }
  }
}