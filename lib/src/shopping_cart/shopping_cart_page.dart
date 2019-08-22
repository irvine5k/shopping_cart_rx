import 'package:flutter/material.dart';
import 'package:shopping_cart_rx/src/shopping_cart/models/models.dart';
import 'package:shopping_cart_rx/src/shopping_cart/shopping_cart_bloc.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  ShoppingCartBloc _bloc;

  @override
  void initState() {
    _bloc = ShoppingCartBloc();
    _bloc.cart.listen((data) => data.items.forEach((item) => print(item.name)));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart RX"),
        actions: <Widget>[
          StreamBuilder<ShoppingCart>(
            stream: _bloc.cart,
            builder: (BuildContext context, AsyncSnapshot<ShoppingCart> snapshot) {
              int itemCount = snapshot.hasData ? snapshot.data.items.length : 0;
              return CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("$itemCount"),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text("Smartphone"),
                      onTap: () {
                        final item = Item("Smartphone", 100);
                        _bloc.add(item);
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Notebook"),
                      onTap: () {
                        final item = Item("Notebook", 100);
                        _bloc.add(item);
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Headset"),
                      onTap: () {
                        final item = Item("Headset", 100);
                        _bloc.add(item);
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Cart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<ShoppingCart>(
                stream: _bloc.cart,
                builder: (BuildContext context,
                    AsyncSnapshot<ShoppingCart> snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${snapshot.data.items[index].name}"),
                                onTap: () =>
                                    _bloc.delete(snapshot.data.items[index]),
                              ),
                            );
                          },
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
