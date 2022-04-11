import 'package:flutter/material.dart';
import 'package:spotigreg_front/components/topappbar.dart';
import 'package:spotigreg_front/screens/search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(scaffoldKey: _key),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {}),
        child: IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(
              Icons.add,
            )),
      ),
      body: const SafeArea(child: Center(child: Text("HOME"))),
    );
  }
}
