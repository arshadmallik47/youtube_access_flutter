// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/firestore_collection.dart';
import 'package:example/models/child_model.dart';
import 'package:example/providers/child_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final childProvider = Provider.of<ChildProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Videos'),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: childrenCollection(parentId: childProvider.currentuser!.uid)
              .get(),
          builder: (contex, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No child found'));
            } else {
              final data = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                // separatorBuilder: (BuildContext context, int index) {
                //   return const SizedBox();
                // },
                itemBuilder: (BuildContext context, int index) {
                  // final videoId = data[index]['childName'];
                  final child = ChildModel.fromJson(
                      data[index].data() as Map<String, dynamic>);

                  return ListTile(
                    title: Text(child.imageUrl),
                  );
                },
              );
            }
          },
        ));
  }
}
