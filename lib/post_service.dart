import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PostService {
  static late final Dio _myDio = Dio(
    BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com",
      receiveDataWhenStatusError: true,
    ),
  );

  Future<Either<Failure, Post>> getOnePost() async {
    try {
      final responseBody = await _myDio.get("/posts/1");
      //print(responseBody.toString());
      return Right(Post.fromJson(responseBody.toString()));
      //throw const SocketException("http error");
    }
    on Exception catch (error) {
      if (error is DioError){
        return Left(Failure('Failure, please try again 😑'));
      }
      else if (error is SocketException){
        return Left(Failure('No Internet connection 😑'));
      }
      else if (error is HttpException){
        return Left(Failure("Couldn't find the post 😱"));
      }
      else if (error is FormatException){
        return Left(Failure("Bad response format 👎"));
      }
      else{
        return Left(Failure("$error"));
      }
    }
  }

  // Future<Post> getOnePost() async {
  //   try {
  //     final responseBody = await _myDio.get("/posts/1");
  //     //print(responseBody.toString());
  //     return Post.fromJson(responseBody.toString());
  //     //throw const SocketException("http error");
  //   }
  //   on Exception catch (error) {
  //     if (error is DioError){
  //       throw Failure('Failure, please try again 😑');
  //     }
  //     else if (error is SocketException){
  //       throw Failure('No Internet connection 😑');
  //     }
  //     else if (error is HttpException){
  //       throw Failure("Couldn't find the post 😱");
  //     }
  //     else if (error is FormatException){
  //       throw Failure("Bad response format 👎");
  //     }
  //     else{
  //       throw Failure("$error");
  //     }
  //   }
  // }
}

//no need to extend Exception class because in dart exceptions is dynamic
class Failure{
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) throw ArgumentError('map is empty');
    return Post(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
    );
  }

  static Post fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post id: $id, userId: $userId, title: $title, body: $body';
  }
}
