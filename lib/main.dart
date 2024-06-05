//Kamila Pineda, Kenny Garces

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String baseCurrency = 'COP'; // Moneda de origen: pesos colombianos
  List<String> targetCurrencies = ['USD', 'EUR', 'GBP', 'JPY']; // Monedas de destino
  double amount = 1.0; // Valor inicial

  Map<String, dynamic> exchangeRates = {}; // Tasas de cambio obtenidas de la API

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    final response = await http.get(
      Uri.parse('https://open.er-api.com/v6/latest/$baseCurrency'),
      headers: {'consumer': 'kamila y kenny'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRates = data['rates'];
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount in COP', // Mostrará el valor en pesos colombianos
              ),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: targetCurrencies.length,
                itemBuilder: (context, index) {
                  String targetCurrency = targetCurrencies[index];
                  double exchangeRate = exchangeRates[targetCurrency]?.toDouble() ?? 1.0;
                  double convertedAmount = amount * exchangeRate; // Conversión directa de COP a la moneda de destino
                  return ListTile(
                    title: Text(targetCurrency),
                    trailing: Text(convertedAmount.toStringAsFixed(2)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
