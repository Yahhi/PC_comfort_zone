import 'dart:async';
import 'dart:io' as Io;

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/bloc/preferences_provider.dart';
import 'package:health_app/bloc/status_checker.dart';
import 'package:health_app/constants/app_colors.dart';
import 'package:health_app/exercise_screen.dart';
import 'package:health_app/model/posture.dart';
import 'package:health_app/widget/header_text.dart';
import 'package:health_app/widget/slider_track_shape.dart';
import 'package:image/image.dart' as ImageResizer;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  static const UPLOAD_URL = "http://23.101.74.30/mobile/upload/";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //0 - resumed, 1 - inactive, 2 - paused.
    if (state.index == AppLifecycleState.paused.index) {
      _pauseCameraAndConnections();
    } else if (state.index == AppLifecycleState.resumed.index) {
      _resumeCameraAndConnections();
    }
  }

  CameraDescription firstCamera;
  CameraController _cameraController;
  bool _cameraVisible = false;

  StatusChecker _statusChecker = new StatusChecker();

  final PageController controller = new PageController(initialPage: 1);
  bool _profileSelected = false;
  bool _settingsSelected = false;

  Timer _currentImageSender;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onPageChange);
    _initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller.removeListener(_onPageChange);
    _currentImageSender.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onPageChange() {
    if (controller.page > 1.6) {
      setState(() {
        _settingsSelected = true;
        _profileSelected = false;
      });
    } else {
      setState(() {
        _settingsSelected = false;
      });
      if (controller.page < 0.5) {
        setState(() {
          _profileSelected = true;
        });
      } else {
        setState(() {
          _profileSelected = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.WHITE,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: _profileSelected ? AppColors.GREEN : AppColors.BLUE,
            ),
            onPressed: _showSettings,
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.accessibility,
            color: _settingsSelected ? AppColors.GREEN : AppColors.BLUE,
          ),
          onPressed: _showProfile,
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Image.asset("assets/logo_with_letters.png"),
          ),
        ),
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[_profile, _mainWidget(context), _settings],
      ),
    );
  }

  Widget _profile = Column(
    children: <Widget>[
      HeaderText("Profile"),
    ],
  );

  Widget _mainWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              child: StreamBuilder<Postage>(
                stream: _statusChecker.postage,
                initialData: Postage("none", 0),
                builder:
                    (BuildContext context, AsyncSnapshot<Postage> posture) {
                  int postureIndex = posture.data.index;
                  if (postureIndex == 2)
                    return Image.asset("assets/angle_right_bottom.png");
                  if (postureIndex == 1)
                    return Image.asset("assets/angle_right_top.png");
                  if (postureIndex == -1)
                    return Image.asset("assets/angle_left_top.png");
                  if (postureIndex == -2)
                    return Image.asset("assets/angle_right_top.png");
                  return Image.asset("assets/no_angle.png");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          _openExercise(context);
                        },
                        child: Image.asset(
                          "assets/avatar.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Марина Ивановна",
                          textScaleFactor: 1.2,
                          style: TextStyle(color: AppColors.BLUE),
                        ),
                        StreamBuilder<Postage>(
                          stream: _statusChecker.postage,
                          initialData: Postage("none", 0),
                          builder: (BuildContext context,
                              AsyncSnapshot<Postage> posture) {
                            int postureIndex = posture.data.index;
                            print("found posture index is $postureIndex");
                            if (postureIndex > 0.5 || postureIndex < -0.5)
                              return Text(
                                "Нежелательная поза",
                                style: TextStyle(color: AppColors.PINK),
                              );
                            return Text(
                              "Отличная поза",
                              style: TextStyle(color: AppColors.GREEN),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: StreamBuilder<bool>(
            initialData: false,
            stream: _statusChecker.light,
            builder: (BuildContext context, AsyncSnapshot<bool> value) {
              return Image.asset(
                value.data ? "assets/good_light.png" : "assets/bad_light.png",
                height: 60,
              );
            },
          ),
        ),
        Positioned(
          left: 8,
          bottom: 20,
          width: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<int>(
                  initialData: 20,
                  stream: _statusChecker.temperature,
                  builder: (BuildContext context, AsyncSnapshot<int> data) {
                    return Text("t: ${data.data}°C");
                  }),
              SizedBox(
                height: 20,
              ),
              Text("CO2"),
              StreamBuilder<int>(
                initialData: 50,
                stream: _statusChecker.airQuality,
                builder: (BuildContext context, AsyncSnapshot<int> data) {
                  return SliderTheme(
                    data: SliderThemeData(
                      disabledInactiveTrackColor: AppColors.GREEN,
                      disabledActiveTrackColor: AppColors.BLUE,
                      thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
                      trackShape: GreenSliderTrackShape(),
                    ),
                    child: Slider(
                      onChanged: null,
                      min: 0,
                      max: 100,
                      value: data.data.roundToDouble(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          height: 150,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _cameraVisible
                ? Transform.scale(
                    scale: 1 / _cameraController.value.aspectRatio,
                    child: new AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: new CameraPreview(_cameraController)),
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
          ),
        )
      ],
    );
  }

  void _takePicture() async {
    try {
      final String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        filename,
      );

      // Attempt to take a picture and log where it's been saved.
      await _cameraController.takePicture(path);

      _sendPicture(path, filename);
    } catch (e) {
      print(e);
    }
  }

  Widget _settings = Column(
    children: <Widget>[
      HeaderText("Settings"),
    ],
  );

  void _showSettings() {
    controller.jumpToPage(2);
  }

  void _showProfile() {
    controller.jumpToPage(0);
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    firstCamera = cameras[1];

    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();

    setState(() {
      _cameraVisible = true;
    });
    _takePictureAndSleep();
    _takePicture();
  }

  void _takePictureAndSleep() {
    _currentImageSender =
        Timer.periodic(Duration(seconds: 30), (Timer t) => _takePicture());
  }

  void _sendPicture(String filePath, String filename) async {
    print("sending picture");
    String uid = await PreferencesProvider().getUid();
    print("uid is $uid");

    ImageResizer.Image image =
        ImageResizer.decodeImage(new Io.File(filePath).readAsBytesSync());
    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    ImageResizer.Image thumbnail = ImageResizer.copyResize(image, width: 240);

    new Io.File(filePath)..writeAsBytesSync(ImageResizer.encodeJpg(thumbnail));

    Dio dio = new Dio();
    MultipartFile file =
        await MultipartFile.fromFile(filePath, filename: filename);
    print(("file is ${file.length}"));
    FormData formdata = FormData.fromMap({"id": uid, "file": file});
    dio
        .post(UPLOAD_URL,
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ))
        .then((response) {
      print(response);
    }).catchError((error) => print(error));
  }

  void _openExercise(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ExerciseScreen()));
  }

  void _pauseCameraAndConnections() {
    setState(() {
      _cameraVisible = false;
    });
    _statusChecker.cancelConnections();
  }

  void _resumeCameraAndConnections() {
    setState(() {
      _cameraVisible = true;
    });
    _statusChecker.resumeConnections();
  }
}
