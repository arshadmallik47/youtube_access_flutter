import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider with ChangeNotifier {
  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;

  void subscribe() async {
    _isSubscribed = true;
    notifyListeners();
  }

  void unSubscribe() async {
    _isSubscribed = false;
    notifyListeners();
  }

  bool isUserSubscribed(String channelId) {
    return false;
  }
}
