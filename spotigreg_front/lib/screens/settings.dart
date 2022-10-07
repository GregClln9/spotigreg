import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      // "👨‍💻 Github: @GregClln9",
      "SpotiGreg version 1.0",
    ];
    return Scaffold(
        appBar: AppBar(title: const Text("Préferences")),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    contentPadding:
                        const EdgeInsets.only(left: 20.0, right: 0.0),
                    title: Text(
                      items[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      switch (index) {
                        case 0:
                          break;
                        default:
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }
}
