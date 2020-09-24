import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:transparent_image/transparent_image.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'movie_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offSet = 1;
  String _baseUrl = "https://image.tmdb.org/t/p/w185";
  var _textFieldController = TextEditingController();

  Future<Map> getMovie() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          "https://api.themoviedb.org/3/trending/movie/week?api_key=2a9d95460bb797267bbb8c1f5fb5528b");
    } else {
      response = await http.get(
          "https://api.themoviedb.org/3/search/movie?api_key=2a9d95460bb797267bbb8c1f5fb5528b&language=en-US&query=$_search&page=$_offSet&include_adult=false");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Avaliação técnica"),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                setState(() {
                  _dialog();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _search = null;
                  _offSet = 1;
                  _textFieldController.clear();
                });
              },
            ),
          ],
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: "Pesquise Aqui !",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
              onTap: () {},
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
              controller: _textFieldController,
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
    if (_search == null || _search.isEmpty) {
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MoviePage(snapshot.data["results"][index])));
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offSet += 1;
                });
              },
            ),
          );
      },
    );
  }

  Future<void> _dialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Aviso"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Gostaria de dizer que não consegui terminar toda a prova,(porém sei oq cada linha significa)pois com início da pandemia tive que ficar fulltime com minha filha de 2 anos,assim tive que reduzir drasticamente minhas horas de estudos e filtrar oq seria ou não estudado.\nAssim me faltou tempo para tratar alguns erros bobos,criar a página de favoritos com bloC e fazer check nas informações nas entradas de dados\n\nDesde de já Agradeço pela oportnidade e se não der dessa vez, peço que me avisem em uma nova oportuinidade."),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
