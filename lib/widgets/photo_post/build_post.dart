import 'package:flutter/material.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/widgets/about_widget.dart';
import 'package:unsplash_gallery/widgets/photo.dart';
import 'package:unsplash_gallery/widgets/user_mini_block.dart';

Widget buildPhotoPost(context, Photo photo, bool isSearch) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoPage(photo: photo, tag: isSearch ? 'search_${photo.id!}' : 'feed_${photo.id!}',)));
          },
          child: BigPhoto(
            photoLink: photo.urls!.regular!,
            tag: isSearch ? 'search_${photo.id!}' : 'feed_${photo.id!}',
            radius: 17,
          ),
        ),
        DetailedBlock(
          photo,
          likeButton: true,
        ),
        buildAbout(
          photo,
          context,
        ),
      ],
    ),
  );
}
