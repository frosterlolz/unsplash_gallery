import 'package:flutter/material.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/screens/profile.dart';
import 'package:unsplash_gallery/widgets/buttons/like_button.dart';
import 'package:unsplash_gallery/widgets/user_avatar.dart';


class DetailedBlock extends StatefulWidget {
  final Photo _photo;
  final bool likeButton;

  const DetailedBlock(this._photo, {this.likeButton = false, Key? key}) : super(key:key);

  @override
  DetailedBlockState createState() => DetailedBlockState();
}

class DetailedBlockState extends State<DetailedBlock> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Photo? photo = widget._photo;
    bool _likeButton = widget.likeButton;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          GestureDetector(onTap: (){
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>ProfilePage(user: photo.user!)));
            });},
              child: detailedBlock(photo)
          ),
          _likeButton ? LikeButton(photo.likedByUser!, photo.likes!, photo.id!) : Container(),
        ]
    );
  }

  Widget detailedBlock(Photo photo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      child: Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userAvatar(photo.user!.profileImage!.small!),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    photo.user!.name!,
                    // style: AppStyles.h2Black,
                  ),
                  Text('@${photo.user!.username!}',
                    // style: AppStyles.h5Black.copyWith(color: AppColors.manatee),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
