import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() => runApp(const MessengerChatHead());

// Entry point for overlay
@pragma('vm:entry-point')
void overlayMain() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatHeadOverlay(),
  ));
}

class MessengerChatHead extends StatelessWidget {
  const MessengerChatHead({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatHeadController(),
    );
  }
}

class ChatHeadController extends StatefulWidget {
  const ChatHeadController({super.key});

  @override
  State<ChatHeadController> createState() => _ChatHeadControllerState();
}

class _ChatHeadControllerState extends State<ChatHeadController> {
  bool _overlayActive = false;

  Future<void> _requestPermission() async {
    final status = await FlutterOverlayWindow.requestPermission();
    setState(() {
      _overlayActive = status!;
    });
  }

  Future<void> _showOverlay() async {

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Chat Head",
      overlayContent: "Messenger Chat Head",
      flag: OverlayFlag.defaultFlag,
      alignment: OverlayAlignment.centerRight,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 100,
      width: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Head Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:  _requestPermission,
              child: const Text( 'Enable Overlay Permission'),
            ),
            ElevatedButton(
              onPressed:  _showOverlay ,
              child: const Text('Open Chat Head Bubble' ),
            ),
            const SizedBox(height: 20),
            const ElevatedButton(
              onPressed: FlutterOverlayWindow.closeOverlay,
              child: Text('Close Chat Head'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatHeadOverlay extends StatefulWidget {
  const ChatHeadOverlay({super.key});

  @override
  State<ChatHeadOverlay> createState() => _ChatHeadOverlayState();
}

class _ChatHeadOverlayState extends State<ChatHeadOverlay> {
  Offset position = const Offset(0, 0);
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onPanEnd: (details) {
          setState(() {
            isDragging = false;
          });
        },
        onTap: () {
          // Handle chat head tap
          print('Chat head tapped!');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(position.dx, position.dy, 0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/profile_picture.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
