import 'package:example/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:example/providers/child_provider.dart';
import 'package:youtube_scrape_api/models/video_data.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class ChildVideoPage extends StatefulWidget {
  const ChildVideoPage({Key? key}) : super(key: key);

  @override
  State<ChildVideoPage> createState() => _ChildVideoPageState();
}

class _ChildVideoPageState extends State<ChildVideoPage> {
  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: childProvider.currentChild?.videos.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<VideoData?>(
              future: YoutubeDataApi()
                  .fetchVideoData(childProvider.currentChild!.videos[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('loading...'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Text('no Data found');
                }
                if (snapshot.hasData) {
                  return VideoWidget(video: snapshot.data!.videosList.first);
                }
                return const Text('No videos found!');
              });
        },
      ),
    );
  }
}
