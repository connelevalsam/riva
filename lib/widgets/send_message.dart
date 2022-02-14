import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {
  final int counter;
  final VoidCallback callback;

  const SendMessage({Key? key, required this.counter, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: callback,
          child: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/icon_message_white.png"),
            radius: 20,
          ),
        ),
        counter != 0
            ? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$counter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
