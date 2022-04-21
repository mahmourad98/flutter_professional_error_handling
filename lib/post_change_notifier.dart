import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'post_service.dart';

enum NotifierState { initial, loading, loaded }

class PostChangeNotifier extends ChangeNotifier {
  late final _postService = PostService();
  NotifierState _state = NotifierState.initial;

  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  // Post? _post = null;
  // Post? get post => _post;
  // void _setPost(Post? post) {
  //   _post = post;
  //   notifyListeners();
  // }

  // Failure? _failure = null;
  // Failure? get failure => _failure;
  // void _setFailure(Failure? failure) {
  //   _failure = failure;
  //   notifyListeners();
  // }

  late Either<Failure, Post> _result;
  Either<Failure, Post> get result => _result;
  void _setResult(Either<Failure, Post> result) {
    _result = result;
    notifyListeners();
  }

  Future<void> getOnePost() async {
    _setState(NotifierState.loading);
    await _postService.getOnePost().then((value) => _setResult(value));
    _setState(NotifierState.loaded);
  }
}

//   Future<void> getOnePost() async {
//     _setState(NotifierState.loading);
//     await Task<Post>(() => _postService.getOnePost())
//     .attempt()
//     .map(
//       (a) => a.leftMap(
//         (leftObj) {
//           try {
//             return leftObj as Failure;
//           }
//           catch (e) {
//             throw leftObj;
//           }
//         }
//
//       ),
//     )
//     .run()
//     .then((value) => _setResult(value));
//     _setState(NotifierState.loaded);
//   }
//}

// extension TaskX<T extends Either<Object, Post>, Post> on Task<T> {
//   Task<Either<Failure, Post>> mapLeftToFailure() {
//     return map(
//       (either) => either.leftMap(
//         (obj) {
//           try {
//             return obj as Failure;
//           }
//           catch (e) {
//             throw obj;
//           }
//         }
//       )
//     );
//   }
// }
