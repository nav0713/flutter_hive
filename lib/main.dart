import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

const String SETTINGS_BOX = "settings";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  await Hive.openBox(SETTINGS_BOX);
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
          body: const MainPage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("HomePage"),
          ElevatedButton(
              onPressed: () {
                Hive.box(SETTINGS_BOX).put('welcomeTap', false);
              },
              child: const Text("Make false"))
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<dynamic>(
            valueListenable: Hive.box(SETTINGS_BOX).listenable(),
            builder: (BuildContext context, box, child) =>
                box.get('welcomeTap', defaultValue: false)
                    ? const MyHomePage(title: "title")
                    : const WelcomeScreen()));
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome Screen"),
          ElevatedButton(
              onPressed: () {
                Hive.box(SETTINGS_BOX).put('welcomeTap', true);
              },
              child: const Text("Make true"))
        ],
      ),
    );
  }
}



// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Welcome Page"),
//             ElevatedButton(
//                 onPressed: () async {
//                   var box = Hive.box(SETTINGS_BOX);
//                   box.put("welcomeTap", true);
//                   // box.clear();
//                 },
//                 child: const Text("Get Started"))
//           ],
//         ),
//       ),


// Hive.box(SETTINGS_BOX).get("welcomeTap", defaultValue: false) ==
//                 true
//             ? const MyHomePage(title: "title")
//             : Container(
//                 child: Center(
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Hive.box(SETTINGS_BOX).put("welcomeTap", true);
//                           // Hive.box(SETTINGS_BOX).clear();
//                           // Hive.box(SETTINGS_BOX).delete('welcomeTap');
//                         },
//                         child: const Text("Pressed"))),
//               ));
//   }