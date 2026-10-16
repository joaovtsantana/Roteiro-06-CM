
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  static final List<Product> storeProducts = [
    Product(nome: 'Arroz', preco: 5.00),
    Product(nome: 'Feijão', preco: 7.50),
    Product(nome: 'Macarrão', preco: 4.25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: Text('${cart.totalItems}'),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: storeProducts.length,
        itemBuilder: (context, index) {
          final product = storeProducts[index];

          return ListTile(
            title: Text(product.nome),
            subtitle: Text(
              'R\$ ${product.preco.toStringAsFixed(2).replaceAll('.', ',')}',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addProduct(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.nome} adicionado ao carrinho',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Adicionar'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CartScreen(),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Carrinho'),
      ),
    );
  }
}
