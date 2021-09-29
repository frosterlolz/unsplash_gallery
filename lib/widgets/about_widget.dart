import 'package:flutter/material.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';

Widget buildAbout(Photo data, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Text(data.altDescription ?? S.of(context).defaultDescription,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      // style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
    ),
  );
}