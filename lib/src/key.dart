import 'package:aniwatch/src/aes_decrypt.dart';
import 'package:dio/dio.dart';

const String salty = 'U2FsdGVkX1';
final Map zorokey = {};

Future<String> getSource(final String link, String sources) async {
  if (zorokey.isEmpty) {
    final List<String> responses = await Future.wait(
      [
        for (int i = 0; i < 4; i++)
          Dio()
              .get(
                link,
              )
              .then((value) => value.data['sources']),
      ],
    );
    for (int s = 0; s < sources.length; s++) {
      if (sources[s] == responses[0][s] && sources[s] != '=') {
        zorokey[s.toString()] = responses[0][s];
      }
    }
    for (int i = 1; i < responses.length; i++) {
      zorokey.removeWhere(
          (key, value) => zorokey[key] != responses[i][int.parse(key)]);
    }
  }
  try {
    int o = 0;
    for (final i in zorokey.entries) {
      sources = sources.replaceRange(
          int.parse(i.key) - o, int.parse(i.key) + 1 - o, '');
      o++;
    }
    return decrypt(
      '$salty$sources',
      remove(salty, zorokey.values.join(''))!,
    );
  } catch (_) {
    print(_);
    zorokey.clear();
    return await getSource(link, sources);
  }
}

String? remove(final String salt, String key) {
  if (key.startsWith(salt)) {
    return key.replaceRange(0, salt.length, '').replaceFirst(
        salty.substring(salty.length - salt.length, salty.length), '');
  } else {
    remove(salt.substring(0, salt.length - 1), key);
  }
}
