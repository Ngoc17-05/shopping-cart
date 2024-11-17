// product_app.dart
import 'package:flutter/material.dart';

import 'product_item.dart';
import 'state_manager.dart';

class ProductApp extends StatelessWidget {
  final StateContainer<Map<String, int>> cartState =
      StateContainer<Map<String, int>>({});

  // Tập hợp các sản phẩm đang được cập nhật
  final Set<String> updatedProducts = Set();

  void addItem(String product) {
    final currentCart = {...cartState.state};
    currentCart[product] = (currentCart[product] ?? 0) + 1;
    cartState.setState(currentCart);
  }

  void removeItem(String product) {
    final currentCart = {...cartState.state};
    if (currentCart[product] != null) {
      currentCart[product] = currentCart[product]! - 1;
      if (currentCart[product]! <= 0) {
        currentCart.remove(product);
      }
      cartState.setState(currentCart);
    }
  }

  // Cập nhật bất đồng bộ cho tất cả các sản phẩm trong giỏ hàng
  Future<void> updateItemQuantityAsync(List<String> products) async {
    // Giả lập tác vụ bất đồng bộ (ví dụ API call)
    await Future.delayed(Duration(seconds: 2));

    final currentCart = {...cartState.state};

    // Cập nhật số lượng của các sản phẩm được chỉ định trong danh sách
    for (String product in products) {
      currentCart[product] = (currentCart[product] ?? 0) + 0;
    }

    // Cập nhật lại state
    cartState.setStateAsync(Future.value(currentCart));

    // Đánh dấu sản phẩm đã được cập nhật
    updatedProducts.addAll(products);
  }

  void deleteItem(String product) {
    final currentCart = {...cartState.state};
    if (currentCart.containsKey(product)) {
      currentCart.remove(product);
      cartState.setState(currentCart);
    }
  }

  void resetCart() {
    cartState.resetState();
    updatedProducts.clear(); // Đặt lại danh sách sản phẩm đã cập nhật
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sản phẩm')),
      body: Column(
        children: [
          Expanded(
            child: Observer<Map<String, int>>(
              stateContainer: cartState,
              builder: (context, cart) {
                if (cart.isEmpty) {
                  return const Center(child: Text('Giỏ hàng trống.'));
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: cart.entries.map((entry) {
                    bool isUpdated = updatedProducts.contains(entry.key);

                    return ProductItem(
                      product: entry.key,
                      quantity: entry.value,
                      isUpdated: isUpdated,
                      onAdd: () => addItem(entry.key),
                      onRemove: () => removeItem(entry.key),
                      onDelete: () => deleteItem(entry.key),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => addItem('Sản phẩm A'),
                      child: const Text('Sản phẩm A'),
                    ),
                    ElevatedButton(
                      onPressed: () => addItem('Sản phẩm B'),
                      child: const Text('Sản phẩm B'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: resetCart,
                      child: const Text('    Đặt lại    '),
                    ),
                    ElevatedButton(
                      // Cập nhật số lượng của cả A và B
                      onPressed: () =>
                          updateItemQuantityAsync(['Sản phẩm A', 'Sản phẩm B']),
                      child: const Text('   Cập nhật    '),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
