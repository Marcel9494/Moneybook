import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  double? exchangeRate;

  Future<void> fetchExchangeRate() async {
    final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?base=EUR'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        exchangeRate = data['rates']['USD']; // EUR → USD
      });
    } else {
      throw Exception('Fehler beim Abrufen der Wechselkurse.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO hier weitermachen und Seite weiter designen und implementieren
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wechselkurse'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('🇪🇺', style: TextStyle(fontSize: 28.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Euro: 1,00 €', style: TextStyle(fontSize: 15.0)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Aktuelle Wechselkurse:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      'US',
                      width: 28.0,
                      height: 28.0,
                      shape: const Circle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                      child: Text('Dollar: ${exchangeRate?.toStringAsFixed(2)} \$', style: TextStyle(fontSize: 15.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
