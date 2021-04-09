
class PublicacionesBase{}
class PublicacionBase{}

enum Orden { relevantes, menorprecio, mayorprecio, menosvendidos, masvendidos }

class ActualizarPublicacion extends PublicacionBase{
  final String id;

  ActualizarPublicacion({this.id});
}

class Tipo {
  final String id, name;

  Tipo({this.id,this.name});
}


class ActualizarFiltros extends PublicacionesBase{

  final String title;

  ActualizarFiltros({this.title});
}

class LimpiarFiltros extends PublicacionesBase{}

class Buscador extends PublicacionesBase {

  final String busqueda;

  Buscador({this.busqueda});
}

class FiltrarPrecioMinimo extends PublicacionesBase{

  final int preciominimo;

  FiltrarPrecioMinimo({this.preciominimo});
}

class FiltrarPrecioMaximo extends PublicacionesBase{

  final int preciomaximo;

  FiltrarPrecioMaximo({this.preciomaximo});
}


class ActualizarOrden extends PublicacionesBase{

  final Orden orden;

  ActualizarOrden({this.orden});
}



class Publicacion {

  final String id, title, thumbnail, condition, listing_type_id, warranty, site_id, status;
  final int price, available_quantity, sold_quantity, initial_quantity, base_price;

  Publicacion({this.id,this.title,this.thumbnail,this.condition,this.listing_type_id,this.price,this.available_quantity,this.sold_quantity,this.warranty,this.site_id,this.status,this.initial_quantity,this.base_price});
}