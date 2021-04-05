import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:challenge/modelos.dart';


/*Declaracion de variables*/

const LIMIT = 200;
int lng = 0;

List<Publicacion> publicaciones_final = [];
List<Publicacion> p = [];
String busqueda = "";

List<String> condiciones = [];
List<String> _filtrosActivos = [];
Orden orden = Orden.relevantes;


var f = NumberFormat.currency(locale: 'eu', decimalDigits: 0,name: '');

/**/

class PublicacionesBloc {

  /* Search bar */


  StreamController<String> _buscador = new BehaviorSubject<String>();
  Stream<String> get buscador => _buscador.stream;

///final _buscador = BehaviorSubject<String>();

///Stream<String> get buscador => _buscador.stream.transform(ValidadorBuscador);

///Function(String) get ChangeBuscador => _buscador.sink.add;

///final ValidadorBuscador = StreamTransformer<String, String>.fromHandlers(
///    handleData:(txt,sink){
///     busqueda = txt;
///     print(busqueda);
///     sink.add("hola");
///    }

///);

  /**/


  /* Stream publicaciones */
    Stream<List<Publicacion>> get getPublicaciones async*{
      print("ejecuto get publicaciones");
      while(publicaciones_final.length<LIMIT){
        final publicaciones =  await TraerPublicaciones(publicaciones_final.length);  /* Traigo publicaciones */

        for(dynamic p in publicaciones["results"]){

          if(condiciones.indexOf(p["condition"]) == -1 ){  /* Si la condición no está en el array condiciones lo agrego para armar la lista de checks */
            condiciones.add(p["condition"]);
          }
          if(publicaciones_final.length == LIMIT)  /* Si en el array de publicaciones hay mas del limite no hago nada */
            break;

          publicaciones_final.add(
              Publicacion(
                title: p["title"],
                thumbnail: p["thumbnail"],
                condition: p["condition"],
                listing_type_id: p["listing_type_id"],
                price: p["price"].toInt(),
                available_quantity: p["available_quantity"],
                sold_quantity: p["sold_quantity"],
              )
          );
        }
      }

//      print(condiciones);
      p = publicaciones_final;

      print(busqueda);

     if(busqueda!=''){
       p = p.where((element) => element.title.contains(busqueda));
     }
      print(p);

   ///   if(orden){
   ///     //ordenamos p
   ///     switch(orden){}
   ///
   ///   }


      yield p;
    }

  /**/

  /* Orden EndDrawer*/

    StreamController<Orden> _orden = new BehaviorSubject<Orden>();
    Stream<Orden> get ordenStream => _orden.stream;
  /**/

  /* Condiciones Checks EndDrawer */

    StreamController<List<String>> _condiciones = new BehaviorSubject<List<String>>();
    Stream<List<String>> get condicions => _condiciones.stream;
  /**/

  /* Checks EndDrawer */

    StreamController<List<String>> _filtros = new BehaviorSubject<List<String>>();
    Stream<List<String>> get filtros  => _filtros.stream;

  /**/


  /* Rango de precios */

   final precioMin = BehaviorSubject<String>();
   final precioMax = BehaviorSubject<String>();

   Stream<String> get pMax => precioMax.stream.transform(ValidadorPMax);
   Stream<String> get pMin => precioMin.stream.transform(ValidadorPMin);

   Stream<bool> get validar => Rx.combineLatest2(pMax, pMin, (pMax, pMin) => true);

   Function(String) get ChangepMax => precioMax.sink.add;
   Function(String) get ChangepMin => precioMin.sink.add;

   final ValidadorPMax = StreamTransformer<String, String>.fromHandlers(
        handleData:(maximo,sink){
          print(maximo);

          // if(precio==0){
          //   sink.addError("Tienes que agregar un precio");
          // }else{
          //   sink.add(precio);
          // }
        }
    );
    final ValidadorPMin = StreamTransformer<String, String>.fromHandlers(
        handleData:(minimo,sink){
         // final a = f.format(int.parse(minimo));
         // sink.add("123");

          // if(precio==0){
          //   sink.addError("Tienes que agregar un precio");
          // }else{

          // }
        }
    );

  /**/


  /* Contador publicaciones SliverAppBar */

    StreamController<int> _publicacionesContador = new BehaviorSubject<int>();
    Stream<int> get publicacionesContador => _publicacionesContador.stream;
  /**/

  /* Stream listen events */

    StreamController<PublicacionesBase> _input =BehaviorSubject();
    StreamController<List<String>> _output = BehaviorSubject();

    StreamSink<PublicacionesBase> get activarEvento => _input.sink;
  /**/


  PublicacionesBloc(){
    this.getPublicaciones.listen( ( productosList ) => this._publicacionesContador.add(productosList.length) );
    //this.getPublicaciones.listen( ( filtros ) => this._filtros.add(_filtrosActivos));//
    //this.getPublicaciones.listen( ( condicion ) => this._condiciones.add(condiciones));
    //this.getPublicaciones.listen( ( b ) => this._buscador.add(busqueda));

     _input.stream.listen(Evento);
  }

  Evento(PublicacionesBase event) {
    print(event);
    if(event is ActualizarFiltros){

      if(_filtrosActivos.contains(event.title)){

        _filtrosActivos.remove(event.title);
      }else{

        _filtrosActivos.add(event.title);
      }
      _filtros.add(_filtrosActivos);

      print("Filtro condicion = "+_filtrosActivos.toString());

      _output.add(_filtrosActivos);
    }

    if(event is ActualizarOrden){
      _orden.add(event.orden);
    }

    if(event is Buscador){
      print("EEEE"+event.busqueda);
      busqueda = event.busqueda;
      _buscador.add(event.busqueda);
    }

  }
  dispose(){
    _publicacionesContador.close();
    _input.close();
    _output.close();
     precioMin.close();
     precioMax.close();
    _buscador.close();
  }
}

TraerPublicaciones(lng) async {

    String filtro = "";

    if(lng!=0){
      filtro = "&offset="+lng.toString();
    }

    final response = await http.get('https://api.mercadolibre.com/sites/MLA/search?q=iphone'+filtro);

    if (response.statusCode == 200 ) {

      return jsonDecode(response.body);

    } else {
      throw Exception('Fallo al traer las publicaciones');
    }
}

