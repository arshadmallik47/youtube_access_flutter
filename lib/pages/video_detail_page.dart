// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_field

import 'dart:convert';
import 'package:example/Utils/child_channel_popup.dart';
import 'package:example/Utils/child_video_popup.dart';
import 'package:example/Utils/utils.dart';
import 'package:example/models/child_model.dart';
import 'package:example/models/subscribed.dart';
import 'package:example/providers/auth_provider.dart';
import 'package:example/providers/child_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:youtube_scrape_api/models/video_data.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';
import '../constants.dart';
import '../helpers/shared_helper.dart';
import '/theme/colors.dart';
import 'channel/channel_page.dart';

class VideoDetailPage extends StatefulWidget {
  String videoId;

  VideoDetailPage({super.key, required this.videoId});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  //Subscribed? subscribed;
  bool isSwitched = true;
  late PodPlayerController _controller;
  AuthProvider authProvider = AuthProvider();

  // for video player
  late int _playBackTime;

  //The values that are passed when changing quality
  late Duration newCurrentPosition;

  YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  VideoData? videoData;
  double? progressPadding;
  final unknown = "Unknown";
  bool isSubscribed = false;
  SharedHelper sharedHelper = SharedHelper();
  late Future<bool> checkFuture;
  ChildModel? childModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      // checkFuture = check();
    });
    _controller = PodPlayerController(
      playVideoFrom:
          PlayVideoFrom.youtube('https://youtu.be/${widget.videoId}'),
    )..initialise();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressPadding = MediaQuery.of(context).size.height * 0.3;
    return Scaffold(
      backgroundColor: SecondaryColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: <Widget>[
          PodVideoPlayer(controller: _controller),
          FutureBuilder(
            future: youtubeDataApi.fetchVideoData(widget.videoId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Padding(
                    padding: EdgeInsets.only(top: progressPadding!),
                    child: const CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return Padding(
                    padding: EdgeInsets.only(top: progressPadding!),
                    child: const CircularProgressIndicator(),
                  );
                case ConnectionState.none:
                  return const Text("Connection None");
                case ConnectionState.done:
                  if (snapshot.error != null) {
                    return Center(child: Text(snapshot.stackTrace.toString()));
                  } else {
                    if (snapshot.hasData) {
                      videoData = snapshot.data;
                      return Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: size.width - 80,
                                        child: Text(
                                          videoData?.video?.title ?? "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cairo',
                                              color: white.withOpacity(0.8),
                                              fontWeight: FontWeight.w500,
                                              height: 1.3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: GestureDetector(
                                          onTap: () {
                                            _controller.pause();
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            LineIcons.angleDown,
                                            color: white.withOpacity(0.7),
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        videoData?.video?.date ?? "",
                                        style: TextStyle(
                                            color: white.withOpacity(0.4),
                                            fontSize: 13,
                                            fontFamily: 'Cairo'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        videoData?.video?.viewCount ?? "",
                                        style: TextStyle(
                                            color: white.withOpacity(0.4),
                                            fontSize: 13,
                                            fontFamily: 'Cairo'),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Column(
                                          children: <Widget>[
                                            // Icon(
                                            //   LineIcons.thumbsUp,
                                            //   color: white.withOpacity(0.5),
                                            //   size: 26,
                                            // ),
                                            // const SizedBox(
                                            //   height: 2,
                                            // ),
                                            // Text(
                                            //   videoData?.video?.likeCount ?? "",
                                            //   style: TextStyle(
                                            //       color: white.withOpacity(0.4),
                                            //       fontSize: 13,
                                            //       fontFamily: 'Cairo'),
                                            // )
                                          ],
                                        ),
                                        // Column(
                                        //   children: <Widget>[
                                        //     Icon(
                                        //       LineIcons.thumbsDown,
                                        //       color: white.withOpacity(0.5),
                                        //       size: 26,
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 2,
                                        //     ),
                                        //     Text(
                                        //       'Dislike',
                                        //       style: TextStyle(
                                        //           color: white.withOpacity(0.4),
                                        //           fontSize: 13,
                                        //           fontFamily: 'Cairo'),
                                        //     )
                                        //   ],
                                        // ),
                                        InkWell(
                                          onTap: (() async {
                                            final videoId =
                                                videoData!.video!.videoId;
                                            final videoUrl =
                                                'https://www.youtube.com/watch?v=$videoId';
                                            FlutterShare.share(
                                              linkUrl: videoUrl,
                                              title: 'Share',
                                            );
                                          }),
                                          child: Column(
                                            children: <Widget>[
                                              Icon(
                                                LineIcons.share,
                                                color: white.withOpacity(0.5),
                                                size: 26,
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              //InkWell(

                                              Text(
                                                "Share",
                                                style: TextStyle(
                                                    color:
                                                        white.withOpacity(0.4),
                                                    fontSize: 13,
                                                    fontFamily: 'Cairo'),
                                              ),
                                              // )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          child: Column(
                                            children: <Widget>[
                                              Icon(
                                                LineIcons.download,
                                                color: white.withOpacity(0.5),
                                                size: 26,
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Download",
                                                style: TextStyle(
                                                    color:
                                                        white.withOpacity(0.4),
                                                    fontSize: 13,
                                                    fontFamily: 'Cairo'),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Column(
                                        //   children: <Widget>[
                                        //     Icon(
                                        //       LineIcons.plus,
                                        //       color: white.withOpacity(0.5),
                                        //       size: 26,
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 2,
                                        //     ),
                                        //     Text(
                                        //       "Save",
                                        //       style: TextStyle(
                                        //           color: white.withOpacity(0.4),
                                        //           fontSize: 13,
                                        //           fontFamily: 'Cairo'),
                                        //     )
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Utils.navigateTo(
                                                context,
                                                AllowVideoPopup(
                                                    video: videoData!));

                                            // final videoId =
                                            //     videoData!.video!.videoId!;
                                            // final childProvider =
                                            //     Provider.of<ChildProvider>(
                                            //         context);
                                            // childProvider.allowVideoForChild(
                                            //     videoId, childModel!.uid);
                                          },
                                          child: const Text(
                                            'Allow Video for child',
                                            style: TextStyle(fontSize: 12),
                                          )),
                                      ElevatedButton(
                                          onPressed: () {
                                            Utils.navigateTo(
                                              context,
                                              AllowChannelPopup(
                                                  channel: videoData!),
                                            );
                                          },
                                          child: const Text(
                                            'Add Channel for child',
                                            style: TextStyle(fontSize: 12),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: white.withOpacity(0.1),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _controller.pause();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChannelPage(
                                                id: videoData!.video!.channelId,
                                                title: videoData!
                                                    .video!.channelName)),
                                      );
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                  image: NetworkImage(videoData!
                                                      .video!.channelThumb!),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              180),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                videoData?.video?.channelName ??
                                                    "",
                                                style: TextStyle(
                                                    color: white,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.3),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    videoData?.video
                                                            ?.subscribeCount ??
                                                        '',
                                                    style: TextStyle(
                                                      color: white
                                                          .withOpacity(0.4),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isSubscribed) {
                                        unSubscribe();
                                      } else {
                                        subscribe();
                                      }
                                    },
                                    child: Text(
                                      isSubscribed
                                          ? 'UNSUBSCRIBE'
                                          : "SUBSCRIBE",
                                    ),
                                  ),
                                  // FutureBuilder<bool>(
                                  //     future: checkFuture,
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.hasData) {
                                  //         isSubscribed = snapshot.data!;
                                  //         return GestureDetector(
                                  //           onTap: () {
                                  //             if (isSubscribed) {
                                  //               unSubscribe();
                                  //             } else {
                                  //               subscribe();
                                  //             }
                                  //           },
                                  //           child: Text(
                                  //             isSubscribed
                                  //                 ? 'UNSUBCRIBE'
                                  //                 : "SUBSCRIBE",
                                  //             style: TextStyle(
                                  //                 color: red,
                                  //                 fontWeight: FontWeight.bold,
                                  //                 fontFamily: 'Cairo'),
                                  //           ),
                                  //         );
                                  //       } else {
                                  //         return const SizedBox();
                                  //       }
                                  //     }),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: white.withOpacity(0.1),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 0, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Up next",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: white.withOpacity(0.4),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Cairo'),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Autoplay",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: white.withOpacity(0.4),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Cairo'),
                                      ),
                                      Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                            });
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: videoData?.videosList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            String videoId = videoData!
                                                .videosList[index].videoId!;
                                            _changeVideo(videoId);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          50) /
                                                      2,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image: DecorationImage(
                                                          image: Image.network(
                                                                  videoData!
                                                                      .videosList[
                                                                          index]
                                                                      .thumbnails![
                                                                          1]
                                                                      .url!)
                                                              .image,
                                                          fit: BoxFit.cover)),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        bottom: 10,
                                                        right: 12,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              videoData!
                                                                      .videosList[
                                                                          index]
                                                                      .duration ??
                                                                  "00:00",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: white
                                                                      .withOpacity(
                                                                          0.4),
                                                                  fontFamily:
                                                                      'Cairo'),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              130) /
                                                          2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            videoData!
                                                                    .videosList[
                                                                        index]
                                                                    .title ??
                                                                unknown,
                                                            style: TextStyle(
                                                                color: white
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.3,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Cairo'),
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            videoData!
                                                                    .videosList[
                                                                        index]
                                                                    .channelName ??
                                                                unknown,
                                                            style: TextStyle(
                                                                color: white
                                                                    .withOpacity(
                                                                        0.4),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Cairo'),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                videoData!
                                                                        .videosList[
                                                                            index]
                                                                        .views ??
                                                                    unknown,
                                                                style: TextStyle(
                                                                    color: white
                                                                        .withOpacity(
                                                                            0.4),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'Cairo'),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      LineIcons
                                                          .horizontalEllipsis,
                                                      color: white
                                                          .withOpacity(0.4),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                    } else {
                      return const Center(child: Text("No data"));
                    }
                  }
              }
            },
          )
        ],
      ),
    );
  }

  void _changeVideo(String videoId) {
    _controller.changeVideo(
        playVideoFrom: PlayVideoFrom.youtube("https://youtu.be/$videoId"));
    setState(() {
      widget.videoId = videoId;
    });
  }

  void subscribe() async {
    if (videoData != null && videoData!.video != null) {
      final data = videoData!.video!;
      final subscribed = Subscribed(
          username: data.channelName,
          channelId: data.channelId,
          avatar: data.channelThumb,
          videosCount: "");
      sharedHelper.subscribeChannel(
          videoData!.video!.channelId!, jsonEncode(subscribed.toJson()));
      setState(() {
        isSubscribed = true;
      });
    }
  }

  void unSubscribe() async {
    sharedHelper.unSubscribeChannel(videoData!.video!.channelId!);
    setState(() {
      isSubscribed = false;
    });

    ///TODO: Unsubscribe channel from video page
  }

  // download
  // Future<void> downloadVideo() async {
  //   final String youtubeVideoId = videoData!.video!.videoId!;
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: 'https://www.youtube.com/watch?v=$youtubeVideoId',
  //     savedDir: '/storage/emulated/0/Download',
  //     fileName: '$youtubeVideoId.mp4',
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  //   print('Download task ID: $taskId');
  // }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AllowVideoPopup(video: videoData!);
      },
    );
  }
}
