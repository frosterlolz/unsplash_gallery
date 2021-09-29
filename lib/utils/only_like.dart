import 'package:unsplash_gallery/data_provider.dart';

onlyLike(String id, bool isLiked, int likeCount) {
  {
    if (isLiked) DataProvider.likePhoto(id);
    isLiked ? likeCount-- : likeCount++;
    isLiked = !isLiked;
  }
}