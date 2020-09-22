import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  final Map _movieResults;
  MoviePage(this._movieResults);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_movieResults["title"]),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 18, 5, 10),
                      child: Container(
                          width: 140,
                          height: 227,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 40),
                                child: Text(
                                  "Lançamento: " +
                                      _movieResults["release_date"]
                                          .toString()
                                          .substring(0, 4) +
                                      "\n\n" +
                                      "Total Votos: " +
                                      _movieResults["vote_count"].toString() +
                                      "\n\n" +
                                      "Nota " +
                                      _movieResults["vote_average"].toString() +
                                      "\n\n" +
                                      "Idioma: " +
                                      _movieResults["original_language"]
                                          .toString()
                                          .toUpperCase() +
                                      "\n",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 09, 14, 15),
                          child: Image.network(
                              "https://image.tmdb.org/t/p/w185" +
                                  _movieResults["poster_path"]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Container(
                  width: 337,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 7, 7, 15),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Sinopse:  ".toUpperCase() +
                                  _movieResults["overview"],
                              style: TextStyle(fontSize: 20)),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
