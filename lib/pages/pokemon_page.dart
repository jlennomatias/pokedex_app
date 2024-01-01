import 'package:flutter/material.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';

class PokemonPage extends StatelessWidget {
  final Map _pokeData;

  PokemonPage(this._pokeData);
  
  @override
  Widget build(BuildContext context) {
    final PokemonRepository _pokemonRepository = PokemonRepository();
    _pokemonRepository.url = _pokeData['url'] ?? '';
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_pokeData['name']),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(future: _pokemonRepository.url != '' ? _pokemonRepository.getPokemons() : Future.value(_pokeData), builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return Image.network(snapshot.data?['sprites']['front_shiny']);
                      
                }
              },),
        // child: Image.network(_pokeData['sprites']['front_shiny'][0]),
      ),
    );
  }
}
