import 'package:flutter/material.dart';

import '../data/models/video_model.dart';
import 'button_widget.dart';

List<Widget> buildListVideo(List<Video> videos, Function copyClipBoard) {
  return [
    for (var video in videos)
      ButtonWidget(
        title: 'Video #${video.numvideo}',
        text: video.status,
        icon: Icons.play_arrow,
        colorIcon: video.status == 'TERMINADO' ? Colors.green : Colors.red,
        onTap: () {
          copyClipBoard(video.url, video.codvideo);
        },
        isLast: videos.last == video,
      ),
  ];
}
