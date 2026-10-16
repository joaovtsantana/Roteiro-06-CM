
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String formatPrice(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> confirmRemoval(
    BuildContext context,
    CartProvider cart,
    int index,
  ) async {
    final product = cart.products[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover produto'),
          content: Text(
            'Deseja remover ${product.nome} do carrinho?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cart.removeProduct(index);
    }
  }

  Future<void> confirmClearCart(
    BuildContext context,
    CartProvider cart,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Limpar carrinho'),
          content: const Text(
            'Deseja remover todos os produtos?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cart.clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Carrinho (${cart.totalItems})'),
          ),
          body: Column(
            children: [
              Expanded(
                child: cart.products.isEmpty
                    ? const Center(
                        child: Text('Seu carrinho está vazio.'),
                      )
                    : ListView.builder(
                        itemCount: cart.products.length,
                        itemBuilder: (context, index) {
                          final product = cart.products[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.shopping_bag,
                            ),
                            title: Text(product.nome),
                            subtitle: Text(
                              formatPrice(product.preco),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                confirmRemoval(
                                  context,
                                  cart,
                                  index,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total de itens: ${cart.totalItems}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${formatPrice(cart.totalPrice)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: cart.products.isEmpty
                          ? null
                          : () => confirmClearCart(context, cart),
                      child: const Text('Limpar carrinho'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
