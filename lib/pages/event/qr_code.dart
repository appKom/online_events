import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/core/client/client.dart';
import '/core/models/event_model.dart';
import '/components/animated_button.dart';
import '/dark_overlay.dart';
import '/theme/theme.dart';

class QRCode extends DarkOverlay {
  QRCode({required this.model});
  final EventModel model;

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    final padding = MediaQuery.of(context).padding;

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: Client.userCache,
              builder: (context, user, child) {
                if (user == null) return const Text('');
                String qrData = '${user.rfid},${user.username},${model.id},true';
                return Column(
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: OnlineTheme.textStyle(size: 25, weight: 7),
                    ),
                    const SizedBox(height: 40),
                    SizedBox.square(
                      dimension: maxSize - padding.horizontal - 50,
                      child: AnimatedButton(
                        childBuilder: (context, hover, pointerDown) {
                          return QrImageView(
                            backgroundColor: OnlineTheme.current.fg,
                            data: qrData,
                            version: QrVersions.auto,
                            size: maxSize - padding.horizontal - 50,
                            // embeddedImage: const AssetImage('assets/images/online_hvit_o.png'),
                            // embeddedImageStyle: QrEmbeddedImageStyle(
                            //   size: Size(100, 100),
                            // ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ],
      );
    });
  }
}
