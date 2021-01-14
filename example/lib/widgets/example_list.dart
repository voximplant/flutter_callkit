import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';

class ExampleList extends StatelessWidget {
  final String _title;
  final List<String> _items;
  final Function _addHandler;
  final Function _doneHandler;
  final Function(int) _removeHandler;

  ExampleList({
    @required String title,
    @required List<String> items,
    @required Function addHandler,
    @required Function(int) removeHandler,
    @required Function doneHandler,
  })  : this._title = title,
        this._items = items,
        this._addHandler = addHandler,
        this._removeHandler = removeHandler,
        this._doneHandler = doneHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 60),
        Text(
          _title,
          style: TextStyle(color: CupertinoColors.white, fontSize: 30),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            separatorBuilder: (c, i) => SizedBox(height: 10),
            itemCount: _items.length,
            itemBuilder: (c, i) => CupertinoContextMenu(
              actions: [
                CupertinoContextMenuAction(
                  child: const Text('Remove'),
                  onPressed: () => _removeHandler(i),
                ),
              ],
              child: SizedBox(
                height: 24,
                child: Text(
                  _items[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        ExampleButton('Add number', _addHandler),
        ExampleButton('Done', _doneHandler),
        SizedBox(height: 20),
      ],
    );
  }
}
