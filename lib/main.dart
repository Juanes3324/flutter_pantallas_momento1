import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ImcApp());
}

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0867F9),
          primary: const Color(0xFF0867F9),
        ),
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 24),
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Calculadora IMC',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF202124),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Calcula tu índice de masa corporal con tu altura '
                          'y tu peso, y conoce en qué rango estás',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF85858D),
                            fontSize: 10,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CalculatorScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0867F9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Comenzar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double? _bmi;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text.replaceAll(',', '.'));
    final heightInMeters =
        double.parse(_heightController.text.replaceAll(',', '.')) / 100;

    setState(() {
      _bmi = weight / (heightInMeters * heightInMeters);
    });
  }

  String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  String? _validateNumber(String? value, {required double minimum}) {
    if (value == null || value.trim().isEmpty) {
      return 'Completa este campo';
    }
    final number = double.tryParse(value.trim().replaceAll(',', '.'));
    if (number == null || !number.isFinite || number < minimum) {
      return 'Ingresa un valor válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Conoce tu índice de masa corporal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202124),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tus datos para calcular tu IMC.',
                  style: TextStyle(color: Color(0xFF85858D)),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateNumber(value, minimum: 1),
                  onChanged: (_) {
                    if (_bmi != null) setState(() => _bmi = null);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Altura',
                    suffixText: 'cm',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateNumber(value, minimum: 30),
                  onChanged: (_) {
                    if (_bmi != null) setState(() => _bmi = null);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _calculateBmi,
                    child: const Text('Calcular IMC'),
                  ),
                ),
                if (_bmi != null) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Tu resultado',
                          style: TextStyle(
                            color: Color(0xFF666A73),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _bmi!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFF0867F9),
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _bmiCategory(_bmi!),
                          style: const TextStyle(
                            color: Color(0xFF202124),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
