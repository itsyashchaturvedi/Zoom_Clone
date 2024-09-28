import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  

import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VibeMeet',
      home: HomePage(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/vibemeet.png'),
              const SizedBox(height: 20),
              const Text(
                'Welcome to VibeMeet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final String userId = Random().nextInt(900000 + 100000).toString();
final String randomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/vibemeet.png',
              // width: MediaQuery.of(context).size.width * 0.6,
            ),
            Text('Your UserId:$userId'),
            const Text('Please test with two or more devices'),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Join a meeting by Input an ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text(
                'Join a meeting',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: conferenceIdController.text,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text(
                'New Meeting ',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: randomConferenceId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  jumpToMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConferencePage(
          conferenceID: conferenceId,
        ),
      ),
    );
  }
}

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  VideoConferencePage({super.key, required this.conferenceID});

  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: 'user_$userId',
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Leave the meeting",
            message: "Are you sure to leave the meeting?",
            
            cancelButtonName: "Cancel",
            confirmButtonName: "Confirm",
            
          )
        ),
      ),
    );
  }
}


         