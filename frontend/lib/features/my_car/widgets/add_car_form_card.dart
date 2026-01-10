import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';

class AddCarFormCard extends StatefulWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const AddCarFormCard({super.key, this.onSave, this.onCancel});

  @override
  State<AddCarFormCard> createState() => _AddCarFormCardState();
}

class _AddCarFormCardState extends State<AddCarFormCard> {
  // Sample car makes database
  final List<String> _carMakes = [
    'Toyota',
    'Honda',
    'Ford',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Volkswagen',
    'Nissan',
    'Hyundai',
    'Chevrolet',
  ];

  // Sample car models database (mapped by make)
  final Map<String, List<String>> _carModels = {
    'Toyota': [
      'Corolla',
      'Camry',
      'RAV4',
      'Highlander',
      'Prius',
      'Tacoma',
      'Tundra',
      'Sienna',
      '4Runner',
      'Avalon',
    ],
    'Honda': [
      'Civic',
      'Accord',
      'CR-V',
      'Pilot',
      'Odyssey',
      'Fit',
      'HR-V',
      'Passport',
      'Ridgeline',
      'Insight',
    ],
    'Ford': [
      'F-150',
      'Escape',
      'Explorer',
      'Mustang',
      'Edge',
      'Expedition',
      'Ranger',
      'Fusion',
      'Bronco',
      'Maverick',
    ],
    'BMW': [
      '3 Series',
      '5 Series',
      'X3',
      'X5',
      'X1',
      '7 Series',
      'X7',
      '4 Series',
      'iX',
      'Z4',
    ],
    'Mercedes-Benz': [
      'C-Class',
      'E-Class',
      'S-Class',
      'GLE',
      'GLC',
      'GLS',
      'A-Class',
      'G-Class',
      'CLA',
      'AMG GT',
    ],
    'Audi': ['A4', 'A6', 'Q5', 'Q7', 'Q3', 'A3', 'e-tron', 'TT', 'A8', 'Q8'],
    'Volkswagen': [
      'Jetta',
      'Passat',
      'Tiguan',
      'Atlas',
      'Golf',
      'Arteon',
      'ID.4',
      'Taos',
      'Atlas Cross Sport',
      'Beetle',
    ],
    'Nissan': [
      'Altima',
      'Sentra',
      'Rogue',
      'Pathfinder',
      'Frontier',
      'Titan',
      'Murano',
      'Maxima',
      'Armada',
      'Kicks',
    ],
    'Hyundai': [
      'Elantra',
      'Sonata',
      'Tucson',
      'Santa Fe',
      'Palisade',
      'Kona',
      'Venue',
      'Ioniq',
      'Genesis',
      'Veloster',
    ],
    'Chevrolet': [
      'Silverado',
      'Equinox',
      'Tahoe',
      'Malibu',
      'Traverse',
      'Cruze',
      'Suburban',
      'Camaro',
      'Corvette',
      'Bolt',
    ],
  };

  String? _selectedMake = 'Toyota';
  String? _selectedModel = 'Corolla';
  final TextEditingController _yearController = TextEditingController(
    text: '2020',
  );
  final TextEditingController _licensePlateController = TextEditingController(
    text: 'ABC1234',
  );

  @override
  void dispose() {
    _yearController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form fields
          _buildMakeDropdown(),
          const SizedBox(height: 16),
          _buildModelDropdown(),
          const SizedBox(height: 16),
          _buildYearField(),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'License Plate',
            controller: _licensePlateController,
          ),
          const SizedBox(height: 32),
          // SAVE button
          SizedBox(
            height: MyCarTheme.buttonHeight,
            child: ElevatedButton(
              onPressed: widget.onSave ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MyCarTheme.accentBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MyCarTheme.buttonRadius),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SAVE',
                style: TextStyle(
                  fontSize: MyCarTheme.buttonFontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Make',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedMake,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            menuMaxHeight: 300,
            isExpanded: true,
            items:
                _carMakes.map((make) {
                  return DropdownMenuItem(value: make, child: Text(make));
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMake = value;
                  // Reset model to first model of selected make
                  _selectedModel = _carModels[value]?.first;
                });
              }
            },
            style: const TextStyle(fontSize: 16, color: Color(0xFF212121)),
          ),
        ),
      ],
    );
  }

  Widget _buildModelDropdown() {
    final availableModels =
        _selectedMake != null && _carModels.containsKey(_selectedMake)
            ? _carModels[_selectedMake]!
            : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Model',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedModel,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            menuMaxHeight: 300,
            isExpanded: true,
            items:
                availableModels.map((model) {
                  return DropdownMenuItem(value: model, child: Text(model));
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedModel = value;
                });
              }
            },
            style: const TextStyle(fontSize: 16, color: Color(0xFF212121)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16, color: Color(0xFF212121)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Year',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: '2020',
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            menuMaxHeight: 300,
            isExpanded: true,
            items: List.generate(30, (index) {
              final year = DateTime.now().year - index;
              return DropdownMenuItem(
                value: year.toString(),
                child: Text(year.toString()),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _yearController.text = value;
                });
              }
            },
            style: const TextStyle(fontSize: 16, color: Color(0xFF212121)),
          ),
        ),
      ],
    );
  }
}
