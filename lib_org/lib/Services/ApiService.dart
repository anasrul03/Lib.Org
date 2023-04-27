import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

String APIKey = 'AIzaSyD-LCZdBsMhtcGdBkKMR0wK3ZXEy9KJ11M';

class ItemsCubit extends Cubit<List<Items>> {
  ItemsCubit() : super([]);

  void setItems(List<Items> items) => emit(items);

  Future<void> fetchBookData(String isbn, ItemsCubit itemsCubit) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&key=$APIKey'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      print(response.body);
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0) {
        final apiService = ApiService.fromJson(data, itemsCubit);
      }
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}

abstract class BookState {}

class BookStateInitial extends BookState {}

class BookStateLoading extends BookState {}

class BookStateError extends BookState {}

class BookStateLoaded extends BookState {
  BookStateLoaded(this.title);

  final String title;
}

class ApiService {
  ApiService({
    required this.itemsCubit,
  });

  late final ItemsCubit itemsCubit;

  ApiService.fromJson(Map<String, dynamic> json, ItemsCubit itemsCubit) {
    final items =
        List.from(json['items']).map((e) => Items.fromJson(e)).toList();
    itemsCubit.setItems(items);
    this.itemsCubit = itemsCubit;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = itemsCubit.state.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Items {
  Items({
    required this.id,
    required this.volumeInfo,
  });
  late final String id;
  late final VolumeInfo volumeInfo;

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    volumeInfo = VolumeInfo.fromJson(json['volumeInfo']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['volumeInfo'] = volumeInfo.toJson();
    return _data;
  }
}

class VolumeInfo {
  VolumeInfo({
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.categories,
    required this.averageRating,
    required this.maturityRating,
    required this.imageLinks,
    required this.language,
  });
  late final String title;
  late final List<String> authors;
  late final String publisher;
  late final String publishedDate;
  late final String description;
  late final List<IndustryIdentifiers> industryIdentifiers;
  late final int pageCount;
  late final List<String> categories;
  late final int averageRating;
  late final String maturityRating;
  late final ImageLinks imageLinks;
  late final String language;

  VolumeInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    authors = List.castFrom<dynamic, String>(json['authors']);
    publisher = json['publisher'];
    publishedDate = json['publishedDate'];
    description = json['description'];
    industryIdentifiers = List.from(json['industryIdentifiers'])
        .map((e) => IndustryIdentifiers.fromJson(e))
        .toList();
    pageCount = json['pageCount'];
    categories = List.castFrom<dynamic, String>(json['categories']);
    averageRating = json['averageRating'];
    maturityRating = json['maturityRating'];
    imageLinks = ImageLinks.fromJson(json['imageLinks']);
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['authors'] = authors;
    _data['publisher'] = publisher;
    _data['publishedDate'] = publishedDate;
    _data['description'] = description;
    _data['industryIdentifiers'] =
        industryIdentifiers.map((e) => e.toJson()).toList();
    _data['pageCount'] = pageCount;
    _data['categories'] = categories;
    _data['averageRating'] = averageRating;
    _data['maturityRating'] = maturityRating;
    _data['imageLinks'] = imageLinks.toJson();
    _data['language'] = language;
    return _data;
  }
}

class IndustryIdentifiers {
  IndustryIdentifiers({
    required this.type,
    required this.identifier,
  });
  late final String type;
  late final String identifier;

  IndustryIdentifiers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['identifier'] = identifier;
    return _data;
  }
}

class ImageLinks {
  ImageLinks({
    required this.smallThumbnail,
    required this.thumbnail,
  });
  late final String smallThumbnail;
  late final String thumbnail;

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['smallThumbnail'] = smallThumbnail;
    _data['thumbnail'] = thumbnail;
    return _data;
  }
}
