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

const LIMIT = 200; /* Limite de publicaciones del challenge */

var f = NumberFormat.currency(locale: 'eu', decimalDigits: 0,name: ''); /* formato numero */
List<Publicacion> publicaciones_final_filtradas = [];  /* Array de publicaciones filtrado que retorna el get */
List<Publicacion> publicaciones_final = []; /* Array de publicaciones sin filtrar */

List<String> _filtrosActivos = []; /* Filtros activos de condiciones (Usado, nuevo, etc) */
Orden orden = Orden.relevantes; /* Orden en en que se inicializa el filtro de orden*/
List<String> condiciones = [];  /* Condiciones */
List<Tipo> tipos = []; /*Array de tipos de publicacion ( Clasica, Premium, etc) */
String busqueda = "";  /* Texto de la busqueda */
int rangoMinimo = 0;   /* Rango de precio minimo del filtro */
int rangoMaximo = 0;   /* Ranco de precio maximo del filtro */
String rango = '';    /* Texto con rangoMinimo y rangoMaximo */
/**/

class PublicacionesBloc {

  /* Contador publicaciones SliverAppBar */

  StreamController<int> _publicacionesContador = new BehaviorSubject<int>();
  Stream<int> get publicacionesContador => _publicacionesContador.stream;
  /**/


  /* Stream publicaciones */
    Stream<List<Publicacion>> get getPublicaciones async*{
      rango = "";

      while(publicaciones_final.length<LIMIT){
        final publicaciones =  await TraerPublicaciones(publicaciones_final.length);  /* Traigo publicaciones */

        for(dynamic p in publicaciones["results"]){

          if(condiciones.indexOf(p["condition"]) == -1 ){  /* Si la condición no está en el array condiciones lo agrego para armar la lista de checks */
            condiciones.add(p["condition"]);
          }

          if(publicaciones_final.length == LIMIT)  /* Si en el array de publicaciones supero el limite no hago nada */
            break;

          publicaciones_final.add(
              Publicacion(
                id: p["id"],
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

      publicaciones_final_filtradas = List.from(publicaciones_final);


  /* Orden de las publicaciones*/
     switch(orden){
       case Orden.relevantes: {
         publicaciones_final_filtradas = publicaciones_final;
       }
       break;
       case Orden.mayorprecio: {
         publicaciones_final_filtradas.sort((a, b) => (b.price).compareTo(a.price));
       }
       break;
       case Orden.menorprecio: {
         publicaciones_final_filtradas.sort((a, b) => (a.price).compareTo(b.price));
       }
       break;
       case Orden.menosvendidos: {
         publicaciones_final_filtradas.sort((a, b) => (a.sold_quantity).compareTo(b.sold_quantity));
       }
       break;
       case Orden.masvendidos: {
         publicaciones_final_filtradas.sort((a, b) => (b.sold_quantity).compareTo(a.sold_quantity));
       }
       break;
     }

  /* Busqueda con search*/
      if(busqueda!=''){
        publicaciones_final_filtradas =  publicaciones_final_filtradas.where((e) => e.title.toLowerCase().contains(busqueda)).toList();
      }

  /* Filtro de condiciones */
      if(_filtrosActivos.isNotEmpty){
        publicaciones_final_filtradas =  publicaciones_final_filtradas.where((e) => _filtrosActivos.contains(e.condition)).toList();
      }

  /* Rango de precio */

      if(rangoMinimo > 0){
        publicaciones_final_filtradas =  publicaciones_final_filtradas.where((e) => (e.price > rangoMinimo)).toList();
        rango = "\$ "+f.format(rangoMinimo).toString()+" - ";
      }

      if(rangoMaximo > 0 ){
        publicaciones_final_filtradas =  publicaciones_final_filtradas.where((e) => (e.price < rangoMaximo)).toList();
        if(rangoMaximo!=10000000){
          rango = rango + f.format(rangoMaximo).toString();
        }
      }

  /* Actualizo los valores */
      _publicacionesContador.add(publicaciones_final_filtradas.length);
      _orden.add(orden);


      yield publicaciones_final_filtradas;
    }

  /**/

  /* Rango precios en el subtitulo*/
  Stream<String> get getRangoPrecios async*{
        print("get"+rango);
    yield rango;
  }

  /* Orden EndDrawer Radios*/

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


  /* Stream listen events */

    StreamController<PublicacionesBase> _input =BehaviorSubject();
    StreamController<List<String>> _output = BehaviorSubject();

    StreamSink<PublicacionesBase> get activarEvento => _input.sink;
  /**/


  PublicacionesBloc(){
    this.getPublicaciones.listen( ( condicion ) => this._condiciones.add(condiciones));

     _input.stream.listen(Evento);
  }

  Evento(PublicacionesBase event) {


    if(event is ActualizarFiltros){

      if(_filtrosActivos.contains(event.title)){

        _filtrosActivos.remove(event.title);
      }else{

        _filtrosActivos.add(event.title);
      }
      _filtros.add(_filtrosActivos);

      print("Filtro condicion = "+_filtrosActivos.toString());

    }

    if(event is ActualizarOrden){
      orden = event.orden;
      _orden.add(event.orden);
    }

    if(event is Buscador){
       print("Escribiendo: "+event.busqueda);

       busqueda = event.busqueda;
    }

    if(event is FiltrarPrecioMinimo){
       rangoMinimo = event.preciominimo;
       if(event.preciominimo==''){
         rango = '';
       }
    }

    if(event is FiltrarPrecioMaximo){
      rangoMaximo = event.preciomaximo;
    }

    if(event is LimpiarFiltros){
       rangoMaximo = 0;
       rangoMinimo =  0;
       orden = Orden.relevantes;
       _filtrosActivos.clear();
       rango = "";
    }
  }

  dispose(){
    _publicacionesContador.close();
    _input.close();
    _output.close();
    _orden.close();
    _filtros.close();
  }

  /* Stream Tipos */
  Stream<List<Tipo>> get getTipos async*{

    final t =  await TraerListaTipos();  /* Traigo los tipos */

    for(dynamic p in t){
          tipos.add(
              Tipo(
                  id: p["id"],
                  name: p["name"],
                )
          );
    }

    yield tipos;
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

TraerListaTipos() async {

  final response = await http.get('https://api.mercadolibre.com/sites/MLA/listing_types');

  if (response.statusCode == 200 ) {

    return jsonDecode(response.body);

  } else {
    throw Exception('Fallo al traer los tipos');
  }
}

