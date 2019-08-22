import 'package:rxdart/rxdart.dart';
import 'package:shopping_cart_rx/src/shopping_cart/models/models.dart';

class ShoppingCartBloc {
  Observable<ShoppingCart> cart;

  final _add = BehaviorSubject<Item>();
  final _cart = BehaviorSubject<ShoppingCart>.seeded(ShoppingCart());
  final _remove = BehaviorSubject<Item>();

  add(Item i) => _add.sink.add(i);
  delete(Item i) => _remove.sink.add(i);

  ShoppingCartBloc() {
    final add = Observable.combineLatest2<Item, ShoppingCart, ShoppingCart>(
        _add, _cart, (a, b) => b..add(a));

    final remove = Observable.combineLatest2<Item, ShoppingCart, ShoppingCart>(
        _remove, _cart, (a, b) => b..remove(a));

    cart = add.mergeWith([remove]).asBroadcastStream();
  }

  void dispose() {
    _add.close();
    _remove.close();
    _cart.close();
  }
}
