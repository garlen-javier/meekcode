

import 'package:flutter/material.dart';

class NetworkManager {

  NetworkManager._constructor();
  static final NetworkManager _instance = NetworkManager._constructor();

  factory NetworkManager(){
    return _instance;
  }

  String host = "10.0.3.2";
  int port = 5555;

  void updateAddress({@required String hostIP, @required int portNum}){
    host = hostIP;
    port = portNum;
  }

}