import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unsplash_gallery/data_provider.dart';


class LikeButton extends StatefulWidget {
  const LikeButton(this.isLiked, this.likeCount, this.id, {Key? key}) : super(key: key);

  final int likeCount;
  final bool isLiked;
  final String id;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;
  String id = '0';

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.likeCount;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DataProvider.isLikePhoto(id, isLiked);
        setState(() {
          isLiked ? likeCount-- : likeCount++;
          isLiked = !isLiked;
        });
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: <Widget>[
            Icon(isLiked? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
            const SizedBox(width: 4.21,),
            Text(likeCount.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],),
        ),
      ),
    );
  }
}
