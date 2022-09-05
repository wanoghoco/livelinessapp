import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const ElatechLiveliness());
}

class ElatechLiveliness extends StatelessWidget {
  static MethodChannel channel =
      const MethodChannel("elatech_liveliness_plugin");
  const ElatechLiveliness({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatelessWidget {
  final listenable = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: listenable,
            builder: (context, value, child) {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      listenable.value != ""
                          ? Image.file(File(listenable.value))
                          : const SizedBox(),
                      Text(listenable.value),
                      ElevatedButton(
                          onPressed: () async {
                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              listenable.value = "";
                              listenable.value = await ElatechLiveliness.channel
                                  .invokeMethod("detectliveliness", {
                                "msgselfieCapture":
                                    "Place your face inside the oval shaped panel",
                                "msgBlinkEye": "Blink your eyes to capture"
                              });
                            }
                          },
                          child: const Text("Click Me"))
                    ]),
              );
            }));
  }
}
