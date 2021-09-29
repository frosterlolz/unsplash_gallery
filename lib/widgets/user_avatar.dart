import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

Widget userAvatar(String avatarLink) => ClipRRect(
  borderRadius: BorderRadius.circular(50),
  child: CachedNetworkImage(imageUrl: avatarLink, width: 40, height: 40,fit: BoxFit.fill,),
);