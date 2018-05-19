import 'package:flutter/material.dart';
import '../conection/api.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  List listAnimes = new List();

  ConnectApi repositorio = new ConnectApi();

  @override
  Widget build(BuildContext context) {
    
    loadAnimes(); //chama o metodo que carrega a lista de animes.

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _bildList()
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.check),
          backgroundColor: Colors.lightBlue,
          onPressed: (){
            loadAnimes();
          }
      ),
    );
  }


 /* Função que chama o repositório que nos retornará a resposta da api.
 * Observe que a função possue um "async" isso pq ele vai ser executado assincrono por conta
 * do repositório que tb nos responde de forma assincrona pq temos que esperar a resposta, por isso o "await"
 * antes do "repositorio.loadAnimes()".
 * */
  void loadAnimes() async{

    Map map = await repositorio.loadAnimes();

    //print(map);
    //print('Nome primeiro anime: ${map['data'][0]['name']}');

    setState(() {
      listAnimes = map['data'];
    });

  }

/*
* Cria uma listView pegando cada elemento a lista, chamando no retorno um metodo que monda os cards
*/
  Widget _bildList() {
    ListView listView = new ListView.builder(
      itemCount: listAnimes.length,
      itemBuilder: (context, index){
        Map anime = listAnimes[index];

        return _layoutCarAnime(anime);
      }
    );

    return new Flexible(
      child: listView
    );
  }

 Widget _layoutCarAnime(anime){
   return new Container(
     margin: const EdgeInsets.all(0.5),
     child: new Card(
       elevation: 2.0,
        child: new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.all(5.0),
              child: new Image.network(
                anime['thumb'],
                width: 600.0,
                height: 160.0,
                fit: BoxFit.cover,
              ),
            ),
            _titleSection(anime),
          ],
        ),
     )
   );
 }

 Widget _titleSection(anime){
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      anime['name'],
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Text(
                    'Descrição',
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
          ),
          new Icon(
            Icons.favorite_border,
            color: Colors.red[500],
          ),
        ],
      ),
    );
 }

// ListTile listTile(anime){
  // return new ListTile(
  //     leading: new Image.network(anime['thumb'],),
  //     title: new Text(anime['name']),
  //   );
  // }

}