
import 'package:countries_app/functions/fetchContinents.dart';

import '../model_class/model_class.dart';

class CountryService {
  final _api = CountryApi();

  Future<List<Country>?> getAllCountries() async => _api.getAllCountries();

  List<Country>? getCountriesByContinent(List<Country> countries, String continent) {
    return countries.where((country) => country.continents!.contains(continent)).toList();
  }
}