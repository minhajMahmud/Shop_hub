import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 8),
            _CategoryButton(
              label: 'All Products',
              icon: '',
              isSelected: selectedCategory == 'all',
              onTap: () => onSelectCategory('all'),
            ),
            ...categories.map((category) {
              return _CategoryButton(
                label: category['name'],
                icon: category['icon'],
                isSelected: selectedCategory == category['id'],
                onTap: () => onSelectCategory(category['id']),
              );
            }).toList(),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon.isNotEmpty) ...[Text(icon), const SizedBox(width: 4)],
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: Colors.deepOrange,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? Colors.deepOrange : Colors.grey[300]!,
        ),
      ),
    );
  }
}
