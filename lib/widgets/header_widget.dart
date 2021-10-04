import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:url_launcher/url_launcher.dart';

Container buildHeader(BuildContext context, Sponsor? user) {
  return Container(
    margin: const EdgeInsets.only(top: 50.0),
    height: 240.0,
    child: Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              top: 40.0, left: 21.0, right: 21.0, bottom: 10.0),
          child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            // color: Colors.white,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0),
                Text(user?.name ?? 'Name null'),
                const SizedBox(height: 5.0),
                buildSocials(user),
                SizedBox(
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalPhotos ?? '0'}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(S.of(context).photos.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalLikes ?? '0'}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(S.of(context).likes.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalCollections ?? '0'}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              S.of(context).collections.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              elevation: 5.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: CachedNetworkImageProvider(
                    user?.profileImage?.medium ??
                        'https://i.pinimg.com/originals/d8/42/e2/d842e2a8aecaffff34ae744a96896ac9.jpg',
                    cacheKey: UniqueKey().toString()),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildSocials(Sponsor? user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      const SizedBox(width: 20.0),
      IconButton(
        color: Colors.indigo,
        icon: const Icon(
          FontAwesomeIcons.instagram,
        ),
        onPressed: () {
          if (user?.instagramUsername != null) {
            _launchURL("https://www.instagram.com/${user!.instagramUsername}");
          }
        },
      ),
      const SizedBox(width: 5.0),
      IconButton(
        color: Colors.indigo,
        icon: const Icon(FontAwesomeIcons.twitter),
        onPressed: () {
          if (user?.twitterUsername != null) {
            _launchURL("https://twitter.com/${user!.twitterUsername}");
          }
        },
      ),
      const SizedBox(width: 10.0),
    ],
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
