import 'package:flutter/material.dart';
import 'package:flutter_error_handling_reso/post_change_notifier.dart';
import 'package:flutter_error_handling_reso/post_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostChangeNotifier(),
      child: const MaterialApp(
        title: 'Material App',
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late var postFuture = PostService().getOnePost();
  Map<int, String> maps = {1: "e"};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              // child: FutureBuilder<Post?>(
              //   future: postFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //
              //     } else if (snapshot.hasError) {
              //       final error = snapshot.error;
              //       return StyledText(error.toString());
              //     } else if (snapshot.hasData) {
              //       final post = snapshot.data;
              //       return StyledText(post.toString());
              //     } else {
              //       return const StyledText('Press the button 👇');
              //     }
              //   },
              // ),
              // child: Consumer<PostChangeNotifier>(
              //   builder: (buildContext, changeNotifier, child) {
              //     var status = changeNotifier.state;
              //     if (status == NotifierState.loading) {
              //       return const CircularProgressIndicator();
              //     }
              //     else if (status == NotifierState.loaded) {
              //       if (changeNotifier.post != null && changeNotifier.failure == null) {
              //         return StyledText(changeNotifier.post.toString());
              //       }
              //       else {
              //         return StyledText(changeNotifier.failure.toString());
              //       }
              //     }
              //     else {
              //       return const StyledText('Press the button 👇');
              //     }
              //   },
              // ),
              child: Consumer<PostChangeNotifier>(
                builder: (buildContext, changeNotifier, child) {
                  var status = changeNotifier.state;
                  if (status == NotifierState.loading) {
                    return const Center(
                      child: SizedBox(
                        height: 64,
                        width: 64,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  else if (status == NotifierState.loaded) {
                    return changeNotifier.result.fold(
                      (failure) => StyledText(failure.toString()),
                      (post) => StyledText(post.toString()),
                    );
                  }
                  else {
                    return const StyledText('Press the button 👇');
                  }
                },
              ),
            ),
            ElevatedButton(
              child: const Text('Get Post'),
              onPressed: () async {
                // setState(() {
                //   postFuture = PostService().getOnePost();
                // });
                await Provider.of<PostChangeNotifier>(
                  context,
                  listen: false,
                ).getOnePost();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 40),
    );
  }
}
