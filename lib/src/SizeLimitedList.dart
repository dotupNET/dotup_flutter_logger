import 'dart:collection';

class SizeLimitedList<T> with ListMixin<T> {
  SizeLimitedList({required int size, reverse = false})
      : _size = size,
        _reverse = reverse;

  late final List<T> _items = [];
  int _size;
  final bool _reverse;

  bool _checkSize = true;

  int get size => _size;

  @override
  int get length => _items.length;

  @override
  T operator [](int index) {
    return _items.elementAt(index);
  }

  @override
  void add(T element) {
    if (_checkSize && _items.length > _size) {
     _reverse == true ? _items.removeLast(): _items.removeAt(0);
    }
    if (_reverse) {
      _items.insert(0, element);
    } else {
      _items.add(element);
    }
  }

  @override
  void operator []=(int index, T value) {
    if (index > _size) {
      throw RangeError('List is limited to $_size entries.');
    } else {
      _items[index] = value;
    }
  }

  void setSize(int newSize) {
    _size = newSize;
    while (_items.length > _size) {
      _items.removeLast();
    }
  }

  void changeCheckSize(bool value) {
    _checkSize = value;
  }

  @override
  set length(int newLength) {
    _items.length = newLength;
  }
}
