import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> args) {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lidando com Varios Futures'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchProductInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum dado disponivel'),
            );
          } else {
            final productInfo = snapshot.data!;
            return ListView.builder(
              itemCount: productInfo.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(productInfo[index]),
              ),);
          }
        },
      ),
    );
  }

// Função que simula chamadas assíncronas a diferentes APIs para obter informações sobre produtos
  Future<List<String>> fetchProductInfo() async {
    const String apiKey = 'REMOVED FOR PROTECTION';
    String apiUrl ='https://openexchangerates.org/api/latest.json?app_id=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;

      // Converte as taxas em uma lista de strings
      List<String> productInfo = [];
      rates.forEach((key, value) {
        productInfo.add('$key: $value');
      });

      return productInfo;
    } else {
      throw Exception('Erro ao carregar dados da API');
    }
  }

// Função que simula uma chamada assíncrona a uma API para obter informações sobre um produto.
  Future<String> getProductInfoFromApi(String productId) async {
    await Future.delayed(Duration(seconds: 2));
    return 'Informacoes do produto $productId';
  }
}
