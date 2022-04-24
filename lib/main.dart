import 'dart:io';
import 'global.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_basics/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/post.dart';
import 'screen/posts.dart';

late Box postBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDirectory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDirectory.path); //dapat naka await ni
  Hive.registerAdapter(PostAdapter());
  postBox = await Hive.openBox<Post>(POST_BOX); //dapaat naka await ni
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hive"),
            ),
            body: const Posts()));
  }
}
