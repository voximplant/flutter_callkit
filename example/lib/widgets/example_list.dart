import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';

class ExampleList extends StatelessWidget {
  final String _title;
  final List<String> _items;
  final VoidCallback _addHandler;
  final VoidCallback _doneHandler;
  final void Function(int) _removeHandler;

  const ExampleList({
    super.key,
    required String title,
    required List<String> items,
    required VoidCallback addHandler,
    required void Function(int) removeHandler,
    required VoidCallback doneHandler,
  })  : _title = title,
        _items = items,
        _addHandler = addHandler,
        _removeHandler = removeHandler,
        _doneHandler = doneHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 60),
        Text(
          _title,
          style: const TextStyle(color: CupertinoColors.white, fontSize: 30),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            separatorBuilder: (c, i) => const SizedBox(height: 10),
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
                  style: const TextStyle(
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
        const SizedBox(height: 20),
      ],
    );
  }
}
