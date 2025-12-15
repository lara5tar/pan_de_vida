import 'package:flutter/material.dart';

import '../data/models/video_model.dart';
import 'button_widget.dart';

List<Widget> buildListVideo(List<Video> videos,
    {Function? copyClipBoard, Function? onTap}) {
  return [
    for (var video in videos)
      ButtonWidget(
        title: 'Video #${video.numvideo}',
        text: video.status,
        icon: video.status == 'TERMINADO' ? Icons.check_box : Icons.play_arrow,
        colorIcon: video.status == 'TERMINADO' ? Colors.green : Colors.red,
        onTap: () {
          // if (video.status != 'TERMINADO') 
          {
            if (copyClipBoard != null) copyClipBoard(video.url, video.codvideo);
            if (onTap != null) onTap(video.url, video.codvideo);
          }
        },
        isLast: videos.last == video,
      ),
  ];
}
