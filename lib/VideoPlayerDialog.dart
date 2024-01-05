import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VerticalVolumeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  VerticalVolumeSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: '${(value * 10).toInt()}',
      ),
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;

  VideoPlayerDialog({required this.videoUrl});

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 0.0;
  double _volumeSliderValue = 0.5;
  bool _isVolumeSliderVisible = false;
  bool _areControlsVisible = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.setLooping(true);
        setState(() {});
        _controller.addListener(() {
          setState(() {
            _currentSliderValue = _controller.value.position.inSeconds.toDouble();
          });
        });
        _startControlsTimer();
      });
  }

  void _startControlsTimer() {
    _controlsTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_isVolumeSliderVisible) {
        setState(() {
          _areControlsVisible = false;
        });
      }
    });
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _startControlsTimer();
    setState(() {
      _areControlsVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Listener(
        onPointerMove: (event) {
          _resetControlsTimer();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              if (_controller.value.isInitialized)
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () {
                          _resetControlsTimer();
                        },
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Positioned(
                      top: calculateVolumeSliderTopPosition(context),
                      right: 0,
                      child: Visibility(
                        visible: _isVolumeSliderVisible,
                        child: VerticalVolumeSlider(
                          value: _volumeSliderValue,
                          onChanged: (newValue) {
                            setState(() {
                              _volumeSliderValue = newValue;
                              _controller.setVolume(_volumeSliderValue);
                            });
                          },
                        ),
                      ),
                    ),
                    if (_areControlsVisible)
                      Positioned(
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_controller.value.isPlaying) {
                                          _controller.pause();
                                        } else {
                                          _controller.play();
                                        }
                                      });
                                      _resetControlsTimer();
                                    },
                                    iconSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                Slider(
                                  value: _currentSliderValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _currentSliderValue = newValue;
                                      final newPosition =
                                          Duration(seconds: newValue.toInt());
                                      _controller.seekTo(newPosition);
                                    });
                                    _resetControlsTimer();
                                  },
                                  min: 0.0,
                                  max: _controller.value.duration.inSeconds.toDouble(),
                                  divisions: _controller.value.duration.inSeconds,
                                  label: '${_currentSliderValue.toInt()}s',
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isVolumeSliderVisible = !_isVolumeSliderVisible;
                                      if (!_isVolumeSliderVisible) {
                                        // If hiding the volume slider, reset the volume
                                        _volumeSliderValue = _controller.value.volume;
                                      }
                                    });
                                    _resetControlsTimer();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Icon(
                                          Icons.volume_up,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  double calculateVolumeSliderTopPosition(BuildContext context) {
    double videoHeight = MediaQuery.of(context).size.width * 0.5 / _controller.value.aspectRatio;
    double volumeSliderHeight = 160; // Adjust as needed
    double middle = videoHeight / 2 - volumeSliderHeight / 2;
    return middle;
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    super.dispose();
    _controller.dispose();
  }
}
