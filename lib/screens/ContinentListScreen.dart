import 'package:countries_app/Services/CountryService.dart';
import 'package:countries_app/model_class/model_class.dart';
import 'package:countries_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
class ContinentListScreen extends StatefulWidget {
  @override
  _ContinentListScreenState createState() => _ContinentListScreenState();
}

class _ContinentListScreenState extends State<ContinentListScreen> {
  final CountryService _countryService = CountryService();
  List<String>? _continents;

  @override
  void initState() {
    super.initState();
    _loadContinents();
  }

  Future<void> _loadContinents() async {
    List<Country>? countries = await _countryService.getAllCountries();
    Set<String> continentsSet = Set();
    countries?.forEach((country) {
      continentsSet.addAll(country.continents!);
    });
    setState(() {
      _continents = continentsSet.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continents',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 25) ),
      ),
      body: _continents != null
          ? ListView.builder(
        itemCount: _continents!.length,
        itemBuilder: (context, index) {
          return Container(

            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
            //  color: Colors.blue.shade100,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(_continents![index],style: TextStyle(color: Colors.blueAccent.shade700,fontWeight: FontWeight.bold,fontSize: 18)),
              trailing: Icon(Icons.navigate_next,color: Colors.blueAccent.shade700),
              onTap: () {
                // Navigate to next page passing the selected continent
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryListScreen(continent: _continents![index]),
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
