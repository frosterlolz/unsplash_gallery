import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/res/colors.dart';
import 'package:unsplash_gallery/res/styles.dart';
import 'package:unsplash_gallery/utils/only_like.dart';
import 'package:unsplash_gallery/utils/sheets.dart';
import 'package:unsplash_gallery/widgets/buttons/like_button.dart';
import 'package:unsplash_gallery/widgets/photo.dart';
import 'package:unsplash_gallery/widgets/user_mini_block.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.photo}) : super(key: key);

  final Photo photo;

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> bottomSheetList = <Widget>[
      ListTile(
        title: Center(child: Text(S.of(context).clearCache)),
        onTap: _clearCache,
      ),
    ];
    Photo photo = widget.photo;
    return Scaffold(
        appBar: _buildAppBar(photo, bottomSheetList),
        body: SingleChildScrollView(
          child: buildPage(photo),
        )
    );
  }

  _buildAppBar(photo, bottomSheetList) => AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: (){Navigator.pop(context);},),
    elevation: 0, // delete shadow if zero
    title: Text(photo.id!,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        // color: Colors.black
      ),
    ),
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        onPressed: () => Sheets.showBottomModalSheet(context, bottomSheetList),
        icon: const Icon(Icons.more_vert_outlined,
          // color: AppColors.grayChateau,
        ),
      ),
    ],
  );

  Widget buildPage(photo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onDoubleTap: (){setState(() {
              onlyLike(photo.id!, photo.likedByUser!, photo.likes!);
            });},
            child: BigPhoto(photoLink: photo.urls!.regular!, tag: photo.id, radius: 17,)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(photo.description ?? S.of(context).defaultDescription, maxLines: 3,
            overflow: TextOverflow.ellipsis,
            // style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
          ),),
        DetailedBlock(photo),
        _functionsBlock(photo),
        const Padding(padding: EdgeInsets.only(top: 20)),
      ],
    );
  }

  Widget _functionsBlock(photo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LikeButton(photo.likedByUser!, photo.likes!, photo.id!),),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(icon: const Icon(Icons.share), onPressed: (){Share.share(photo.urls!.full!);},),),
          Expanded(
              child: _buildButton(S.of(context).save, (){
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(S.of(context).downloadTitle,
                    // style: TextStyle(color: AppColors.manatee, fontSize: 13),
                  ),
                  content: Text(S.of(context).downloadingSure),
                  actions: [
                    TextButton(onPressed: () async {
                      Navigator.of(context).pop();
                      OverlayState? overlayState = Overlay.of(context);
                      OverlayEntry overlayEntry = OverlayEntry(builder: (context)=> Positioned(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,  // получаем width всего экрана
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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

                      File file = await DefaultCacheManager()
                        .getSingleFile(photo.urls!.full!);
                      await ImageGallerySaver.saveFile(file.path);
                      overlayEntry.remove();
                    },
                        child: Text(S.of(context).download)),
                    TextButton(onPressed: () {Navigator.of(context).pop();},
                        child: Text(S.of(context).close))
                  ],
                )
            );
          },)),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback callback) => GestureDetector(
    onTap: callback,
    child: Container(
      alignment: Alignment.center,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.dodgerBlue,
      ),
      child: Text(text,
      style: AppStyles.h4.copyWith(color: AppColors.white),),
    ),);

  void _clearCache() {

    DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
  }

}