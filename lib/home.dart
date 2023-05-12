import 'dart:convert';
import 'package:flutter/material.dart';
import 'api/pokemon.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(child: Text(title),
        ),
        backgroundColor: Colors.red,
      ),
      
      body: FutureBuilder<List<Dados>>(
        future: dados(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PokemonsList(pokemons: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PokemonsList extends StatelessWidget {
  const PokemonsList({Key? key, required this.pokemons}) : super(key: key);

  final List<Dados> pokemons;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return Container(
          child: Container(
            height: 150,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(60.0),
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
            child: ListTile(
              title: Image.network("${pokemons[index].img}", height: 200),
              subtitle: Column(
                children: [
                  Text("${pokemons[index].name}",style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute<Widget>(builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Detalhe do Pokemon'), backgroundColor: Colors.red,),
                        body: Hero(
                          tag: 'Detalhar Pokemon',
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                  color: pokemons[index].type == "Grass"
                      ? Colors.greenAccent
                      : pokemons[index].type == "Fire"
                          ? Colors.redAccent
                          : pokemons[index].type == "Water"
                              ? Colors.blue
                              : pokemons[index].type == "Poison"
                                  ? Colors.deepPurpleAccent
                                  : pokemons[index].type == "Electric"
                                      ? Colors.amber
                                      : pokemons[index].type == "Rock"
                                          ? Colors.grey
                                          : pokemons[index].type == "Ground"
                                              ? Colors.brown
                                              : pokemons[index].type ==
                                                      "Psychic"
                                                  ? Colors.indigo
                                                  : pokemons[index].type ==
                                                          "Fighting"
                                                      ? Colors.orange
                                                      : pokemons[index].type ==
                                                              "Bug"
                                                          ? Colors
                                                              .lightGreenAccent
                                                          : pokemons[index]
                                                                      .type ==
                                                                  "Ghost"
                                                              ? Colors
                                                                  .deepPurple
                                                              : pokemons[index]
                                                                          .type ==
                                                                      "Normal"
                                                                  ? Colors
                                                                      .black26
                                                                  : Colors.pink,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: Image.network(
                                      "${pokemons[index].img}", alignment: Alignment.center, 
                                    ),
                                  ),
                                  const SizedBox(height: 100),
                                  Container(
                                    width: 500,
                                    decoration: BoxDecoration(  
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10), 
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)
                                        ),
                                    color: Color.fromARGB(255, 158, 158, 158),
                                    border: Border.all(
                                      color: Colors.black45,
                                      width: 2.0,
                                    ),),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Nome do Pokemon: ${pokemons[index].name}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text("N°: ${pokemons[index].num}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),),
                                        Text("Tipo: ${pokemons[index].type}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),),
                                        Text("Peso: ${pokemons[index].weight}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),),
                                        Text("Altura: ${pokemons[index].height}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),),
                                        Text("Fraco Contra: ${pokemons[index].weaknesses}",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          ),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),                        
                        ),
                      );
                    }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
