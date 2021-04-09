import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:challenge/bloc/publicaciones_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'modelos.dart';
import 'publicacion.dart';


class Publicaciones extends StatefulWidget {

  @override
  _PublicacionesState createState() => _PublicacionesState();
}



class _PublicacionesState extends State<Publicaciones> {

  // Declaracion de variables \\
  final rangominimo = TextEditingController(); /* Rango de precio */
  final rangomaximo = TextEditingController(); /* Rango de precio */
  final publicacionesBloc = new PublicacionesBloc(); /* Inicializo el bloc */
  var f = NumberFormat.currency(locale: 'eu', decimalDigits: 0,name: ''); /* Formato nunero */
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); /* Controlador Scaffold */
  String textoOrden = "Más relevantes";
  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orden = Orden.relevantes;
  }

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
                            width: width*0.3,
                            child: AutoSizeText("Filtrar por:",style: TextStyle(color: Colors.grey[800],fontSize: 16,fontWeight: FontWeight.w400,),)
                        ),
                        GestureDetector(
                          onTap: (){
                            publicacionesBloc.activarEvento.add(LimpiarFiltros());
                            publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.relevantes));

                            setState(() {
                              publicacionesBloc;
                              rangomaximo.text = '';
                              rangominimo.text = '';
                              orden = Orden.relevantes;
                              textoOrden = "Más relevantes";
                            });

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width*0.13,top: height*0.01),
                            height: height*0.03,
                            width: width*0.25,
                            child: AutoSizeText("Limpiar filtros",style: TextStyle(color: Colors.blue,fontSize: 13),textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ExpansionTile(
                    key: GlobalKey(),
                    iconColor: Colors.blue,
                    title: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: width*0.4),
                          height: height*0.023,
                          width: width*0.25,
                          child: AutoSizeText("Ordenar por:",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: width*0.3),
                          height: height*0.02,
                          width: width*0.35,
                          child: StreamBuilder(
                            stream: publicacionesBloc.ordenStream,
                            builder: ( _ , AsyncSnapshot  <Orden> _orden){
                              final orden = _orden.data ?? [];


                              switch(orden) {
                                case Orden.relevantes: {
                                  textoOrden = "Más relevantes";
                                }
                                break;

                                case Orden.menorprecio: {
                                  textoOrden = "Menor precio";
                                }
                                break;

                                case Orden.mayorprecio: {
                                  textoOrden = "Mayor precio";
                              }
                              break;

                              case Orden.menosvendidos: {
                                textoOrden = "Menos vendidos";
                              }
                              break;

                              case Orden.masvendidos: {
                                textoOrden = "Más vendidos";
                              }
                              break;

                            }
                              return  AutoSizeText(textoOrden,style: TextStyle(color: Colors.blue,fontSize: 12),);
                            },
                          ),

                        )
                      ],
                    ),
                    children: <Widget>[
                      ListTile(
                        onTap: (){
                          publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.relevantes));
                          setState(() {
                            publicacionesBloc;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.03,
                              width: width*0.435,
                              child: AutoSizeText('Más relevantes',style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.13),
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
                                      setState(() {
                                        publicacionesBloc;
                                      });
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
                          setState(() {
                            publicacionesBloc;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.03,
                              width: width*0.48,
                              child: AutoSizeText('Menor precio',style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.085),
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
                                      setState(() {
                                        publicacionesBloc;
                                      });
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
                          setState(() {
                            publicacionesBloc;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.03,
                              width: width*0.4,
                              child: AutoSizeText('Mayor precio',style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.165),
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
                                      setState(() {
                                        publicacionesBloc;
                                      });
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
                          publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.menosvendidos));
                          setState(() {
                            publicacionesBloc;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.03,
                              width: width*0.4,
                              child: AutoSizeText('Menos vendidos',style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.165),
                              height: height*0.027,
                              width: width*0.06,
                              child: StreamBuilder(
                                stream: publicacionesBloc.ordenStream,
                                builder: ( _ , AsyncSnapshot  <Orden> _orden){

                                  final orden = _orden.data ?? [];

                                  return  Radio(
                                    hoverColor: Colors.blue,
                                    activeColor: Colors.blue,
                                    value: Orden.menosvendidos,
                                    groupValue: orden,
                                    onChanged: (value) {
                                      publicacionesBloc.activarEvento.add(ActualizarOrden(orden: value));
                                      setState(() {
                                        publicacionesBloc;
                                      });
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

                          publicacionesBloc.activarEvento.add(ActualizarOrden(orden: Orden.masvendidos));
                          setState(() {
                            publicacionesBloc;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width*0.03),
                              height: height*0.03,
                              width: width*0.4,
                              child: AutoSizeText('Más vendidos',style: TextStyle(fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width*0.165),
                              height: height*0.027,
                              width: width*0.06,
                              child: StreamBuilder(
                                stream: publicacionesBloc.ordenStream,
                                builder: ( _ , AsyncSnapshot  <Orden> _orden){

                                  final orden = _orden.data ?? [];

                                  return  Radio(
                                    hoverColor: Colors.blue,
                                    activeColor: Colors.blue,
                                    value: Orden.masvendidos,
                                    groupValue: orden,
                                    onChanged: (value) {
                                      publicacionesBloc.activarEvento.add(ActualizarOrden(orden: value));
                                      setState(() {
                                        publicacionesBloc;
                                      });
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
                                setState(() {
                                  publicacionesBloc;
                                });
                              },
                              title: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: width*0.03),
                                    height: height*0.02,
                                    width: width*0.3,
                                    child: AutoSizeText(toBeginningOfSentenceCase(_condicion.data[i]),style: TextStyle(fontWeight: FontWeight.w400),),
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
                                            setState(() {
                                              publicacionesBloc;
                                            });
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
                                child: AutoSizeText("Condicion",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: width*0.1),
                                height: height*0.02,
                                width: width*0.5,
                                child:  StreamBuilder(
                                  stream: publicacionesBloc.filtros,
                                  builder: ( _ , AsyncSnapshot  <List<String>> _filtros){

                                    final filtros = _filtros.data ?? [];

                                    return  AutoSizeText(filtros.toString().replaceAll("[", '').replaceAll("]", '') ==null  ? "" : filtros.toString().replaceAll("[", '').replaceAll("]", ''),style: TextStyle(color: Colors.blue,fontSize: 12),);
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
                          child: AutoSizeText("Rango de precio",style: TextStyle(color: Colors.grey[800],fontSize: 13),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: width*0.1),
                          height: height*0.02,
                          width: width*0.5,
                          child:
                          StreamBuilder(
                            stream: publicacionesBloc.getRangoPrecios.asBroadcastStream(),
                            builder: ( _ , AsyncSnapshot <String> _rango){

                                final rango = _rango.data ?? [];

                                  if(rango=="[]"){
                                    print("xD");
                                  }

                                return AutoSizeText(rango.toString(),style: TextStyle(color: Colors.blue,fontSize: 12),);
                            },
                          ),
                        )
                      ],
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  // color: Colors.blue,
                                  height: height*0.025,
                                  width: width*0.2,
                                  margin: EdgeInsets.only(top: height*0.01,right: width*0.05),
                                  child: AutoSizeText("Minimo",style: TextStyle(color: Colors.grey[700],fontSize: 11),),
                                ),
                                Container(
                                    height: height*0.07,
                                    width: width*0.25,
                                    child:
                                    TextFormField(
                                      controller: rangominimo,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        ThousandsFormatter()
                                      ],
                                      onChanged: (min){

                                          if(min==''){
                                            rangominimo.text = "0";
                                          }

                                           publicacionesBloc.activarEvento.add(FiltrarPrecioMinimo(preciominimo: int.parse(rangominimo.text.replaceAll(',', ''))));

                                          if(min==''){
                                            rangominimo.text = "";
                                          }

                                          setState(() {
                                            publicacionesBloc;
                                          });
                                      },
                                      decoration: InputDecoration(
                                        hintText: '\$ 15.000',
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Container(width: width*0.15,),
                            Column(
                              children: [
                                Container(

                                  height: height*0.025,
                                  width: width*0.2,
                                  margin: EdgeInsets.only(top: height*0.01,right: width*0.05),
                                  child: AutoSizeText("Máximo",style: TextStyle(color: Colors.grey[700],fontSize: 11),),
                                ),
                                Container(
                                    height: height*0.07,
                                    width: width*0.25,
                                    child:TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: rangomaximo,
                                            inputFormatters: [
                                              ThousandsFormatter(),
                                            ],
                                            onChanged: (max){
                                              if(max==''){
                                                rangomaximo.text = "10,000,000";
                                                max = "10,000,000";
                                              }

                                              publicacionesBloc.activarEvento.add(FiltrarPrecioMaximo(preciomaximo:  int.parse(rangomaximo.text.replaceAll(',', ''))));

                                              if(rangomaximo.text=="10,000,000"){
                                                rangomaximo.text = "";
                                              }

                                              setState(() {
                                                publicacionesBloc;
                                              });

                                            },
                                            decoration: InputDecoration(
                                              hintText: '\$ 35.000',
                                            ),
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
              expandedHeight: height*0.1575,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Container(
                      height: height*0.053,
                      color: Colors.yellow,
                    ),
                    Container(
                      height: height*0.05,
                      color: Colors.yellow,
                      child: Container(
                        margin: EdgeInsets.only(left: width*0.1,right: width*0.1),
                        child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Colors.grey,
                          onChanged: (busqueda){
                            publicacionesBloc.activarEvento.add(Buscador(busqueda: busqueda));
                            setState(() {
                              publicacionesBloc;
                            });
                          },
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only( bottom: height*0.017, top: 11, right: 15),
                              hintText: 'Buscar en Mercado Libre',
                              focusColor: Colors.blue,
                              labelStyle: TextStyle(color: Colors.grey[600],fontSize: 11),
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                              icon: Container(child: Icon(Icons.search,color: Colors.grey,),margin: EdgeInsets.only(left: width*0.02))
                          ),
                        ),
                        decoration: BoxDecoration (
                            borderRadius: BorderRadius.all( Radius.circular(30)),
                            color: Colors.white
                        ),
                      ),
                    ),
                    Container(
                      height: height*0.0353,
                      color: Colors.yellow,
                    ),
                    Container(
                      height: height*0.054,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color:Colors.grey,width: 1)
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: width*0.03,top: 5),
                              height: height*0.027,
                              //color: Colors.blue,
                              width: width*0.4,
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
                              margin: EdgeInsets.only(left: width*0.315,),
                              height: height*0.04,
                              width: width*0.25,
                              child: Center(
                                  child: AutoSizeText("Filtrar (3)",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,)
                              ),
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
              builder: ( _ , AsyncSnapshot <List<Publicacion>> _publicaciones){

                final publicaciones = _publicaciones.data ?? [];

                return  SliverFixedExtentList(
                  itemExtent: _publicaciones.hasData ? height*0.21:height*0.8,
                  delegate: _publicaciones.hasData ? SliverChildBuilderDelegate(

                    (BuildContext context, int index) {

                      return ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VistaPublicacion(id:publicaciones[index].id)),
                            );
                          },
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        //color: Colors.grey[500],
                                        image: DecorationImage(image: NetworkImage(publicaciones[index].thumbnail),fit: BoxFit.contain)
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
                                            height: height*0.05,
                                            width: width*0.6,
                                            // color:Colors.white,
                                            child: AutoSizeText(publicaciones[index].title,style: TextStyle(fontSize: 14),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.02,right: width*0.02,top: height*0.005),
                                            height: height*0.03,
                                            width: width*0.6,
                                            child: AutoSizeText("\$ "+f.format(publicaciones[index].price).toString(),style: TextStyle(fontSize: 20),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.002),
                                            height: height*0.02,
                                            width: width*0.6,
                                            //color:Colors.white,
                                            child: AutoSizeText(publicaciones[index].condition,style: TextStyle(fontSize: 14,color: Colors.blue),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                            height: height*0.021,
                                            width: width*0.6,
                                            //color:Colors.red,
                                            child: AutoSizeText(publicaciones[index].available_quantity.toString()+" disponibles",style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                            height: height*0.021,
                                            width: width*0.6,
                                            // color:Colors.red,
                                            child: AutoSizeText(publicaciones[index].sold_quantity.toString()+" vendidos",style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.02,right: width*0.02, top: height*0.005),
                                            height: height*0.024,
                                            width: width*0.6,
                                            child:
                                            StreamBuilder(
                                              stream: publicacionesBloc.getTipos,
                                              builder: ( _ , AsyncSnapshot  <List<Tipo>> _tipos){

                                                final tipos = _tipos.data ?? [];

                                                String text = "";

                                                for (var i = 0; i < tipos.length; i++) {
                                                      if(publicaciones[index].listing_type_id == tipos[i].id){
                                                        text = tipos[i].name;
                                                      }
                                                }

                                                return  AutoSizeText(text,style: TextStyle(fontSize: 14,color: Colors.grey[700]),);
                                              },
                                            ),
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
                  ) : SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue,),);
                      },
                      childCount: 1
                  ),
                );
              },
            )
          ],
        )
    );
  }
}