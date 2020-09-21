import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  String _baseUrl = "https://image.tmdb.org/t/p/w185";

  Future<Map> getMovie() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          "https://api.themoviedb.org/3/trending/movie/week?api_key=2a9d95460bb797267bbb8c1f5fb5528b");
    } else {
      response = await http.get(
          "https://api.themoviedb.org/3/search/company?api_key=2a9d95460bb797267bbb8c1f5fb5528b&query=$_search&page=1");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mais polurares da semana"),
          leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              iconSize: 20,
              onPressed: () {}),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: "Pesquise Aqqqqui !",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getMovie(),
              builder: (context, snappShot) {
                switch (snappShot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6, // --> leia stroke
                      ),
                    );

                  default:
                    if (snappShot.hasError) {
                      return Container(
                        child: SizedBox(
                          height: 200,
                          width: 300,
                        ),
                      );
                    } else
                      return _createMovieTable(context,
                          snappShot); //_createGifTable(context, snappShot);
                }
              },
            ),
          ),
        ]));
  }

  int _getCount(List results) {
    if (_search == null) {
      return results.length;
    } else
      return results.length + 1;
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["results"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["results"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
                image:
                    _baseUrl + snapshot.data["results"][index]["poster_path"],
                placeholder: kTransparentImage,
                width: 300.0,
                fit: BoxFit.fill),
            onTap: () {},
          );
        else
          return Container(); //implementar o else
      },
    );
  }
}
