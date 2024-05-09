import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:nutrition_app/dashboard.dart';
import 'package:permission_handler/permission_handler.dart';
ProductName currentProduct = ProductName.voiceCalling;  // Assuming ProductName is an enum defined in the imported package

late Map<String, dynamic> config = {}; // Initialize with an empty map
int localUid = -1;
String appId = "72a681654ba24ec6923d56d602054d4c", channelName = "videocall";
List<int> remoteUids = [];
bool isJoined = false;
bool isBroadcaster = true;
RtcEngine? agoraEngine;


Future<void> setupAgoraEngine() async {
  // Retrieve or request camera and microphone permissions
  await [Permission.microphone, Permission.camera].request();

  // Create an instance of the Agora engine
  agoraEngine = createAgoraRtcEngine();
  await agoraEngine!.initialize(RtcEngineContext(appId: appId));

  if (currentProduct != ProductName.voiceCalling) {
    await agoraEngine!.enableVideo();
  }

  // Register the event handler
  agoraEngine!.registerEventHandler(getEventHandler());
}


RtcEngineEventHandler getEventHandler() {
  return RtcEngineEventHandler(
    onConnectionStateChanged: (RtcConnection connection, ConnectionStateType state, ConnectionChangedReasonType reason) {
      if (reason == ConnectionChangedReasonType.connectionChangedLeaveChannel) {
        remoteUids.clear();
        isJoined = false;
      }
      Map<String, dynamic> eventArgs = {};
      eventArgs["connection"] = connection;
      eventArgs["state"] = state;
      eventArgs["reason"] = reason;
      eventCallback("onConnectionStateChanged", eventArgs); // Assuming eventCallback is defined elsewhere
    },
    onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      isJoined = true;
      messageCallback(
          "Local user uid:${connection.localUid} joined the channel");
      // Notify the UI
      Map<String, dynamic> eventArgs = {};
      eventArgs["connection"] = connection;
      eventArgs["elapsed"] = elapsed;
      eventCallback("onJoinChannelSuccess", eventArgs);
    },
    // Occurs when a remote user joins the channel
    onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      remoteUids.add(remoteUid);
      messageCallback("Remote user uid:$remoteUid joined the channel");
      // Notify the UI
      Map<String, dynamic> eventArgs = {};
      eventArgs["connection"] = connection;
      eventArgs["remoteUid"] = remoteUid;
      eventArgs["elapsed"] = elapsed;
      eventCallback("onUserJoined", eventArgs);
    },
    // Occurs when a remote user leaves the channel
    onUserOffline: (RtcConnection connection, int remoteUid,
        UserOfflineReasonType reason) {
      remoteUids.remove(remoteUid);
      messageCallback("Remote user uid:$remoteUid left the channel");
      // Notify the UI
      Map<String, dynamic> eventArgs = {};
      eventArgs["connection"] = connection;
      eventArgs["remoteUid"] = remoteUid;
      eventArgs["reason"] = reason;
      eventCallback("onUserOffline", eventArgs);
    },

  );
}

void eventCallback(String eventName, Map<String, dynamic> args) {
  // Define your event callback logic here
}

void messageCallback(String message) {
  // Define your message callback logic here
}

AgoraVideoView remoteVideoView(int remoteUid) {
  return AgoraVideoView(
    controller: VideoViewController.remote(
      rtcEngine: agoraEngine!,
      canvas: VideoCanvas(uid: remoteUid),
      connection: RtcConnection(channelId: channelName),
    ),
  );
}

Widget localVideoView() {
  return AgoraVideoView(
    controller: VideoViewController(
      rtcEngine: agoraEngine!,
      canvas: const VideoCanvas(uid: 0),
    ),
  );
}


Future<void> leave() async {
  remoteUids.clear();
  if (agoraEngine != null) {
    await agoraEngine!.leaveChannel();
  }
  isJoined = false;
  destroyAgoraEngine();
}

void destroyAgoraEngine() {
  if (agoraEngine != null) {
    agoraEngine!.release();
    agoraEngine = null;
  }
}

// Assume currentProduct and ProductName are defined somewhere
enum ProductName { voiceCalling }


class MyAppvideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Agora Demo'),
        ),
      ),
    );
  }
}


