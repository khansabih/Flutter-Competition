import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'writeDetails.dart';
class homePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new homePageState();
  }
}
class homePageState extends State{
  Widget listItem(DocumentSnapshot snap)
  {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('\n${snap['n']}\nrecommends...\n',style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(crossAxisAlignment:CrossAxisAlignment.stretch,children: <Widget>[
          Image(image: CachedNetworkImageProvider(snap['r'])),
          Text('\n${snap['d']}\n')],),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 3)]),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>writeDetails()));
        },child: Icon(Icons.add),backgroundColor: Colors.red),
        appBar: AppBar(
          title: Text("What's New",style: TextStyle(color: Colors.white,fontSize: 35)),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('posts').snapshots(),
            builder: (context,snapshot)
            {
              if(snapshot.hasData)
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index)=>listItem(snapshot.data.documents[index])
              );
              else Container();
            }
        ),
      ),
    );
  }
}