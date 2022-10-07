import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/components/search/custom_textfiled.dart';
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import 'package:spotigreg_front/utils/utils.dart';
import '../storage/tracks_hive.dart';

class DownloadModalBottom extends ConsumerWidget {
  const DownloadModalBottom({
    Key? key,
    this.title,
    this.id,
    this.artiste,
    this.cover,
    this.duration,
    this.url,
  }) : super(key: key);

  final String? id;
  final String? title;
  final String? artiste;
  final String? duration;
  final String? url;
  final String? cover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController artisteController = TextEditingController();

    double mHeight = MediaQuery.of(context).size.height;

    titleController.text = title.toString();
    artisteController.text = artiste.toString();

    Box<TracksHive> box = Boxes.getTracks();
    bool alreadyDownload = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: const Color.fromARGB(255, 61, 61, 61),
        height: mHeight * 0.3,
        child: Column(
          children: [
            Flexible(
                flex: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        controller: titleController,
                        hintText: title.toString(),
                        title: "Titre :",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                          controller: artisteController,
                          hintText: artiste.toString(),
                          title: "Artiste :"),
                    )
                  ],
                )),
            Flexible(
              flex: 2,
              child: IconButton(
                  onPressed: (() {
                    for (int key in box.keys) {
                      if (box.get(key)?.id == id) {
                        showSnackBar(context, 'Vidéo déjà enregistrée !',
                            SnackBarState.error);
                        alreadyDownload = true;
                      }
                    }
                    if (!alreadyDownload) {
                      TracksUtils.addTrack(
                          id.toString(),
                          titleController.text,
                          artisteController.text,
                          duration.toString(),
                          cover.toString(),
                          url.toString(),
                          context);

                      final pageManager = ref.read(pageManagerProvider);
                      pageManager.add(
                          box.get(box.keys.last)!.artiste.toString(),
                          box.get(box.keys.last)!.title.toString(),
                          box.get(box.keys.last)!.title.toString(),
                          box.get(box.keys.last)!.url.toString());

                      Navigator.pop(context);
                    }
                  }),
                  icon: Icon(Icons.download, color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
