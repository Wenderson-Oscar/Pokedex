import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonAbility> abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    this.height = 0,
    this.weight = 0,
    this.abilities = const [],
  });

  factory Pokemon.fromPokeApi(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((type) => (type['type']['name'] as String).toLowerCase())
        .toList();
    
    final abilities = (json['abilities'] as List)
        .map((ability) => PokemonAbility.fromJson(ability['ability']))
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ??
                json['sprites']['front_default'] ??
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${json['id']}.png',
      types: types,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      abilities: abilities,
    );
  }

  // Fallback constructor for simple data
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['img'] ?? '',
      types: List<String>.from(json['type'] ?? []),
    );
  }
}

class PokemonAbility {
  final String name;
  final String url;

  PokemonAbility({required this.name, required this.url});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class PokemonApi {
  static const String pokeApiBase = 'https://pokeapi.co/api/v2/pokemon';
  static const String fallbackUrl = 'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

  static Future<List<Pokemon>> fetchPokemons() async {
    try {
      // Primeiro tenta buscar da PokeAPI oficial (mais confiável para imagens)
      log('Fetching pokemons from PokeAPI...');
      return await _fetchFromPokeApi();
    } catch (e) {
      log('PokeAPI failed, trying fallback: $e');
      // Se falhar, usa o fallback
      try {
        return await _fetchFromFallback();
      } catch (fallbackError) {
        log('Both APIs failed: $fallbackError');
        throw Exception('Failed to fetch Pokemon data from all sources');
      }
    }
  }

  static Future<List<Pokemon>> _fetchFromPokeApi() async {
    List<Pokemon> pokemons = [];
    
    // Busca os primeiros 150 Pokémon (Geração 1 completa)
    for (int i = 1; i <= 150; i++) {
      try {
        final response = await http.get(
          Uri.parse('$pokeApiBase/$i'),
          headers: {
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));
        
        if (response.statusCode == 200) {
          final pokemonData = json.decode(response.body);
          final pokemon = Pokemon.fromPokeApi(pokemonData);
          pokemons.add(pokemon);
          
          // Log apenas alguns para não poluir o console
          if (i == 1 || i == 50 || i == 100 || i == 150) {
            log('Pokemon #$i from PokeAPI: ${pokemon.name}, Image: ${pokemon.imageUrl}');
          }
        }
      } catch (e) {
        log('Failed to fetch Pokemon $i: $e');
        // Continua com o próximo se um falhar
        continue;
      }
    }
    
    if (pokemons.isEmpty) {
      throw Exception('No Pokemon data could be fetched from PokeAPI');
    }
    
    log('Loaded ${pokemons.length} pokemons from PokeAPI');
    return pokemons;
  }

  static Future<List<Pokemon>> _fetchFromFallback() async {
    log('Fetching pokemons from fallback: $fallbackUrl');
    final response = await http.get(Uri.parse(fallbackUrl));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemonList = (data['pokemon'] as List)
          .map((pokemonJson) => Pokemon.fromJson(pokemonJson))
          .toList();
      
      log('Loaded ${pokemonList.length} pokemons from fallback API');
      return pokemonList;
    } else {
      throw Exception('Failed to load pokemons from fallback. Status code: ${response.statusCode}');
    }
  }
}


// Manter compatibilidade com código existente
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

  // Converter Pokemon para Dados para compatibilidade
  factory Dados.fromPokemon(Pokemon pokemon) {
    return Dados(
      id: pokemon.id,
      name: pokemon.name,
      img: pokemon.imageUrl,
      num: pokemon.id.toString().padLeft(3, '0'),
      type: pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal',
      height: '${pokemon.height / 10.0} m',
      weight: '${pokemon.weight / 10.0} kg',
      weaknesses: [],
    );
  }

  Dados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    num = json['num'];
    type = json['type'] is List ? json['type'][0].toString() : json['type'];
    height = json['height'];
    weight = json['weight'];
    weaknesses = json['weaknesses']?.cast<String>() ?? [];
  }

  Map <String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['num'] = num;
    data['type'] = type;
    data['height'] = height;
    data['weight'] = weight;
    data['weaknesses'] = weaknesses;
    return data;
  }
}

Future <List<Dados>> dados() async {
  try {
    final List<Pokemon> pokemonList = await PokemonApi.fetchPokemons();
    log('Loaded ${pokemonList.length} pokemons from API');
    
    List<Dados> pokemons = pokemonList
        .map((pokemon) => Dados.fromPokemon(pokemon))
        .toList();
    
    // Debug: print first pokemon data
    if (pokemons.isNotEmpty) {
      log('First Pokemon: ${pokemons[0].name}, Image: ${pokemons[0].img}');
    }
    
    return pokemons;
  } catch (e) {
    log('Error loading pokemon data: $e');
    return [];
  }
}