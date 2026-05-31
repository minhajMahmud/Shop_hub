import 'package:flutter/material.dart';

class AdvancedFilterScreen extends StatefulWidget {
  final Function(
    double minPrice,
    double maxPrice,
    List<String> brands,
    List<double> ratings,
  )
  onFilterApply;

  const AdvancedFilterScreen({super.key, required this.onFilterApply});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  RangeValues _priceRange = const RangeValues(0, 500);
  final List<String> allBrands = [
    'TechPro',
    'StyleHub',
    'HydroFit',
    'NaturalGlow',
    'LightWorks',
    'GameZone',
    'DisplayMax',
  ];
  Set<String> _selectedBrands = {};
  Set<double> _selectedRatings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Filters')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range
            Text(
              'Price Range',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 500,
              divisions: 50,
              labels: RangeLabels(
                '\$${_priceRange.start.toStringAsFixed(0)}',
                '\$${_priceRange.end.toStringAsFixed(0)}',
              ),
              onChanged: (RangeValues values) {
                setState(() => _priceRange = values);
              },
              activeColor: Colors.deepOrange,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_priceRange.start.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_priceRange.end.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Brands
            Text(
              'Brands',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allBrands.map((brand) {
                final isSelected = _selectedBrands.contains(brand);
                return FilterChip(
                  label: Text(brand),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBrands.add(brand);
                      } else {
                        _selectedBrands.remove(brand);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Ratings
            Text(
              'Ratings',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: [4.0, 3.0, 2.0, 1.0].map((rating) {
                final isSelected = _selectedRatings.contains(rating);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedRatings.remove(rating);
                      } else {
                        _selectedRatings.add(rating);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepOrange.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepOrange
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                size: 16,
                                color: index < rating.toInt()
                                    ? Colors.amber[700]
                                    : Colors.grey[300],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$rating & up',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.deepOrange),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(0, 500);
                        _selectedBrands.clear();
                        _selectedRatings.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterApply(
                        _priceRange.start,
                        _priceRange.end,
                        _selectedBrands.toList(),
                        _selectedRatings.toList(),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filters applied')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
