import 'dart:convert';
import 'package:http/http.dart' as http;


class Pokemons {
  List<Dados>? dados;

  Pokemons({this.dados});

  Pokemons.fromJson(Map <String, dynamic> json) {
    if (json['dados'] != null) {
      dados = <Dados>[];
      json['dados'].forEach((v) {
        dados!.add(new Dados.fromJson(v));
      });
    }
  }

  Map <String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dados != null) {
      data['dados'] = this.dados!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dados {
  int? id;
  String? name;
  String? img;
  String? num;
  String? type;
  String? height;
  String? weight;
  List<String>? weaknesses;

  Dados({
    this.id,
    this.name,
    this.img,
    this.num,
    this.type,
    this.height,
    this.weight,
    this.weaknesses,
  });

  Dados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    num = json['num'];
    type = json['type'][0].toString();
    height = json['height'];
    weight = json['weight'];
    weaknesses = json['weaknesses'].cast<String>();
  }

  Map <String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['num'] = this.num;
    data['type'] = this.type;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['weaknesses'] = this.weaknesses;
    return data;
  }
}

Future <List<Dados>> dados() async {
  final List<dynamic> result = await fetchUsers();
  //print(result);
  List<Dados> pokemons;
  pokemons = (result).map((pokemon) => Dados.fromJson(pokemon)).toList();
  return pokemons;
}

const String url =
    "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
    
Future <List<dynamic>> fetchUsers() async {
  var result = await http.get(Uri.parse(url));
  return jsonDecode(result.body)['pokemon'];
}