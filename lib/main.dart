import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _notificacao1Controller = TextEditingController(
    text: 'Pix gerado!\nSua comissão: R\$ 19,90',
  );
  final TextEditingController _notificacao2Controller = TextEditingController(
    text: 'Venda aprovada!\nSua comissão: R\$ 19,90',
  );
  final TextEditingController _quantidadeController = TextEditingController(
    text: '5',
  );
  final TextEditingController _intervaloController = TextEditingController(
    text: '5',
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _mostrarNotificacao(String mensagem, int id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'canal_id',
          'canal_nome',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      'Notificação',
      mensagem,
      platformChannelSpecifics,
    );
  }

  void _gerarNotificacoes() {
    final int quantidade = int.tryParse(_quantidadeController.text) ?? 0;
    final int intervalo = int.tryParse(_intervaloController.text) ?? 5;

    for (int i = 0; i < quantidade; i++) {
      Future.delayed(Duration(seconds: i * intervalo), () {
        _mostrarNotificacao(_notificacao1Controller.text, i);
      });

      Future.delayed(Duration(seconds: (i * intervalo) + (intervalo ~/ 2)), () {
        _mostrarNotificacao(_notificacao2Controller.text, i + 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(title: Text('Notificações Fake')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard('Notificação 1', _notificacao1Controller),
              SizedBox(height: 10),
              _buildCard('Notificação 2', _notificacao2Controller),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'Quantidade',
                      _quantidadeController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField('Intervalo', _intervaloController),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _gerarNotificacoes,
                child: Text('Gerar Notificações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, TextEditingController controller) {
    return Card(
      color: Colors.green[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.campaign, color: Colors.white),
        title: TextField(
          controller: controller,
          maxLines: 2,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: titulo,
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
        trailing: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
