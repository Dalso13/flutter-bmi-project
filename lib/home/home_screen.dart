import 'package:bmi_project/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heigthController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heigthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future save() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setDouble('height', double.parse(_heigthController.text));
    prefs.setDouble('weight', double.parse(_weightController.text));
  }

  @override
  void initState() {
    super.initState();

    load();
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();

    final double? height = prefs.getDouble('height');
    final double? weight = prefs.getDouble('weight');

    if (height != null){
      _heigthController.text = '$height';
    }
    if (weight != null){
      _weightController.text = '$weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비만도 계산기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _heigthController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '키',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '몸무게',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '몸무게를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == false) {
                      return;
                    } else {
                      save();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            weight: double.parse(_weightController.text),
                            height: double.parse(_heigthController.text),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('결과'))
            ],
          ),
        ),
      ),
    );
  }
}
