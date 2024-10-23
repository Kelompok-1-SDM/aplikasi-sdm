import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/main.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class Chat1 extends StatelessWidget {
  final String profileImagePath;
  final String username;
  final String messageText;
  final String imagePath; // This will be the image path for the chat bubble
  final String timestamp;

  const Chat1({
    Key? key,
    required this.profileImagePath,
    required this.username,
    required this.messageText,
    required this.imagePath,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(profileImagePath),
          ),
          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  username,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ColorNeutral.gray, // Light gray text color
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),

                // Chat bubble with text
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: ColorNeutral.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    messageText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ColorNeutral.black,
                        ),
                  ),
                ),
                const SizedBox(height: 8),

                ImageLoader(
                  author: username,
                  showCaption: false,
                  imageUrl: imagePath,
                  caption: messageText,
                  authorUrl: profileImagePath,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    timestamp,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: ColorNeutral.gray,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Chat2 extends StatelessWidget {
  final String profileImagePath;
  final String username;
  final String messageText;
  final String timestamp;

  const Chat2({
    Key? key,
    required this.profileImagePath,
    required this.username,
    required this.messageText,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(profileImagePath),
          ),
          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  username,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade400, // Light gray text color
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),

                // Chat bubble with text
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    messageText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                const SizedBox(height: 8),

                // Timestamp below the text bubble
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    timestamp,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Chat3 extends StatelessWidget {
  final String profileImagePath;
  final String username;
  final String firstMessageText;
  final String firstTimestamp;
  final String secondMessageText;
  final String secondTimestamp;

  const Chat3({
    Key? key,
    required this.profileImagePath,
    required this.username,
    required this.firstMessageText,
    required this.firstTimestamp,
    required this.secondMessageText,
    required this.secondTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(profileImagePath),
          ),
          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  username,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade400, // Light gray text color
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),

                // First chat bubble
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    firstMessageText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                const SizedBox(height: 8),

                // Timestamp for the first message
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    firstTimestamp,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                  ),
                ),

                const SizedBox(height: 16),

                // Second chat bubble
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    secondMessageText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                const SizedBox(height: 8),

                // Timestamp for the second message
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    secondTimestamp,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class LiveChatPage extends StatefulWidget {
//   @override
//   _LiveChatPageState createState() => _LiveChatPageState();
// }

// // class _LiveChatPageState extends State<LiveChatPage> {
//   final TextEditingController _controller = TextEditingController();
//   bool isTyping = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Live Chat"),
//       ),
//       body: Stack(
//         children: [
//           // Your main chat messages UI goes here
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   // Text input field
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       onChanged: (text) {
//                         setState(() {
//                           isTyping = text.isNotEmpty;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Ketik pesan',
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 15.0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8.0),
//                   // File upload button
//                   IconButton(
//                     icon: Icon(Icons.attach_file),
//                     onPressed: () {
//                       // Implement file picker functionality
//                     },
//                   ),
//                   // Send button
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: isTyping
//                         ? () {
//                             // Implement send message functionality
//                             print("Message sent: ${_controller.text}");
//                             _controller.clear();
//                             setState(() {
//                               isTyping = false;
//                             });
//                           }
//                         : null,
//                     color: isTyping ? Theme.of(context).primaryColor : Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FloatingChatInput extends StatefulWidget {
  final Function(String message) onSendMessage;
  final Function() onFileUpload;

  const FloatingChatInput({
    Key? key,
    required this.onSendMessage,
    required this.onFileUpload,
  }) : super(key: key);

  @override
  _FloatingChatInputState createState() => _FloatingChatInputState();
}

class _FloatingChatInputState extends State<FloatingChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                setState(() {
                  isTyping = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ketik pesan',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          // File upload button
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: widget.onFileUpload,
          ),
          // Send button
          IconButton(
            icon: Icon(Icons.send),
            onPressed: isTyping
                ? () {
                    widget.onSendMessage(_controller.text);
                    _controller.clear();
                    setState(() {
                      isTyping = false;
                    });
                  }
                : null,
            color: isTyping ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ],
      ),
    );
  }
}
