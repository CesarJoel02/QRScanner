import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/providers/db_provider.dart';
import 'package:flutter_map/src/geo/latlng_bounds.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController mapctlr = new MapController();

  String tipomapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapctlr.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap (ScanModel scan){
    return FlutterMap(
      mapController: mapctlr,
      options: MapOptions(
        center:scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accesToken}',
      additionalOptions: {
        'accesToken':'pk.eyJ1IjoiY2VzYXJqb2VsMDIiLCJhIjoiY2p5Z2hwMjY2MDE2NzNocXQwcW1zeW43MiJ9.AwDv8DQkKI4rAPbQjD-gIw',
        'id':'mapbox.$tipomapa'
      }
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers:<Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 70.0,color:Theme.of(context).primaryColor),
          )
        ),
      ]
    );
  }

  Widget _crearBotonFlotante(BuildContext context){

    return FloatingActionButton(
      onPressed: (){
        setState(() {
           if( tipomapa == 'streets'){
          tipomapa = 'dark';
        }else if(tipomapa == 'dark'){
          tipomapa = 'light';
        }
        else if(tipomapa == 'light'){
          tipomapa = 'outdoors';
        }
        else if(tipomapa == 'outdoors'){
          tipomapa = 'satellite';
        }
        else {
          tipomapa = 'streets';
        }
        });

       

      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
      
  }
}
