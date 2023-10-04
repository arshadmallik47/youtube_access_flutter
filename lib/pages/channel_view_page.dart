// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:example/pages/channel/body.dart';
import 'package:flutter/material.dart';
import 'package:youtube_scrape_api/models/channel_data.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class ChannelViewPage extends StatefulWidget {
  final ChannelData data;
  final String id;
  const ChannelViewPage({
    super.key,
    required this.data,
    required this.id,
  });

  @override
  State<ChannelViewPage> createState() => _ChannelViewPageState();
}

class _ChannelViewPageState extends State<ChannelViewPage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.channel.channelName ?? ''),
      ),
      body: Body(
          channelData: widget.data,
          title: widget.data.channel.channelName,
          youtubeDataApi: YoutubeDataApi(),
          channelId: widget.id),
    );
  }
}
