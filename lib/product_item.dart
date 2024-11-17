// product_item.dart
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String product;
  final int quantity;
  final bool isUpdated; // Thêm thuộc tính isUpdated
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const ProductItem({
    Key? key,
    required this.product,
    required this.quantity,
    required this.isUpdated,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: isUpdated
            ? Colors.yellow[100]
            : null, // Đổi màu nếu sản phẩm được cập nhật
        child: ListTile(
          title: Text(
            product,
            style: TextStyle(
              fontWeight: isUpdated
                  ? FontWeight.bold
                  : FontWeight.normal, // In đậm nếu được cập nhật
            ),
          ),
          subtitle: Text('Số lượng: $quantity'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAdd,
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onRemove,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
