// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:spotigreg_front/provider/search_provider.dart';
// import 'package:spotigreg_front/utils/youtube_config.dart';

// class CustomSearchDelegate extends SearchDelegate {
//   CustomSearchDelegate();

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, "close"),
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return StatefulBuilder(builder: (context, setState) {
//       final searchProvider =
//           Provider.of<SearchProvider>(context, listen: false);

//       getYoutube() async {
//         var dio = Dio();
//         Response response =
//             await dio.get(YoutubeConfig.apiEndpoint, queryParameters: {
//           "q": query,
//           "key": YoutubeConfig.apiKey,
//           "type": "video",
//           "maxResults": "${YoutubeConfig.searchResult}",
//           "part": "snippet",
//           "pageToken": searchProvider.pageToken,
//         });
//         if (response.statusCode == 200) {
//           searchProvider.nextPage("");
//           return response.data;
//         } else {
//           searchProvider.nextPage("");
//         }
//       }

//       return FutureBuilder<dynamic>(
//           future: getYoutube(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             searchProvider.nextPage(
//                                 snapshot.data["prevPageToken"].toString());
//                             setState(() {});
//                           },
//                           icon: const Icon(Icons.arrow_back_ios)),
//                       IconButton(
//                           onPressed: () {
//                             searchProvider.nextPage(
//                                 snapshot.data["nextPageToken"].toString());
//                             setState(() {});
//                           },
//                           icon: const Icon(Icons.arrow_circle_right))
//                     ],
//                   ),
//                   SizedBox(
//                     height: 600,
//                     child: ListView.builder(
//                         itemCount: snapshot.data["items"].length,
//                         // itemCount: 10,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                             child: InkWell(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     color: Colors.red,
//                                     height: 100,
//                                     width: 150,
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(5, 0, 0, 0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Text(
//                                         //   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
//                                         //   overflow: TextOverflow.ellipsis,
//                                         // ),
//                                         Text(snapshot.data["items"][index]
//                                                 ["snippet"]["title"]
//                                             .toString()),
//                                         Text('example'),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                           );
//                         }),
//                   ),
//                 ],
//               );
//             } else {
//               print("yppp");
//               return const CircularProgressIndicator();
//             }
//           });
//     });
//   }
//   // );
//   // }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return const Text("suggestions mdr");
//   }
// }
