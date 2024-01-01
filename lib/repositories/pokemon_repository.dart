import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PokemonRepository {

  String? search; //pesquisa pode ser null
  
  String uriOrigem = 'https://pokeapi.co/api/v2/pokemon';
  String url = 'https://pokeapi.co/api/v2/pokemon';
  
  Future<Map> getPokemons() async {

    http.Response response;

    if (search == null || search == '') {
      search = null;
      response = await http.get(Uri.parse('$url?limit=7'));
      return json.decode(response.body);
    } else {
      response = await http.get(Uri.parse('$uriOrigem/$search'));
      return json.decode(response.body);
    }
  }

  Future<Map> getPokemonsImages() async {

    http.Response response;

    if (search == null || search == '') {
      search = null;
      response = await http.get(Uri.parse('$url?limit=7'));
      return json.decode(response.body);
    } else {
      response = await http.get(Uri.parse('$uriOrigem/$search'));
      return json.decode(response.body);
    }
  }
}