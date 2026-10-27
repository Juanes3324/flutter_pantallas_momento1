import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ImcApp());
}

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  static const blue = Color(0xFF0867F9);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
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
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
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
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DataScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: ImcApp.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
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

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController(text: '65');
  final _ageController = TextEditingController(text: '25');
  double _height = 170;
  String _sex = 'Hombre';

  @override
  void dispose() {
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _validateNumber(
    String? value, {
    required double minimum,
    required double maximum,
  }) {
    final number = double.tryParse(value?.trim().replaceAll(',', '.') ?? '');
    if (number == null ||
        !number.isFinite ||
        number < minimum ||
        number > maximum) {
      return 'Ingresa un valor válido';
    }
    return null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final weight =
        double.parse(_weightController.text.trim().replaceAll(',', '.'));
    final age = int.parse(_ageController.text.trim());
    final bmi = weight / (_height / 100 * (_height / 100));

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          bmi: bmi,
          weight: weight,
          height: _height.round(),
          age: age,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Tus datos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF202124),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.18),
                    const Text(
                      'Sexo',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF44464C)),
                    ),
                    const SizedBox(height: 18),
                    _SexSelector(
                      selected: _sex,
                      onSelected: (sex) => setState(() => _sex = sex),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Altura',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF44464C),
                          ),
                        ),
                        Text(
                          '${_height.round()} cm',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        min: 100,
                        max: 220,
                        divisions: 120,
                        value: _height,
                        onChanged: (value) => setState(() => _height = value),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _NumberField(
                            controller: _weightController,
                            label: 'Peso (kg)',
                            validator: (value) => _validateNumber(
                              value,
                              minimum: 1,
                              maximum: 500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _NumberField(
                            controller: _ageController,
                            label: 'Edad (años)',
                            allowDecimal: false,
                            validator: (value) => _validateNumber(
                              value,
                              minimum: 1,
                              maximum: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.16),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _calculate,
                        style: FilledButton.styleFrom(
                          backgroundColor: ImcApp.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Calcular IMC'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SexSelector extends StatelessWidget {
  const _SexSelector({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF85858D)),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _SexOption(
            label: 'Hombre',
            selected: selected == 'Hombre',
            onTap: () => onSelected('Hombre'),
          ),
          _SexOption(
            label: 'Mujer',
            selected: selected == 'Mujer',
            onTap: () => onSelected('Mujer'),
          ),
        ],
      ),
    );
  }
}

class _SexOption extends StatelessWidget {
  const _SexOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? ImcApp.blue : Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selected) ...[
                  const Icon(Icons.check, color: Colors.white, size: 15),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF202124),
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.validator,
    this.allowDecimal = true,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
        ),
      ],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.bmi,
    required this.weight,
    required this.height,
    required this.age,
    super.key,
  });

  final double bmi;
  final double weight;
  final int height;
  final int age;

  String get category {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  Color get categoryColor {
    if (bmi < 18.5) return const Color(0xFF3895E8);
    if (bmi < 25) return const Color(0xFF4CAF50);
    if (bmi < 30) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E9FC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tu IMC es',
                      style: TextStyle(fontSize: 12, color: Color(0xFF44464C)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xFF202124),
                        fontSize: 42,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _resultMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF686B73),
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Escala de clasificación',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202124),
                ),
              ),
              const SizedBox(height: 12),
              const _BmiScale(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      label: 'Edad',
                      value: '$age años',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoCard(
                      label: 'Peso',
                      value:
                          '${weight.toStringAsFixed(weight == weight.roundToDouble() ? 0 : 1)} kg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoCard(
                      label: 'Altura',
                      value: '$height cm',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Editar mis datos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ImcApp.blue,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _resultMessage {
    if (bmi < 18.5) {
      return 'Tu IMC está por debajo del rango recomendado. '
          'Considera consultar con un profesional de la salud.';
    }
    if (bmi < 25) {
      return '¡Muy bien! Tu IMC está dentro del rango saludable.';
    }
    if (bmi < 30) {
      return 'Tu IMC está por encima del rango saludable. '
          'Un profesional puede orientarte.';
    }
    return 'Tu IMC está en un rango elevado. '
        'Consulta con un profesional de la salud.';
  }
}

class _BmiScale extends StatelessWidget {
  const _BmiScale();

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('Bajo peso', Color(0xFF53A9F5)),
      ('Normal', Color(0xFF45B96B)),
      ('Sobrepeso', Color(0xFFFFB547)),
      ('Obesidad', Color(0xFFEB5A5A)),
    ];

    return Column(
      children: [
        Row(
          children: [
            for (final (_, color) in categories)
              Expanded(
                child: Container(
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            for (final (label, color) in categories)
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EBEF)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF70747C),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF202124),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
