
import 'bloc/publicaciones_bloc.dart';

class PublicacionesBase{}

enum Orden { relevantes, menorprecio, mayorprecio }


class ActualizarFiltros extends PublicacionesBase{

  final String title;

  ActualizarFiltros({this.title});
}

class Buscador extends PublicacionesBase{

  final String busqueda;

  Buscador({this.busqueda});
}


class ActualizarOrden extends PublicacionesBase{

  final Orden orden;

  ActualizarOrden({this.orden});
}



class Publicacion {

  final String title, thumbnail, condition, listing_type_id;
  final int price, available_quantity, sold_quantity;

  Publicacion({this.title,this.thumbnail,this.condition,this.listing_type_id,this.price,this.available_quantity,this.sold_quantity});
}