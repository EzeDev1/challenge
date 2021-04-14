import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bloc/publicacion_bloc.dart';
import 'modelos.dart';



class VistaPublicacion extends StatefulWidget {
  final String id;

  const VistaPublicacion({Key key, this.id}) : super(key: key);

  @override
  _VistaPublicacionState createState() => _VistaPublicacionState();
}

class _VistaPublicacionState extends State<VistaPublicacion> {

  final publicacionBloc = PublicacionBloc();
  var f = NumberFormat.currency(locale: 'eu', decimalDigits: 0,name: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    publicacionBloc.activarEvento.add(ActualizarPublicacion(id : widget.id));
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
        body:
        CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[Container()],
              floating: false,
              expandedHeight: height*0.105,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Container(
                      height: height*0.055,
                      color: Colors.yellow,
                    ),
                    Container(
                      height: height*0.06,
                      child: Row(
                        children: [
                          Container(
                            width: width*0.05,
                          ),
                          Container(
                            height: height*0.4,
                            width: width*0.1,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,color: Colors.black,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            height: height*0.03,
                            width: width*0.4,
                            margin: EdgeInsets.only(left: width*0.03),
                            child: AutoSizeText("Producto",style: TextStyle(fontSize: 20,color: Colors.grey[800]),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height*0.025,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: height*0.86,
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      child: StreamBuilder(
                        stream: publicacionBloc.getPublicacion,
                        builder: ( _ , AsyncSnapshot  <Publicacion> _publicacion){

                          final publicacion = _publicacion.data ?? [];

                          return _publicacion.hasData == true ? Column(
                            children: [
                              Container(
                                height: height*0.03,
                                width: width*0.9,
                                margin: EdgeInsets.only(top: height*0.02),
                                decoration: BoxDecoration(
                                ),
                                child: AutoSizeText(_publicacion.data.condition+"  /  "+_publicacion.data.sold_quantity.toString()+" vendidos",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                              ),
                              Container(
                                height: height*0.04,
                                width: width*0.9,
                                margin: EdgeInsets.only(top: height*0.01),
                                decoration: BoxDecoration(
                                ),
                                child: AutoSizeText(_publicacion.data.title,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                              ),
                              Container(
                                height: height*0.28,
                                width: width*1.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(_publicacion.data.thumbnail),fit: BoxFit.contain)
                                ),
                              ),

                              Container(
                                height: height*0.07,
                                width: width*0.9,
                                margin: EdgeInsets.only(top: height*0.01),
                                decoration: BoxDecoration(),
                                child: Card(
                                  color: Colors.grey[200],
                                  child: Row(
                                    children: [
                                      Container(width: width*0.03,),
                                      AutoSizeText("Estado: "),
                                      AutoSizeText(_publicacion.data.status,style: TextStyle(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                height: height*0.07,
                                width: width*0.9,
                                decoration: BoxDecoration(),
                                child: Card(
                                  color: Colors.grey[200],
                                  child: Row(
                                    children: [
                                      Container(width: width*0.03,),
                                      AutoSizeText("Site id: "),
                                      AutoSizeText(_publicacion.data.site_id,style: TextStyle(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                height: height*0.07,
                                width: width*0.9,
                                decoration: BoxDecoration(),
                                child: Card(
                                  color: Colors.grey[200],
                                  child: Row(
                                    children: [
                                      Container(width: width*0.03,),
                                      AutoSizeText("Cantidad inicial: "),
                                      AutoSizeText(_publicacion.data.initial_quantity.toString(),style: TextStyle(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                height: height*0.05,
                                width: width*0.88,
                                margin:EdgeInsets.only(top: height*0.02),
                                decoration: BoxDecoration(
                                ),
                                child: AutoSizeText("\$ "+f.format(_publicacion.data.base_price).toString(),style: TextStyle(fontSize: 30),),
                              ),

                              Container(
                                  height: height*0.05,
                                  width: width*0.9,
                                  margin:EdgeInsets.only(top: height*0.02),
                                  decoration: BoxDecoration(
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.credit_card,color: Colors.grey[800],),
                                      Container(width: width*0.02,),
                                      AutoSizeText(_publicacion.data.warranty,style: TextStyle(fontSize: 16),)
                                    ],
                                  )
                              ),

                            ],
                          ):Center(child: CircularProgressIndicator(),);
                        },
                      ),
                    );
                  },
                  childCount: 1
              ),
            ),
          ],
        )
    );
  }
}


