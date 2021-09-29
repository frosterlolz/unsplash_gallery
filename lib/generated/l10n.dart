// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Authorization`
  String get authorization {
    return Intl.message(
      'Authorization',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get logIn {
    return Intl.message(
      'Log in',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Unsplash Gallery`
  String get mainTitle {
    return Intl.message(
      'Unsplash Gallery',
      name: 'mainTitle',
      desc: '',
      args: [],
    );
  }

  /// `Feed`
  String get navBarItemOne {
    return Intl.message(
      'Feed',
      name: 'navBarItemOne',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get navBarItemTwo {
    return Intl.message(
      'Search',
      name: 'navBarItemTwo',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get navBarItemThree {
    return Intl.message(
      'User',
      name: 'navBarItemThree',
      desc: '',
      args: [],
    );
  }

  /// `No description`
  String get defaultDescription {
    return Intl.message(
      'No description',
      name: 'defaultDescription',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Downloading photos`
  String get downloadTitle {
    return Intl.message(
      'Downloading photos',
      name: 'downloadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are u sure, u want to download a photo?`
  String get downloadingSure {
    return Intl.message(
      'Are u sure, u want to download a photo?',
      name: 'downloadingSure',
      desc: '',
      args: [],
    );
  }

  /// `Clear cache`
  String get clearCache {
    return Intl.message(
      'Clear cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collections {
    return Intl.message(
      'Collections',
      name: 'collections',
      desc: '',
      args: [],
    );
  }

  /// `Default collection name`
  String get defaultColName {
    return Intl.message(
      'Default collection name',
      name: 'defaultColName',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection established`
  String get haveInternet {
    return Intl.message(
      'Internet connection established',
      name: 'haveInternet',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternet {
    return Intl.message(
      'No internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Your photo album is empty`
  String get noPhotos {
    return Intl.message(
      'Your photo album is empty',
      name: 'noPhotos',
      desc: '',
      args: [],
    );
  }

  /// `You have no liked photos`
  String get noLikedPhotos {
    return Intl.message(
      'You have no liked photos',
      name: 'noLikedPhotos',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
