import 'package:flutter/material.dart';

class CarbonEmissionPage extends StatefulWidget {
  const CarbonEmissionPage({super.key});

  @override
  _CarbonEmissionPageState createState() => _CarbonEmissionPageState();
}

class _CarbonEmissionPageState extends State<CarbonEmissionPage> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _fuelConsumptionController =
      TextEditingController();
  final TextEditingController _passengerCountController =
      TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _tripFrequencyController =
      TextEditingController();
  String _selectedVehicle = 'Truck';
  double _emissionResult = 0.0;

  final Map<String, double> emissionFactors = {
    'Bus': 0.15,
    'Truck': 0.25,
    'Car': 0.12,
    'Bike': 0.05,
  };

  void _calculateEmission() {
    double distance = double.tryParse(_distanceController.text) ?? 0.0;
    double fuelConsumption =
        double.tryParse(_fuelConsumptionController.text) ?? 1.0;
    double passengerCount =
        double.tryParse(_passengerCountController.text) ?? 1.0;
    double factor = emissionFactors[_selectedVehicle] ?? 0.0;

    setState(() {
      _emissionResult = (distance * factor) / passengerCount;
    });
  }

  void _resetFields() {
    setState(() {
      _distanceController.clear();
      _fuelConsumptionController.clear();
      _passengerCountController.clear();
      _fuelTypeController.clear();
      _tripFrequencyController.clear();
      _selectedVehicle = 'Truck';
      _emissionResult = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Emission Estimator'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField('Enter Distance Travelled (in km):',
                _distanceController, 'e.g., 100'),
            buildInputField('Enter Fuel Consumption (liters per km):',
                _fuelConsumptionController, 'e.g., 0.2'),
            buildInputField('Enter Number of Passengers:',
                _passengerCountController, 'e.g., 4'),
            buildInputField('Enter Fuel Type (Petrol/Diesel/Electric):',
                _fuelTypeController, 'e.g., Petrol'),
            buildInputField('Enter Trip Frequency (per week):',
                _tripFrequencyController, 'e.g., 5'),
            buildDropdownField(),
            const SizedBox(height: 30),
            buildActionButtons(),
            const SizedBox(height: 20),
            if (_emissionResult > 0) buildResultBox(),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Vehicle Type:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: DropdownButton<String>(
            value: _selectedVehicle,
            isExpanded: true,
            underline: Container(),
            items: ['Bus', 'Truck', 'Car', 'Bike']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedVehicle = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _calculateEmission,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: Colors.green.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Calculate',
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _resetFields,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: Colors.red.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Reset',
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildResultBox() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Estimated Carbon Emission: ${_emissionResult.toStringAsFixed(2)} kg CO2',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
    );
  }
}
