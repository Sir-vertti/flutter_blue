import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blue Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      // Process scan results
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });
    flutterBlue.startScan();
  }

  void _stopScan() {
    flutterBlue.stopScan();
  }

  void _pairToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print('Connected to ${device.name}');
      // Perform additional operations with the connected device
    } catch (e) {
      print('Error connecting to ${device.name}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = devicesList[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id.toString()),
                  onTap: () {
                    _pairToDevice(device);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _stopScan,
        tooltip: 'Stop Scan',
        child: Icon(Icons.stop),
      ),
    );
  }
}
