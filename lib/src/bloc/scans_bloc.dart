import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';


class ScansBloc with Validators{

  //El objetivo del singleton es tener una unica instancia del ScansBloc
  //Sin importar cuantas veces se llame en la aplicacion


  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //Obtener Scans de la BD
    obtenerScans();
  }

  //Poner informacion en el Stream
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  //Escuchar informacion que fluye en el stream
  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  //Cerrando el Stream Controller
  dispose(){
    _scansController?.close();
  }

  obtenerScans() async{
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTODOS() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }


}