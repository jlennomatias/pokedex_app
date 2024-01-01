import 'package:pokedex_app/pages/pokemon_page.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokemonRepository _pokemonRepository = PokemonRepository();

  @override
  void initState() {
    super.initState();
    _pokemonRepository.getPokemons().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Pokemon'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'search'),
              onSubmitted: (value) {
                setState(() {
                  _pokemonRepository.search = value;
                });
              },
            ),
            Expanded(
                child: FutureBuilder(
              future: _pokemonRepository.getPokemons(),
              builder: (context, snapshot) {
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
                      return _createPokemonTable(context, snapshot);
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  int _getCount(List data) {
    if (_pokemonRepository.search == null) {
      return data.length + 1;
    } else {
      return data.length;
    }
  }

  Widget _createPokemonTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snapshot.data['results'] != null
          ? _getCount(snapshot.data['results'])
          : _getCount([snapshot.data]),
      itemBuilder: (context, index) {
        if (_pokemonRepository.search != null ||
            index < snapshot.data?['results']?.length) {
          return Container(
            color: Colors.amber,
            child: GestureDetector(
              child: Text(snapshot.data?['results']?[index]?['name'] ??
                  snapshot.data?['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonPage(snapshot.data?['results']
                            ?[index] ?? 
                        snapshot.data),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pokemonRepository.url = snapshot.data["next"];
                  _pokemonRepository.getPokemons();
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
