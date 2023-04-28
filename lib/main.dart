import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qibla_package_testing/qiblah_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    // Play the audio file on app start
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/song1.mp3"),
      autoStart: true,
      showNotification: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 203, 218, 245),
        body: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
            if (snapshot.data!) {
              return QiblahCompass();
            } else {
              return const Center(
                child: Text("Your device is not supported"),
              );
            }
          },
        ),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 3, 71, 126),
            foregroundColor: Colors.white,
            shadowColor: Color.fromARGB(255, 230, 248, 96),
            elevation: 50,
            toolbarHeight: 70,
            centerTitle: true,
            title: const Center(
                child: Text(
              "تطبيق عبدالإله حجازي \nلتحديد اتجاه الكعبة المشرفة",
              style: TextStyle(
                fontFamily: "Marhey",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))),
        floatingActionButton: MaterialButton(
            height: 40,
            elevation: 20,
            padding: const EdgeInsets.all(5),
            color: const Color.fromARGB(255, 124, 40, 34),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            textColor: Colors.white,
            child: const Text(
              "خروج",
              style: TextStyle(
                  fontFamily: "Marhey",
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            onPressed: () {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            }),
      ),
    );
  }
}
