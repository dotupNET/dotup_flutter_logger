import 'dart:collection';

class ListStack<T> with ListMixin<T> {
  late final List<T> _items = [];
  int _size;
  int get size => _size;

  ListStack(this._size);

  // @override
  int get length => _items.length;

  @override
  T operator [](int index) {
    return _items.elementAt(index);
  }

  @override
  void add(T element) {
    if (_items.length >= _size) {
      _items.removeLast();
    }
    _items.insert(0, element);
  }

  @override
  void operator []=(int index, T value) {
    if (index > _size) {
      throw RangeError('List is limited to $_size entries.');
    } else {
      _items[index] = value;
    }
  }

  @override
  set length(int newLength) {
    _size = newLength;
    while (_items.length > _size) {
      _items.removeLast();
    }
  }
}
