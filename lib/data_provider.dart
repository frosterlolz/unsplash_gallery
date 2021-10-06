import 'dart:convert'; // здесь содержатся кодеры/декодеры для JSON
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:unsplash_gallery/models/auth/model.dart';
import 'package:unsplash_gallery/models/model.dart'; // для выполнения http запросов

/*
 async {
  const url = "$baseUrl/api/v1/login";

  var response = await http.post(url, body: {
    'user': '$username',
    'password': '$pwd',
  });

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return Login.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}
*/

class DataProvider {
  static Dio dio = Dio();
  // static const String _appId = "261112"; //not used, just for info
  // TOKEN HERE
  static String authToken = 'H-DjvpLCdk_HjpyYJKP2Z3Af8NMYOmGCc3QZCdciCSI';
  static const String _accessKey =
      'ZO8jyGxChpxOQJr2JC41DHOkNnQLDW3_2OpN-Wsir08'; //app access key from console
  static const String _secretKey =
      'LxTDPoMfhxvH6mMqKPLTXX2yMn1dW1aUx6Kpl6EoamQ'; //app secrey key from console
  static const String authUrl =
      'https://unsplash.com/oauth/authorize?client_id=$_accessKey&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=public+write_likes+write_collections+read_photos+write_photos'; //authorize url from https://unsplash.com/oauth/applications/{your_app_id}

  // авторизация
  static Future<Auth> doLogin({String? oneTimeCode}) async {
    // на входе получаю одноразовый код
    // Dio dio = Dio();
    var response = await dio.post(
        'https://unsplash.com/oauth/token', // делаю POST запрос
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data:
            '{"client_id":"$_accessKey","client_secret":"$_secretKey","redirect_uri":"urn:ietf:wg:oauth:2.0:oob","code":"$oneTimeCode","grant_type":"authorization_code"}');
    // далее необходимо ответ преобразовать в экземпляр созданного класса (в д. случае Auth)
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // print(response.data);
      return Auth.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  // получить рандомное фото
  static Future<Photo> getRandomPhoto() async {
    dio.options.baseUrl = 'https://api.unsplash.com';
    var response = await dio.get('/photos/random',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}));

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Photo.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  // лайкнуть фото
  static Future<bool> likePhoto(String photoId) async {
    var response =
        await dio.post('https://api.unsplash.com/photos/$photoId/like',
            options: Options(headers: {
              'Authorization': 'Bearer $authToken',
            }));
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  // убрать лайк с фото
  static Future<bool> unlikePhoto(String photoId) async {
    var response = await http.delete(
        Uri.parse('https://api.unsplash.com/photos/$photoId/like'),
        headers: {
          'Authorization': 'Bearer $authToken',
        });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<bool> isLikePhoto(String photoId, bool isLike) async {
    var response = isLike
        ? await dio.post(
            'https://api.unsplash.com/photos/$photoId/like',
            options: Options(headers: {
              'Authorization': 'Bearer $authToken',
            }),
          )
        : await dio.delete(
            'https://api.unsplash.com/photos/$photoId/like',
            options: Options(headers: {
              'Authorization': 'Bearer $authToken',
            }),
          );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  // получить фото
  static Future<PhotoList> getPhotos(int page, int perPage) async {
    var response = await dio.get(
      'https://api.unsplash.com/photos?page=$page&per_page=$perPage',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return PhotoList.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  // IT WORKS!!!
  static Future<PhotoList> getSearchPhoto(
      String query, int page, int perPage) async {
    var response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/search/photos?query=$query&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["results"];
      return PhotoList.fromJson(data);
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  // WORKED!
  static Future<PhotoList> getPhotoByUser(
      String username, int page, int perPage) async {
    var response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/users/$username/photos?&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PhotoList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<CollectionList> getCollectionsByUser(
      String username, int page, int perPage) async {
    var response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/users/$username/collections?&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CollectionList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<PhotoList> getPhotosByCollection(
      String id, int page, int perPage) async {
    var response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/collections/$id/photos?&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PhotoList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<Sponsor> getMyProfile() async {
    var response = await dio.get('https://api.unsplash.com/me',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}));

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Sponsor.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  static Future<PhotoList> getLikedPhotoByUser(
      String username, int page, int perPage) async {
    var response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/users/$username/likes?&page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PhotoList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<Collection> addCollection(
      {required String title, String description = '', bool private = false}) async {
    var response = await dio.post('https://api.unsplash.com/collections/',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data: '{"title": "$title", "description": "$description", "private": "$private"}');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Collection.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  static Future addToCollection(colId, photoId, bool add) async {
    // на входе получаю одноразовый код
    var response = add
        ? await dio.post('https://api.unsplash.com/collections/$colId/add',
            options: Options(headers: {'Authorization': 'Bearer $authToken'}),
            data: '{"collection_id": "$colId", "photo_id": "$photoId"}')
        : await dio.delete('https://api.unsplash.com/collections/$colId/remove',
            options: Options(headers: {'Authorization': 'Bearer $authToken'}),
            data: '{"collection_id": "$colId", "photo_id": "$photoId"}');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.statusCode;
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  static Future deleteCollection(String id) async {
    var response = await dio.delete('https://api.unsplash.com/collections/$id',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}));
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.statusCode;
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }

  static Future updateProfile(String username, String fName, String lName,
      String email, String bio, String instagram) async {
    var response = await dio.put('https://api.unsplash.com/me',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data:
            '{"username": "$username","first_name": "$fName","last_name": "$lName","email": "$email","instagram_username": "$instagram","bio": "$bio"}');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.statusCode;
    } else {
      throw Exception('Error: ${response.statusMessage}');
    }
  }
}
