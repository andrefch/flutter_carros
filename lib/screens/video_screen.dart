import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final Car car;

  VideoScreen({this.car});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;

  Car get car => widget.car;

  String get url => car.urlVideo;

  bool _showProgress = true;

  @override
  void initState() {
    super.initState();
    print('URL video: $url');
    _controller = VideoPlayerController.network(url);
    _controller.initialize().then((value) {
      setState(() {
        _showProgress = false;
        _controller.play();
      });
    }, onError: (error) {
      setState(() {
        _showProgress = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    currentWidget = _createVideoScreen();
    if (_showProgress) {
      currentWidget = _createLoadingScreen();
    } else if (_controller.value.initialized) {
      currentWidget = _createVideoScreen();
    } else {
      currentWidget = _createErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: currentWidget,
      floatingActionButton: !_showProgress && _controller.value.initialized
          ? FloatingActionButton(
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _togglePlayPause,
            )
          : null,
    );
  }

  Widget _createVideoScreen() {
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  Widget _createErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.videocam_off,
            color: Colors.white70,
            size: 64,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Não foi possível reproduzir o vídeo!',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _createLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColorLight),
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }
}
