import 'package:flutter/material.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/res/colors.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/widgets/photo.dart';

class CollectionListScreen extends StatefulWidget {
  const CollectionListScreen(this.collection, {Key? key}) : super(key: key);

  final Collection collection;

  @override
  State<StatefulWidget> createState() => CollectionListScreenState();
}

class CollectionListScreenState extends State<CollectionListScreen> {
  final ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var photoList = <Photo>[];

  @override
  void initState() {
    super.initState();
    _getCollectionPhotos(widget.collection.id!, pageCount);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getCollectionPhotos(widget.collection.id!, pageCount);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.collection.title ?? S.of(context).defaultColName,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
            onPressed: () => _onButtonPressed(),
          )
        ],
      ),
      body: _buildListView(context, photoList),
    );
  }

  Widget _buildListView(BuildContext context, List<Photo> photoList) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: photoList.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      controller: _scrollController,
      itemBuilder: (context, i) {
        if (i == photoList.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildPhoto(photoList[i]);
      },
    );
  }

  Widget _buildPhoto(Photo photo) {
    return GestureDetector(
      onTap: () {
        _onBigPhotoTap(context, photo);
      },
      child: BigPhoto(
        photoLink: photo.urls!.regular!,
        tag: 'colItem_${photo.id}',
        radius: 0,
      ),
    );
  }

  void _getCollectionPhotos(String id, int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotosByCollection(id, page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _onBigPhotoTap(context, photo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPage(
                  photo: photo,
                  tag: 'colItem_${photo.id}',
                )));
  }

  void _onButtonPressed() {
    {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
          context: context,
          builder: (context) {
            return SafeArea(
              child: Wrap(
                // совместно с isScrollControlled позволяет контролировать высотку ботом шита
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          S.of(context).delete,
                          style: const TextStyle(color: AppColors.red),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      );
                      overlayState!.insert(overlayEntry);
                      int response = await DataProvider.deleteCollection(
                          widget.collection.id!);
                      Navigator.pop(context);
                      overlayEntry.remove();
                      response >= 200 && response < 300
                          ? Navigator.pop(context)
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.of(context).tryLater),
                              // TODO: here we can delete collection from array, cause on Profile screen collections will not upgraded,
                              // so if I try to click on deleted collection... ERROR
                            ));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [Text(S.of(context).cancel)],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  )
                ],
              ),
            );
          });
    }
  }
}
