// marketplace_filter.dart
import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class MarketplaceFilter extends StatelessWidget {
  final String selectedCategory;
  final String selectedStatus;
  final Function(String) onCategoryChanged;
  final Function(String) onStatusChanged;

  MarketplaceFilter({
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: selectedCategory,
          items: [
            DropdownMenuItem(value: 'all', child: Text(S.of(context).all)),
            DropdownMenuItem(value: 'バイク', child: Text('バイク')),
            DropdownMenuItem(value: '自転車', child: Text('自転車')),
            DropdownMenuItem(value: 'その他', child: Text('その他')),
          ],
          onChanged: (category) => onCategoryChanged(category!),
        ),
        DropdownButton<String>(
          value: selectedStatus,
          items: [
            DropdownMenuItem(value: 'all', child: Text(S.of(context).all)),
            DropdownMenuItem(value: 'available', child: Text(S.of(context).onSale)),
            DropdownMenuItem(value: 'sold', child: Text(S.of(context).soldOut)),
          ],
          onChanged: (status) => onStatusChanged(status!),
        ),
      ],
    );
  }
}
