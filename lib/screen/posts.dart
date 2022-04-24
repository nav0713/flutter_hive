import 'package:flutter/material.dart';
import 'package:hive_basics/global.dart';
import 'package:hive_basics/main.dart';
import 'package:hive_basics/model/post.dart';
import 'package:hive_basics/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<Post> posts = [];
  bool _loading = false;
  @override
  void dispose() {
    Hive.box(POST_BOX).close();
    super.dispose();
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  Future<void> getPosts() async {
    setState(() {
      _loading = true;
    });
    List<Post> allPost = await APIService.instance.getPost();
    posts = allPost;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map<dynamic, dynamic> posts = postBox.toMap();
    // posts.forEach(((key, post) {
    //   print(post.title);
    // }));
    print(postBox.values); //print all the values in your box
    print(postBox.keys); // print all the keys in your box
    print(posts.length);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _loading = true;
          });
          await APIService.instance.addPost(Post(
              id: 12,
              userId: 10,
              title: "Sumba",
              body: "Sumba Sumba or Zugba Zugba"));

          setState(() {
            _loading = false;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Center(
            child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .80,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return ListTile(
                    trailing: Text(post.id.toString()),
                    title: Text(post.title.toString()),
                    subtitle: Text(post.body.toString()),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await postBox.clear();
                  // setState(() {
                  //   _loading = true;
                  // });
                  // await getPosts();
                  // setState(() {
                  //   _loading = false;
                  // });
                },
                child: const Text("Clear data from hive"))
          ],
        )),
      ),
    );
  }
}
