import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/components/search/custom_textfiled.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import 'package:spotigreg_front/utils/utils.dart';

class DownloadModalBottom extends ConsumerWidget {
  const DownloadModalBottom({
    Key? key,
    this.title,
    this.id,
    this.artiste,
    this.cover,
    this.duration,
    this.url,
    this.idUpdate,
    required this.isUpdate,
  }) : super(key: key);

  final String? id;
  final String? title;
  final String? artiste;
  final String? duration;
  final String? url;
  final String? cover;
  final int? idUpdate;
  final bool isUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController artisteController = TextEditingController();

    // print(idUpdate.toString() + " id update");

    double mHeight = MediaQuery.of(context).size.height;
    titleController.text = title.toString();
    artisteController.text = artiste.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 61, 61, 61),
        ),
        height: mHeight * 0.70,
        child: Column(
          children: [
            Flexible(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(150, 10, 150, 0),
                      child: Divider(
                        color: secondaryText,
                        thickness: 4,
                      ),
                    ),
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
                child: InkWell(
                    onTap: () {
                      (isUpdate)
                          ? updateTrack(context, ref, idUpdate,
                              titleController.text, artisteController.text, id)
                          : downloadNewTrack(context, ref, id, title, duration,
                              cover, url, titleController, artisteController);
                    },
                    child: Icon(Icons.download, color: primaryColor))),
          ],
        ),
      ),
    );
  }
}

downloadNewTrack(
  BuildContext context,
  WidgetRef ref,
  String? id,
  String? title,
  String? duration,
  String? cover,
  String? url,
  TextEditingController titleController,
  TextEditingController artisteController,
) async {
  bool alreadyDownload = false;

  for (int key in box.keys) {
    if (box.get(key)?.id == id) {
      showSnackBar(context, 'Vidéo déjà enregistrée !', SnackBarState.error);
      alreadyDownload = true;
    }
  }
  if (!alreadyDownload) {
    try {
      await TracksUtils.addTrack(
          id.toString(),
          titleController.text,
          artisteController.text,
          duration as String,
          cover as String,
          url as String,
          context);
    } catch (e) {
      showSnackBar(
          context, "Erreur pendant le téléchargement", SnackBarState.error);
      Navigator.pop(context);
      return;
    }

    final pageManager = ref.read(pageManagerProvider);
    if (pageManager.sortByMoreRecent) {
      pageManager.addMoreRecent(
        box.get(box.keys.last)!.id.toString(),
        box.get(box.keys.last)!.title.toString(),
        box.get(box.keys.last)!.title.toString(),
        box.get(box.keys.last)!.url.toString(),
        box.get(box.keys.last)!.cover.toString(),
        box.get(box.keys.last)!.artiste.toString(),
      );
    } else {
      pageManager.add(
        box.get(box.keys.last)!.id.toString(),
        box.get(box.keys.last)!.title.toString(),
        box.get(box.keys.last)!.title.toString(),
        box.get(box.keys.last)!.url.toString(),
        box.get(box.keys.last)!.cover.toString(),
        box.get(box.keys.last)!.artiste.toString(),
      );
    }

    Navigator.pop(context);
  }
}

updateTrack(BuildContext context, WidgetRef ref, int? idUpdate, String? title,
    String? artist, String? id) async {
  // try {
  //   await TracksUtils.putTrack(
  //       box.get(idUpdate)!.id.toString(), title.toString(), artist.toString());
  // } catch (e) {
  //   showSnackBar(context, "Oups, une petite erreur 😅 dans l'update",
  //       SnackBarState.error);
  //   Navigator.pop(context);
  //   return;
  // }
  final pageManager = ref.read(pageManagerProvider);
  pageManager.update(idUpdate.toString(), title.toString(), artist.toString());

  Navigator.pop(context);
}
