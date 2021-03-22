///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXTransaction from iOS CallKit Framework.
///
/// An object that contains zero or more action objects to be performed
/// by a call controller.
class FCXTransaction {
  /// The unique identifier of the transaction.
  final String uuid;

  /// Whether all actions have been completed.
  final bool complete;

  /// The list of actions contained by the transaction.
  Future<List<FCXAction>> getActions() async {
    try {
      var data = await (_methodChannel.invokeListMethod<Map>(
          '$_TRANSACTION.getActions', {'transactionUuid': uuid}) as FutureOr<List<Map<dynamic, dynamic>>>);
      _FCXLog._i('${runtimeType.toString()}.getActions');
      List<FCXAction> actions = [];
      for (Map map in data) {
        FCXAction? action = _FCXActionMapDecodable._makeAction(map);
        if (action == null) {
          _FCXLog._w('${runtimeType.toString()} failed to decode action: $map');
        } else {
          actions.add(action);
        }
      }
      return actions;
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  FCXTransaction._fromMap(Map<dynamic, dynamic> data)
      : this.uuid = data['uuid'],
        this.complete = data['complete'];
}
