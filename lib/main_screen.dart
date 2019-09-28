import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:health_app/constants/app_colors.dart';
import 'package:health_app/widget/header_text.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CameraDescription firstCamera;
  CameraController _cameraController;
  bool _cameraVisible = false;

  final PageController controller = new PageController(initialPage: 1);
  bool _profileSelected = false;
  bool _settingsSelected = false;

  Widget _cameraView;

  @override
  void initState() {
    controller.addListener(_onPageChange);
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onPageChange);
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
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[_profile, _main(), _settings],
      ),
    );
  }

  Widget _profile = Column(
    children: <Widget>[
      HeaderText("Profile"),
    ],
  );

  Widget _main() {
    return Stack(
      children: <Widget>[
        Positioned(
            bottom: 0,
            height: 150,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _cameraVisible
                  ? AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: new CameraPreview(_cameraController),
                    )
                  : Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
            ))
      ],
    );
  }

  void _takePicture(BuildContext context) async {
    try {
      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _cameraController.takePicture(path);

      //TODO send to backend
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
  }
}
