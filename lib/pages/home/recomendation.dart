// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/pages/channel_view_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_scrape_api/models/channel_data.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

class RecommendationPage extends StatefulWidget {
  ///String? videoId;
  const RecommendationPage({
    super.key,
  });

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('recommendation').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("SomeThing went wrong!");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Text('No Data Found!');
            }
            if (snapshot != null && snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final channelId = snapshot.data!.docs[index]['channelID'];

                  return FutureBuilder<ChannelData?>(
                      future: youtubeDataApi.fetchChannelData(channelId),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          final data = snapshot.data!;
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => ChannelViewPage(
                                        data: data,
                                        id: channelId,
                                      )),
                                ),
                              );
                            },
                            title: Text(data.channel.channelName ?? ''),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          data.channel.avatar ?? ''),
                                      fit: BoxFit.cover)),
                            ),
                          );
                        } else {
                          return const Text('Loading...');
                        }
                      });
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
