import 'package:flutter/material.dart';
import 'package:flutter_bootm/boot_animation.dart';
import 'package:flutter_bootm/boot_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(hint_boot_splash),
              FilledButton(
                onPressed: saveImageAsSplash,
                child: Text("上传图片制作 splash.img"),
              ),
              Text("注意：图片可能需要为竖屏模式，并且必须是 PNG 格式。",
                  style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              SelectableText(hint_boot_animation),
              FilledButton(
                onPressed: createAndDownloadZip,
                child: Text("上传图片生成开机动画包"),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
