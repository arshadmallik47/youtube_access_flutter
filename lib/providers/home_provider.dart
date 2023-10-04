import 'package:example/helpers/shared_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  SharedHelper sharedHelper = SharedHelper();
  SharedPreferences? sharedPreferences;
  Future<bool> checkSubscribedChannels(String channelId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences!.getString(channelId) != null;
  }

  Future<void> unSubscribe(String channelId) async {
    sharedHelper.unSubscribeChannel(channelId);
  }
}
