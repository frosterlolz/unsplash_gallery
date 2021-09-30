import 'package:flutter/material.dart';

class CollectionWidget extends StatelessWidget {
  const CollectionWidget({Key? key, required this.photoLink, required this.title}) : super(key: key);

  final String photoLink;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
      children: [
        SizedBox(
          width: 60,
          child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                        key: UniqueKey(),
                        radius: 28,
                        backgroundImage: NetworkImage(photoLink)
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 4)),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 13.0),
                    text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13),
                        text: title),
                  ),
                ),
              ]
          ),
        ),
        const SizedBox(width: 10,)
      ]
  );
}