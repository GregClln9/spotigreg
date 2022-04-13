import 'package:flutter/material.dart';

class TracksProvider extends ChangeNotifier {
  late final dynamic _tracks = {
    0: {
      "title": "Fefe",
      "url":
          "https://rr5---sn-25glen7y.googlevideo.com/videoplayback?expire=1649907020&ei=7EBXYq2dF6-FvdIP0ty8wAY&ip=86.246.110.187&id=o-AFvcn0JKLyNDkdz1JlmhfcZvfrlB4MvKnvZzwgshsk5M&itag=251&source=youtube&requiressl=yes&mh=hy&mm=31%2C26&mn=sn-25glen7y%2Csn-4g5e6nsk&ms=au%2Conr&mv=m&mvi=5&pl=16&gcr=fr&initcwndbps=1182500&vprv=1&mime=audio%2Fwebm&gir=yes&clen=3194480&dur=179.401&lmt=1639471587557580&mt=1649885092&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIgEJB6iCXDzV1-G51W3x5WyrPc-TRPala9yve_TGq2m5ACIQCAenbRERko_n9rIvldLgkPRfksF-vQmH358ZDyaxkWmQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAPkVg-UuMCSKmtuU-Waj58lAViEaMm8JFGds8Nwy8mmKAiBbd7sBNOBXxFuNysu1SW-mVH3g9Wqo2YfPUDRXIgFJvQ%3D%3Ds"
    },
    1: {
      "title": "Edge",
      "url":
          "https://rr5---sn-25glene6.googlevideo.com/videoplayback?expire=1649908070&ei=BkVXYueUJ6P7xN8P5KC1oA8&ip=86.246.110.187&id=o-AAGp59iImivuENTkPq-BQy3tCanhOPE1uFUA8UwyHzE2&itag=251&source=youtube&requiressl=yes&mh=Ht&mm=31%2C26&mn=sn-25glene6%2Csn-4g5lznl7&ms=au%2Conr&mv=m&mvi=5&pl=16&gcr=fr&initcwndbps=1086250&vprv=1&mime=audio%2Fwebm&gir=yes&clen=3101861&dur=175.741&lmt=1634750291070356&mt=1649886055&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&txp=5432434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRAIgb-fMj-Z-c80QU6AX4l14SgYdHsZnGLysFlpdW9mdhAcCIH75cSgHs4ulDajgakidWki5Z-u3XvezRoiZlUF7Gh4f&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgd_GJs8GYvl1jEn2DJxbt1mNyQeQeLghXouIyjpmmgoYCIAj5rVlOgxCoF1PNCtNGINsLr3-T78X_9eU3yn8UoACp"
    },
    2: {
      "title": "Special",
      "url":
          "https://rr2---sn-25ge7nsk.googlevideo.com/videoplayback?expire=1649908812&ei=7EdXYuepCOXWxN8Pzbq6sA4&ip=86.246.110.187&id=o-ADyGmRq0cZbJEixaEwzabU48xDMBXTjKd7V85NC7u1GB&itag=251&source=youtube&requiressl=yes&mh=sF&mm=31%2C26&mn=sn-25ge7nsk%2Csn-4g5lznes&ms=au%2Conr&mv=m&mvi=2&pl=16&initcwndbps=1073750&vprv=1&mime=audio%2Fwebm&gir=yes&clen=3778030&dur=218.021&lmt=1630294227670234&mt=1649886538&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&rbqsm=ff&txp=5532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhALaX2onzRDDCYnHvXBzVSPz6s-CiMNhn0LYWmmS4bR3HAiBq2ci7srpkWF7PIdYYdpQ7d3NudWe0_GRWnlfCXh2f2w%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgAfqrm5vdSnWR4VOY1L94IJL6bYUqmP7Z7EwF4O5_HHACIQDxmgTnvXRutDDWIdLCpZhUefODs_V2CrVM658VV7OyPQ%3D%3D"
    },
  };

  dynamic get tracks => _tracks;

  void addTrack(String newTrack) {
    notifyListeners();
  }

  void removeTrack(String track) {
    notifyListeners();
  }
}
