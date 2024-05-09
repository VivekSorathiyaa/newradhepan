import '../app.dart';

class GlobalSingleton {
  static final GlobalSingleton globalSingleton = GlobalSingleton._internal();

  List<String> countryGlobalList = [];
  // String globalCountryName = dataStorage.read('country');
  // String globalCurrencyName = dataStorage.read('currency') ?? "USD";

  void addCountry(String item) {
    countryGlobalList.clear();
    countryGlobalList.add(item);
  }

 String v() {
    return dataStorage.read('country');
  }

  factory GlobalSingleton() {
    return globalSingleton;
  }

  GlobalSingleton._internal();
  String? deviceToken;
}
