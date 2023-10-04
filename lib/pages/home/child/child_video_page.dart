// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class ChildVideoPage extends StatefulWidget {
  ///String? videoId;
  const ChildVideoPage({
    super.key,
  });

  @override
  State<ChildVideoPage> createState() => _ChildVideoPageState();
}

class _ChildVideoPageState extends State<ChildVideoPage> {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: const Center(
        child: Text('Child Video Page'),
      ),
    );
  }
}
