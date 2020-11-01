import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'dark-v10';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            }
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
          switch(tipoMapa){
            case 'streets-v11':     tipoMapa='dark-v10';      print('Cambie a $tipoMapa'); break;
            case 'dark-v10':        tipoMapa='light-v10';     print('Cambie a $tipoMapa'); break;
            case 'light-v10':       tipoMapa='outdoors-v11';  print('Cambie a $tipoMapa'); break;
            case 'outdoors-v11':    tipoMapa='satellite-v9'; print('Cambie a $tipoMapa'); break;
            case 'satellite-v9':   tipoMapa='streets-v11';   print('Cambie a $tipoMapa'); break;
            default:            tipoMapa='streets-v11';   print('Default'); break;
          }          
        setState((){});
      },
    );
  }

  Widget _crearFlutterMap(ScanModel scan){
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );


        
    
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/'
                    '{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken':'pk.eyJ1Ijoia2FsaW1hbjA0NyIsImEiOiJja2V1NG45Z2cxN2V3MnFzYWJ3d282bGl1In0.aEEQvtexUF_RvLY36ap0Ug',
        'id': 'mapbox/$tipoMapa'
        //streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context)=> Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ]
    );
  }
}