import 'package:flutter/material.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/screens/photo_screen.dart';
import 'package:unsplash_gallery/widgets/photo.dart';

class CollectionListScreen extends StatefulWidget {
  const CollectionListScreen(this.collection, {Key? key}) : super(key: key);

  final Collection collection;

  @override
  State<StatefulWidget> createState() => CollectionListScreenState();
}

class CollectionListScreenState extends State<CollectionListScreen> with TickerProviderStateMixin {
  Collection? _collection;
  final ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var photoList = <Photo>[];


  @override
  void initState() {

    _getCollectionPhotos(_collection!.id.toString(), pageCount);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getCollectionPhotos(_collection!.id.toString(), pageCount);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_collection!.title ?? S.of(context).defaultColName,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 17
            ),
          ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: _buildListView(context, photoList),
    );
  }

  Widget _buildListView(BuildContext context, List<Photo> photoList) {
    //TODO: переделать на SingleChildScrollView так, чтобы он занимал весь экран
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: photoList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      controller: _scrollController,
      itemBuilder: (context, i) {
        if (i == photoList.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return _buildPhoto(photoList[i]);
      },
    );
  }

  Widget _buildPhoto(Photo photo) {
    return GestureDetector(
      onTap: (){_onBigPhotoTap(context, photo);},
      child: BigPhoto(photoLink: photo.urls!.regular!, tag: 'colItem_${photo.id}', radius: 0,),
    );
  }

  void _getCollectionPhotos(String id, int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotosByCollection(id, page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _onBigPhotoTap(context, photo){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoPage(photo: photo))
    );
  }
}
