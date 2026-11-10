import 'dart:js_interop';
import 'dart:js_interop_unsafe';

JSFunction? _listener;

/// Liga ou desliga o aviso do navegador ao fechar ou recarregar a aba.
void setLeaveWarning(bool enabled) {
  final listener = _listener;
  if (enabled == (listener != null)) return;

  if (listener != null) {
    globalContext.callMethod<JSAny?>('removeEventListener'.toJS, 'beforeunload'.toJS, listener);
    _listener = null;
    return;
  }

  final added = ((JSObject event) {
    event.callMethod<JSAny?>('preventDefault'.toJS);
    event['returnValue'] = ''.toJS;
  }).toJS;
  globalContext.callMethod<JSAny?>('addEventListener'.toJS, 'beforeunload'.toJS, added);
  _listener = added;
}

/// Caminho e busca do endereço que o navegador mostra agora.
String? browserLocation() {
  final location = globalContext.getProperty<JSObject>('location'.toJS);
  final path = location.getProperty<JSString>('pathname'.toJS).toDart;
  final search = location.getProperty<JSString>('search'.toJS).toDart;
  return '$path$search';
}
