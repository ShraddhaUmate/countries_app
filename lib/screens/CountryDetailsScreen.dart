import 'package:countries_app/model_class/model_class.dart';
import 'package:flutter/material.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  CountryDetailsScreen({required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name!.common ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(

                  child: _buildFlagWidget(country.flags)),
              SizedBox(height: 10,),

              Text('Capital: ${country.capital!.join(", ")}'),
            //  Text('population: ${country.population!.join(", ")}'),
              SizedBox(height: 10,),
              Text('Continents: ${country.continents!.join(", ")}'),

              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlagWidget(Flags? flags) {
    if (flags != null && flags.png != null) {
      return Container(

        child: Image.network(
          
          flags.png!,
          width: 400,
          height: 200,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SizedBox(); // Return an empty container if flag data is not available
    }
  }
}
