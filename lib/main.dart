import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pokemon.dart';
import 'pokemondetail.dart';

void main() => runApp(
      MaterialApp(
        title: "Pokedex",
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.lightBlueAccent,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue,
            accentColor: Colors.lightBlueAccent),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  List<bool> isSelected = [true];

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bright = MediaQuery.of(context).platformBrightness == Brightness.light;
    isSelected[0] = bright;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        actions: <Widget>[
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                print(isSelected);
                if (index == 0) isSelected[index] = !isSelected[index];
                print(isSelected);
              });
            },
            children: [
              isSelected[0]
                  ? Icon(
                      Icons.brightness_3,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.brightness_6,
                      color: Colors.yellow,
                    )
            ],
          ),
        ],
        title: Text("Pokedex"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[100],
                strokeWidth: 3,
              ),
            )
          : GridView.count(
              crossAxisCount: 3,
              children: pokeHub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeDetail(
                                          pokemon: poke,
                                        )));
                          },
                          child: Hero(
                            tag: poke.img,
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FadeInImage.assetNetwork(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      placeholder: 'assets/placeholder.png',
                                      image: poke.img),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      poke.name,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
