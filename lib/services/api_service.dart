import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hive_basics/global.dart';
import 'package:hive_basics/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../model/post.dart';

class APIService {
  static final APIService _instance = APIService();
  static APIService get instance => _instance;
  int timeout = 10;
  List<Post> posts = [];
  Future<List<Post>> getPost() async {
    // get data from hive db
    Map<dynamic, dynamic> posts_from_hive = postBox.toMap();

    // if hive database is empty application will fecth data from API and
    // add data to local posts variable. At the same time, it will also add the data
    // to hive local database
    if (posts_from_hive.isEmpty) {
      print("data from API");
      try {
        final response = await get(Uri.parse('http://$IP:3000/posts'));
        if (response.statusCode == 200) {
          final resjson = jsonDecode(response.body);
          resjson.forEach((post) {
            Post newPost = Post.fromJson(post);
            posts.add(newPost);
            // add post to hive db
            postBox.add(newPost);
          });
        }
      } on SocketException catch (e) {
        throw "No Internet Connection" + e.toString();
      } on TimeoutException catch (e) {
        throw "Timeout Error" + e.toString();
      } catch (e) {
        print(e.toString());
      }
    } else {
      print("data from Hive");
      posts_from_hive.forEach((key, post) {
        posts.add(post);
      });
    }
    return posts;
  }

  Future<void> addPost(Post newPost) async {
    print('${newPost.title} ${newPost.id} ${newPost.body} ${newPost.userId}');
    try {
      final response = await post(Uri.parse("http://192.168.1.7:3000/posts"),
          body: json.encode(newPost), headers: {'acc': 'application/json'});
      print("statuscode" + response.statusCode.toString());
      posts.add(newPost);
      postBox.add(newPost);
    } catch (e) {
      print(e.toString());
    }
  }
}
