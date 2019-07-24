import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/scan_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/mapas_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrscanner/src/providers/db_provider.dart';
import 'package:qrscanner/src/utils/utils.dart' as utils;

import 'direcciones_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansbloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: 
              scansbloc.borrarTodosScans,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=> _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _callPage(int paginaActual){

    switch (paginaActual){
      
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default: return MapasPage();
    }

  }

  Widget _crearBottomNavigationBar(){

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items:[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Mapas'),
        ),
      ],
    );

  }

  _scanQR(BuildContext context)async {

    // http://google.com
    //  geo:53.338201323579455,-6.258963493908709
    String futureString ="https://google.com";
    // String futureString ="";

    // try{
    // futureString =  await new QRCodeReader().scan();
    // }catch(e){
    //   futureString = e.toString();
    // }

    if (futureString != null){
      final scan = ScanModel(valor:futureString);
      scansbloc.agregarscan(scan);


    if (futureString != null){
          final scan2 = ScanModel(valor:'geo:53.338201323579455,-6.258963493908709');
          scansbloc.agregarscan(scan2);
    }

      if (Platform.isIOS){
        Future.delayed( Duration (  milliseconds: 750), (){
          utils.abrirScan(context, scan);    
        });
      }else{
      utils.abrirScan(context, scan);
        
      }
     

    


    }

  }



}