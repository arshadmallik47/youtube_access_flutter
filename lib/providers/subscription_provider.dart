import 'dart:convert';

import 'package:example/helpers/shared_helper.dart';
import 'package:example/models/subscribed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_scrape_api/models/video_data.dart';

class SubscriptionProvider with ChangeNotifier {
  final _sharedHelper = SharedHelper();
  List<String>? _subscribers = [];

  List<String>? get subscribers => _subscribers;

  Future<void> loadAllSubscribers() async {
    _subscribers =
        _sharedHelper.sharedPreferences!.getStringList('subscribedChannelsIds');
    notifyListeners();
  }

  void subscribe({required VideoData videoData}) {
    final data = videoData.video!;
    final subscribed = Subscribed(
        username: data.channelName,
        channelId: data.channelId,
        avatar: data.channelThumb,
        videosCount: "");
    _sharedHelper.subscribeChannel(
        videoData.video!.channelId!, jsonEncode(subscribed.toJson()));
    _subscribers!.add(videoData.video!.channelId!);
    notifyListeners();
  }

  void unsubscribe({required String channelId}) {
    _sharedHelper.unSubscribeChannel(channelId);
    _subscribers?.removeWhere((element) => element == channelId);
  }
}
