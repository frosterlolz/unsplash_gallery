import 'package:flutter/material.dart';
import 'package:unsplash_gallery/res/colors.dart';

class CollectionWidget extends StatelessWidget {
  const CollectionWidget(
      {Key? key, required this.photoLink, required this.title})
      : super(key: key);

  final String photoLink;
  final String title;

  @override
  Widget build(BuildContext context) => Row(children: [
        SizedBox(
          width: 60,
          child: Column(children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.grayChateau,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  child: photoLink.isEmpty ? Icon(Icons.add, size: 35, color: Theme.of(context).primaryColor,) : null,
                  backgroundColor: Theme.of(context).canvasColor, // gray/black
                    key: UniqueKey(),
                    radius: 28,
                    backgroundImage: photoLink.isEmpty ? null : NetworkImage(photoLink),),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: const StrutStyle(fontSize: 13.0),
                text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 13),
                    text: title),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 10,
        )
      ]);
}
