import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/livechat/livechat_widget.dart';
import 'package:flutter/material.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({super.key});

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    Icons.chevron_left_rounded,
                    colorBackground: ColorNeutral.white,
                    size: IconSize.medium,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(), // Pushes the "Live Chat" text to the center
                  Text(
                    "Live Chat",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(), // Pushes the text back to the center
                  Opacity(
                    opacity: 0,
                    child: CustomIconButton(
                      Icons.chevron_left_rounded,
                      colorBackground: ColorNeutral.white,
                      size: IconSize.medium,
                      onPressed: null,
                    ),
                  ), // Invisible widget for symmetry
                ],
              ),
            ),
             const SizedBox(height: 16), // Spacing
            // Chat message widget for Andika
            Chat1(
              profileImagePath: 'assets/icon/profile-1.png', // Replace with actual path
              username: 'Andika Handayono',
              messageText: 'Masih sepi nih...',
              imagePath: 'assets/icon/event.jpg', // Image path for Andika's message
              timestamp: '06:30',
            ),
            // Chat message widget for Budi
            Chat2(
              profileImagePath: 'assets/icon/profile-2.png', 
              username: 'Aditya Soemarno', 
              messageText: 'Wihh... Otw nih..', 
              timestamp: '06:45'
            ),
            Chat3(
              profileImagePath: 'assets/icon/profile-3.png', 
              username: 'Tiara Siagan', 
              firstMessageText: 'Baru sampek di kampus nih.', 
              firstTimestamp: '06:50', 
              secondMessageText: 'Otw ke atas', 
              secondTimestamp: '06:55'
            ),
          ],
        ),
      ),
    );
  }
}

