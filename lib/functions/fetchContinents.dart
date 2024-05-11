import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model_class/model_class.dart';
class CountryApi {
  Future<List<Country>?> getAllCountries() async {
    var client = http.Client();

    var uri = Uri.parse('https://restcountries.com/v3.1/all');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return countryFromJson(response.body);
    }
    return null;
  }
}

