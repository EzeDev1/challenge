import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:challenge/modelos.dart';
import 'package:rxdart/rxdart.dart';

Publicacion publicacion = Publicacion();
String id = "";


class PublicacionBloc {

  Stream<Publicacion> get getPublicacion async*{
    final p =  await TraerPublicacion(id);  /* Traigo la publicacion */

    publicacion =  Publicacion(
      id: p["id"],
      title: p["title"],
      thumbnail: p["pictures"][0]["url"],
      condition: p["condition"],
      listing_type_id: p["listing_type_id"],
      price: p["price"].toInt(),
      available_quantity: p["available_quantity"],
      sold_quantity: p["sold_quantity"],
      base_price:  p["base_price"],
      initial_quantity: p["initial_quantity"],
      site_id: p["site_id"],
      status:  p["status"],
      warranty: p["warranty"],
    );

    yield publicacion;
  }

  /* Stream listen events */

  StreamController<PublicacionBase> _input = BehaviorSubject();
  StreamController<String> _output = BehaviorSubject();

  StreamSink<PublicacionBase> get activarEvento => _input.sink;
  /**/

  PublicacionBloc(){
    _input.stream.listen(Evento);
  }

  dispose(){
    _input.close();
    _output.close();
  }

  Evento(PublicacionBase event) {
    if(event is ActualizarPublicacion){
      id = event.id;
    }
  }

}


TraerPublicacion(id) async {
  if(id=='')
    return;

  final response = await http.get('https://api.mercadolibre.com/items/'+id);

  if (response.statusCode == 200 ) {
      print(response.body);
    return jsonDecode(response.body);

  } else {
    throw Exception('Fallo al traer las publicaciones');
  }
}