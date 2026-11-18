import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:expogeo/core/utils/browser/page_meta_data.dart';

/// Atualiza título, descrição, canonical e Open Graph do documento para a rota atual.
///
/// Fora de produção o `canonical` usa o próprio endereço do ambiente, e a página leva
/// `noindex` (o robots.txt do dev também bloqueia tudo). [PageMeta.noIndex] faz o mesmo em produção.
void applyPageMeta(PageMeta meta, {required bool isProd}) {
  final document = globalContext.getProperty<JSObject>('document'.toJS);
  final origin = isProd
      ? siteOrigin
      : globalContext
            .getProperty<JSObject>('location'.toJS)
            .getProperty<JSString>('origin'.toJS)
            .toDart;
  final url = meta.canonicalUrl(origin);

  document['title'] = meta.title.toJS;
  _setMeta(document, 'meta[name="description"]', 'name', 'description', meta.description);
  _setMeta(document, 'meta[property="og:title"]', 'property', 'og:title', meta.title);
  _setMeta(
    document,
    'meta[property="og:description"]',
    'property',
    'og:description',
    meta.description,
  );
  _setMeta(document, 'meta[property="og:url"]', 'property', 'og:url', url);
  _setMeta(document, 'meta[name="twitter:title"]', 'name', 'twitter:title', meta.title);
  _setMeta(
    document,
    'meta[name="twitter:description"]',
    'name',
    'twitter:description',
    meta.description,
  );
  _setLink(document, 'canonical', url);

  if (isProd && !meta.noIndex) {
    document
        .callMethod<JSObject?>('querySelector'.toJS, 'meta[name="robots"]'.toJS)
        ?.callMethod<JSAny?>('remove'.toJS);
  } else {
    _setMeta(document, 'meta[name="robots"]', 'name', 'robots', 'noindex, nofollow');
  }
}

void _setMeta(JSObject document, String selector, String attr, String key, String content) {
  var element = document.callMethod<JSObject?>('querySelector'.toJS, selector.toJS);
  if (element == null) {
    element = document.callMethod<JSObject>('createElement'.toJS, 'meta'.toJS);
    element.callMethod<JSAny?>('setAttribute'.toJS, attr.toJS, key.toJS);
    document.getProperty<JSObject>('head'.toJS).callMethod<JSAny?>('appendChild'.toJS, element);
  }
  element.callMethod<JSAny?>('setAttribute'.toJS, 'content'.toJS, content.toJS);
}

void _setLink(JSObject document, String rel, String href) {
  var element = document.callMethod<JSObject?>('querySelector'.toJS, 'link[rel="$rel"]'.toJS);
  if (element == null) {
    element = document.callMethod<JSObject>('createElement'.toJS, 'link'.toJS);
    element.callMethod<JSAny?>('setAttribute'.toJS, 'rel'.toJS, rel.toJS);
    document.getProperty<JSObject>('head'.toJS).callMethod<JSAny?>('appendChild'.toJS, element);
  }
  element.callMethod<JSAny?>('setAttribute'.toJS, 'href'.toJS, href.toJS);
}
