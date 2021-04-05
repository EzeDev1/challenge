import 'package:flutter/material.dart';
import 'package:challenge/bloc/publicaciones_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'modelos.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nubimetrics',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  var f = NumberFormat.currency(locale: 'eu', decimalDigits: 0,name: '');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final publicacionesBloc = new PublicacionesBloc();
  //var formatoInputsPrecio = new MaskTextInputFormatter(mask: ' \$ ###########', filter: { "#": RegExp(r'[0-9]') });


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer:Drawer(
        child: Column(
          children: [
            Container(height: height*0.14,color: Colors.yellow,),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: height*0.05,
                  width: width*1.0,
                  //color: Colors.red,
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: width*0.04),
                          height: height*0.03,
                          width: width*0.2,
                          child: Text("Filtrar por:",style: TextStyle(color: Colors.grey[800],fontSize: 16,fontWeight: FontWeight.w400,),)
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width*0.23,top: height*0.005),
                        height: height*0.03,
                        width: width*0.25,
                        // color: Colors.grey,
                        child: Text("Limpiar filtros",style: TextStyle(color: Colors.blue,fontSize: 13),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),


                ExpansionTile(
                  iconColor: Colors.blue,
                  title: Column(
                  children: [
                    Container(
                          margin: EdgeInsets.only(right: width*0.4),
                          height: height*0.02,
                          width: width*0.2,
                          child: Text("Ordenar por:",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                        ),
                    Container(
                      margin: EdgeInsets.only(right: width*0.35),
                      height: height*0.02,
                      width: width*0.3,
                      child: StreamBuilder(
                        stream: publicacionesBloc.ordenStream,
                        builder: ( _ , AsyncSnapshot  <Orden> _orden){
                          final orden = _orden.data ?? [];

                          String o = "Más relevantes";

                          switch(orden) {
                            case Orden.relevantes: {
                               o = "Más relevantes";
                            }
                            break;

                            case Orden.menorprecio: {
                              o = "Menor precio";
                            }
                            break;

                            case Orden.mayorprecio: {
                              o = "Mayor precio";
                            }
                            break;
                          }
                          return  Text(o,style: TextStyle(color: Colors.blue,fontSize: 12),);
                        },
                      ),

                    )
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                      onTap: (){
                        publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.relevantes));
                      },
                      title: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width*0.03),
                            height: height*0.02,
                            width: width*0.3,
                            child: Text('Más relevantes',style: TextStyle(fontWeight: FontWeight.w400),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width*0.27),
                            height: height*0.027,
                            width: width*0.06,
                            child: StreamBuilder(
                              stream: publicacionesBloc.ordenStream,
                              builder: ( _ , AsyncSnapshot  <Orden> _orden){

                                final orden = _orden.data ?? [];

                                return  Radio(
                                  hoverColor: Colors.blue,
                                  activeColor: Colors.blue,
                                  value: Orden.relevantes,
                                  groupValue: orden,
                                  onChanged: (value) {
                                    publicacionesBloc.activarEvento.add(ActualizarOrden(orden: value));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.menorprecio));

                      },
                      title: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width*0.03),
                            height: height*0.02,
                            width: width*0.3,
                            child: Text('Menor precio',style: TextStyle(fontWeight: FontWeight.w400),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width*0.27),
                            height: height*0.027,
                            width: width*0.06,
                            child: StreamBuilder(
                              stream: publicacionesBloc.ordenStream,
                              builder: ( _ , AsyncSnapshot  <Orden> _orden){

                                final orden = _orden.data ?? [];

                                return  Radio(
                                  hoverColor: Colors.blue,
                                  activeColor: Colors.blue,
                                  value: Orden.menorprecio,
                                  groupValue: orden,
                                  onChanged: (value) {
                                    publicacionesBloc.activarEvento.add(ActualizarOrden(orden: value));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.mayorprecio));
                      },
                      title: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width*0.03),
                            height: height*0.02,
                            width: width*0.3,
                            child: Text('Mayor precio',style: TextStyle(fontWeight: FontWeight.w400),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width*0.27),
                            height: height*0.027,
                            width: width*0.06,
                            child: StreamBuilder(
                              stream: publicacionesBloc.ordenStream,
                              builder: ( _ , AsyncSnapshot  <Orden> _orden){

                                final orden = _orden.data ?? [];

                                return  Radio(
                                  hoverColor: Colors.blue,
                                  activeColor: Colors.blue,
                                  value: Orden.mayorprecio,
                                  groupValue: orden,
                                  onChanged: (value) {
                                    publicacionesBloc.activarEvento.add(ActualizarOrden(orden: value));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              StreamBuilder<List<String>>(
                  stream: publicacionesBloc.condicions,
                  builder: (BuildContext context, AsyncSnapshot  _condicion)
                  {
                    final condicion = _condicion.data ?? [];

                    List<Widget> list = new List<Widget>();
                    for(int i = 0; i < condicion.length; i++){
                      list.add(
                        ListTile(
                        onTap: (){
                          publicacionesBloc.activarEvento.add(ActualizarFiltros(title: condicion[i]));
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.02,
                              width: width*0.3,
                              child: Text(_condicion.data[i],style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.27),
                              height: height*0.027,
                              width: width*0.06,
                              child: StreamBuilder(
                                 stream: publicacionesBloc.filtros,
                                 builder: ( _ , AsyncSnapshot  <List<String>> _filtros){

                                   final filtros = _filtros.data ?? [];

                                   return  Checkbox(
                                     checkColor: Colors.white,
                                     hoverColor: Colors.blue,
                                     activeColor: Colors.blue,
                                     value: (filtros.indexOf(condicion[i])>-1)?true:false, /* */
                                     onChanged:(val){
                                        publicacionesBloc.activarEvento.add(ActualizarFiltros(title: condicion[i]));
                                     },
                                   );
                                 },
                               ),

                            ),
                          ],
                        ),
                      ),
                      );
                    }
                    return  ExpansionTile(
                            iconColor: Colors.blue,
                            title: Column(
                            children: [
                                Container(
                                  margin: EdgeInsets.only(right: width*0.4),
                                  height: height*0.02,
                                  width: width*0.2,
                                  child: Text("Condicion",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width*0.1),
                                  height: height*0.02,
                                  width: width*0.5,
                                  child:  StreamBuilder(
                                      stream: publicacionesBloc.filtros,
                                      builder: ( _ , AsyncSnapshot  <List<String>> _filtros){

                                        final filtros = _filtros.data ?? [];

                                        return  Text(filtros.toString().replaceAll("[", '').replaceAll("]", ''),style: TextStyle(color: Colors.blue,fontSize: 12),);
                                      },
                                    ),
                                  )
                              ],
                            ),
                            children: <Widget>[
                              Column(children: list,)
                            ],
                            );
                    }
                    ),

                 ExpansionTile(
                  iconColor: Colors.blue,
                  title: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: width*0.3),
                        height: height*0.02,
                        width: width*0.3,
                        child: Text("Rango de precio",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: width*0.35),
                        height: height*0.02,
                        width: width*0.3,
                        child: Text("",style: TextStyle(color: Colors.blue,fontSize: 12),),
                      )
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                      onTap: (){},
                      title: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                               // color: Colors.blue,
                                height: height*0.016,
                                width: width*0.2,
                                margin: EdgeInsets.only(top: height*0.01,right: width*0.05),
                                child: Text("Minimo",style: TextStyle(color: Colors.grey[700],fontSize: 11),),
                              ),
                              Container(
                                height: height*0.04,
                                width: width*0.25,
                                child:
                                StreamBuilder<String>(
                                  stream: publicacionesBloc.pMin,
                                  builder: ( _ , AsyncSnapshot snapshot){
                                    return TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        ThousandsFormatter()
                                      ],
                                      onChanged: publicacionesBloc.ChangepMin,
                                      decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        hintText: '\$ 15.000',
                                      ),
                                    );
                                  },
                                )
                              ),
                            ],
                          ),
                          Container(width: width*0.15,),
                          Column(
                            children: [
                              Container(
                                // color: Colors.blue,
                                height: height*0.016,
                                width: width*0.2,
                                margin: EdgeInsets.only(top: height*0.01,right: width*0.05),
                                child: Text("Máximo",style: TextStyle(color: Colors.grey[700],fontSize: 11),),
                              ),
                              Container(
                                height: height*0.04,
                                width: width*0.25,
                                child:
                                StreamBuilder<String>(
                                  stream: publicacionesBloc.pMax,
                                  builder: ( _ , AsyncSnapshot snapshot){
                                    return TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        ThousandsFormatter(),
                                      ],
                                      onChanged: publicacionesBloc.ChangepMax,
                                      decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        hintText: '\$ 35.000',
                                      ),
                                    );
                                  },
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body:


     CustomScrollView(
       slivers: [
         SliverAppBar(
           automaticallyImplyLeading: false,
           actions: <Widget>[Container()],
           floating: false,
           expandedHeight: 130,
           flexibleSpace: FlexibleSpaceBar(
             background: Column(
               children: [
                 Container(
                   height: height*0.055,
                   color: Colors.yellow,
                 ),
                 Container(
                   height: height*0.04,
                   color: Colors.yellow,
                   child: Container(
                     margin: EdgeInsets.only(left: width*0.1,right: width*0.1),
                     child:
                     StreamBuilder<String>(
                       stream: publicacionesBloc.buscador,
                       builder: ( _ , AsyncSnapshot snapshot){
                         return TextFormField(
                           cursorColor: Colors.grey,
                           onChanged: (value){
                             publicacionesBloc.activarEvento.add(Buscador(busqueda: value));
                           },
                           decoration: InputDecoration(
                               hintText: 'Buscar en Mercado Libre',
                               focusColor: Colors.blue,
                               labelStyle: TextStyle(color: Colors.grey[600],fontSize: 11),
                               hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                               icon: Container(child: Icon(Icons.search,color: Colors.grey,),margin: EdgeInsets.only(left: width*0.02))
                           ),
                         );
                       },
                     ),
                     decoration: BoxDecoration (
                         borderRadius: BorderRadius.all( Radius.circular(30)),
                         color: Colors.white
                     ),
                   ),
                 ),
                 Container(
                   height: height*0.045,
                   color: Colors.yellow,
                 ),
                 Container(
                   height: height*0.0522,
                   decoration: BoxDecoration(
                       color: Colors.white,
                       border: Border(bottom: BorderSide(color:Colors.grey,width: 1)
                       ),
                   ),
                   child: Row(
                     children: [
                       Container(
                         margin: EdgeInsets.only(left: width*0.03,top: 5),
                         height: height*0.025,
                         //color: Colors.blue,
                         width: width*0.3,
                         child:
                          StreamBuilder(
                            stream: publicacionesBloc.publicacionesContador,
                            builder: ( _ , AsyncSnapshot <int> snapshot){
                              return snapshot.data == null ? Text("+0 resultados" ,style: TextStyle(color: Colors.grey[600],fontSize: 15),) : Text("+"+snapshot.data.toString()+" resultados" ,style: TextStyle(color: Colors.grey[600],fontSize: 15),);
                            },
                          )
                       ),
                       GestureDetector(
                         onTap: (){
                           _scaffoldKey.currentState.openEndDrawer();
                         },
                         child: Container(
                           margin: EdgeInsets.only(left: width*0.4),
                           height: height*0.019,
                          // color: Colors.blue,
                           width: width*0.25,
                           child: Text("Filtrar (3)",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,),
                         ),
                       ),
                     ],
                   ),
                 )
               ],
             ),
           ),
         ),

         StreamBuilder(
          stream: publicacionesBloc.getPublicaciones,
          builder: ( _ , AsyncSnapshot <List<Publicacion>> snapshot){

            final publicaciones = snapshot.data ?? [];
            

            return  SliverFixedExtentList(
              itemExtent: snapshot.hasData ? height*0.21:height*0.8,
              delegate: snapshot.hasData ? SliverChildBuilderDelegate(

                    (BuildContext context, int index) {

                      return ListTile(

                        onTap: (){},
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.grey[500],
                                      image: DecorationImage(image: NetworkImage(publicaciones[index].thumbnail),fit: BoxFit.fill)
                                  ),
                                  height: height*0.16,
                                  width: width*0.3,
                                ),
                                Container(
                                    height: height*0.2,
                                    width: width*0.6,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02,top: height*0.01),
                                          height: height*0.045,
                                          width: width*0.6,
                                          // color:Colors.white,
                                          child: Text(publicaciones[index].title,style: TextStyle(fontSize: 14),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02,top: height*0.005),
                                          height: height*0.03,
                                          width: width*0.6,
                                          // color:Colors.white,
                                          child: Text("\$ "+f.format(publicaciones[index].price).toString(),style: TextStyle(fontSize: 20),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                          height: height*0.02,
                                          width: width*0.6,
                                          //color:Colors.white,
                                          child: Text(publicaciones[index].condition,style: TextStyle(fontSize: 15,color: Colors.blue),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                          height: height*0.02,
                                          width: width*0.6,
                                          //color:Colors.red,
                                          child: Text(publicaciones[index].available_quantity.toString()+" disponibles",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                          height: height*0.02,
                                          width: width*0.6,
                                          // color:Colors.red,
                                          child: Text(publicaciones[index].sold_quantity.toString()+" vendidos",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                          height: height*0.02,
                                          width: width*0.6,
                                          child: Text(publicaciones[index].listing_type_id,style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            Divider(height: 5,color: Colors.grey[400],)
                          ],
                        )
                      );
                },
                childCount: publicaciones.length,
              ):SliverChildBuilderDelegate((BuildContext context, int index) {return Center(child: CircularProgressIndicator(color: Colors.blue,),);},childCount: 1),
            );
          },
        )
       ],
     )
    );
  }

}
