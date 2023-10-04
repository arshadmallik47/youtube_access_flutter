// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class ChildChannelPage extends StatefulWidget {
  const ChildChannelPage({
    super.key,
  });

  @override
  State<ChildChannelPage> createState() => _ChildChannelPageState();
}

class _ChildChannelPageState extends State<ChildChannelPage> {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi();

//VideoData? videoData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
      ),
      body: const Center(
        child: Text('Child Channel Page'),
      ),
    );
  }
}
