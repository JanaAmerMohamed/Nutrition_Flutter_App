import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';


const appId = '72a681654ba24ec6923d56d602054d4c';
String channelName = 'videocall';
String token = '007eJxTYIj0Drl0ISuJ7dCmioYuG9vcmZuC91koC149qZVo2Rf89bkCg7lRopmFoZmpSVKikUlqspmlkXGKqVmKmYGRgalJikkyO4NKWkMgI0Nb5wFmRgYIBPE5GcoyU1LzkxNzchgYAH1XH2M=';
int uid = 0; // uid of the local user


class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyAppState2();
}

class _MyAppState2 extends State<MyApp2> {

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: channelName,
      tempToken: token,
      uid: uid,
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UI Kit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }

}