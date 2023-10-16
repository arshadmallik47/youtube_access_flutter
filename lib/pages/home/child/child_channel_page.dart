import 'package:example/pages/channel_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:example/providers/child_provider.dart';
import 'package:youtube_scrape_api/models/channel_data.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class ChildChannelPage extends StatefulWidget {
  const ChildChannelPage({Key? key}) : super(key: key);

  @override
  State<ChildChannelPage> createState() => _ChildChannelPageState();
}

class _ChildChannelPageState extends State<ChildChannelPage> {
  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: childProvider.currentChild?.channels.length,
        itemBuilder: (BuildContext context, int index) {
          final channelId = childProvider.currentChild?.channels[index];
          return FutureBuilder<ChannelData?>(
            future: YoutubeDataApi().fetchChannelData(channelId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('loading...'),
                );
              }
              if (snapshot.hasError) {
                return const Text('An error occurred while fetching data.');
              }
              if (!snapshot.hasData) {
                return const Text('No data found');
              }
              if (snapshot.hasData) {
                final channel = snapshot.data!;
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ChannelViewPage(
                              data: channel,
                              id: channelId,
                            )),
                      ),
                    );
                  },
                  title: Text(channel.channel.channelName ?? ''),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(channel.channel.avatar ?? ''),
                            fit: BoxFit.cover)),
                  ),
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
