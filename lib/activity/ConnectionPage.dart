import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class ConnectionPage {
  UsbPort _port;
  // ignore: unused_field
  String _status = "Idle";
  // ignore: unused_field
  List<Widget> _ports = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  // ignore: unused_field
  int _deviceId;

  Future<bool> _connectTo(device) async {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
        _status = "Disconnected";
      return false;
    }

    _port = await device.create();
    if (!await _port.open()) {
        _status = "Failed to open port";
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        19200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

   

    _status = "Connected";
    return true;
  }

  _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    _connectTo(devices[0]);
  }

  getData(){
    Transaction<Uint8List> transaction = 
    Transaction.terminated(_port.inputStream, Uint8List.fromList([127]));
    transaction.stream.listen((event) async {
     return  event;
    });
  }

}
