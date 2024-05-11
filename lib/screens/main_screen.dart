import 'package:countries_app/Services/CountryService.dart';
import 'package:countries_app/model_class/model_class.dart';
import 'package:countries_app/screens/CountryDetailsScreen.dart';
import 'package:flutter/material.dart';



class CountryListScreen extends StatefulWidget {
  final String continent;

  CountryListScreen({required this.continent});

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final CountryService _countryService = CountryService();
  List<Country>? _countries;
  late List<Country> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _filteredCountries = [];
    _loadCountriesByContinent();
  }

  Future<void> _loadCountriesByContinent() async {
    List<Country>? countries = await _countryService.getAllCountries();
    setState(() {
      _countries = _countryService.getCountriesByContinent(countries!, widget.continent);
      _filteredCountries = _countries!;
    });
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries!.where((country) {
        final name = country.name!.common!.toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries in ${widget.continent}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? selected = await showSearch<String>(
                context: context,
                delegate: CountrySearchDelegate(_countries!),
              );
              if (selected != null && selected.isNotEmpty) {
                _filterCountries(selected);
              }
            },
          ),
        ],
      ),
      body: _filteredCountries != null
          ? ListView.builder(
        itemCount: _filteredCountries!.length,
        itemBuilder: (context, index) {
          return Container(

            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(

              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(_filteredCountries![index].name!.common ?? '',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.navigate_next),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Official Name: ',style: TextStyle(fontSize: 11,color: Colors.black,)),
                  Text(_filteredCountries![index].name!.official ?? '',style: TextStyle(fontSize: 10,color: Colors.teal),),
                ],
              ),
              onTap: () {
                // Navigate to next page passing the selected country details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryDetailsScreen(country: _filteredCountries![index]),
                  ),
                );
              },
            ),
          );
        },
      )

          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CountrySearchDelegate extends SearchDelegate<String> {
  final List<Country> countries;

  CountrySearchDelegate(this.countries);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Country> filteredCountries = countries.where((country) {
      final name = country.name!.common!.toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredCountries.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredCountries[index].name!.common ?? ''),
          subtitle: Text(filteredCountries[index].name!.official ?? ''),
          onTap: () {
            close(context, filteredCountries[index].name!.common ?? '');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Country> suggestionList = countries.where((country) {
      final name = country.name!.common!.toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].name!.common ?? ''),
          subtitle: Text(suggestionList[index].name!.official ?? ''),
          onTap: () {
            close(context, suggestionList[index].name!.common ?? '');
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
     // primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.textTheme,
    );
  }
}