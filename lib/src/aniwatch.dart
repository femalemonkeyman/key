import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:tokuwari_models/info_models.dart';
import 'aes_decrypt.dart';

const String zoro = "https://aniwatch.to/";
const String mega = 'https://megacloud.tv/embed-2/ajax/e-1/getSources?id=';
final Map zorokey = {};

Provider zoroList(final AniData data) async {
  final List<MediaProv> episodes = [];
  try {
    final Map response = (await Dio().get(
      '$malsync/${data.malid}',
    ))
        .data;
    final Response html = await Dio().get(
      '${zoro}ajax/v2/episode/list/${response['Sites']['Zoro'].keys.first}',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
    for (Element i in parse(jsonDecode(html.data)['html'])
        .getElementsByClassName('ssl-item  ep-item')) {
      episodes.add(
        MediaProv(
          provider: 'zoro',
          provId: i.attributes['data-id']!,
          title: i.attributes['title']!,
          number: i.attributes['data-number']!,
          call: () => zoroInfo(i.attributes['data-id']),
        ),
      );
    }
    return episodes;
  } catch (e) {
    print(e);
    return [];
  }
}

Anime zoroInfo(final id) async {
  final Options options = Options(responseType: ResponseType.plain);
  final Element server = parse(
    jsonDecode(
      await Dio()
          .get(
            '${zoro}ajax/v2/episode/servers?episodeId=$id',
            options: options,
          )
          .then((value) => value.data),
    )['html'],
  )
      .getElementsByClassName("item server-item")
      .firstWhere((element) => element.text.contains('Vid'));
  try {
    final Map link = jsonDecode(
      await Dio()
          .get(
            '${zoro}ajax/v2/episode/sources?id=${server.attributes['data-id']}',
            options: options,
          )
          .then((value) => value.data),
    );
    final Map<String, dynamic> sources = jsonDecode(
      await Dio()
          .get('$mega${link['link'].split('e-1/')[1].split('?')[0]}',
              options: options)
          .then(
            (value) => value.data,
          ),
    );
    if (sources['encrypted']) {
      sources['sources'] = jsonDecode(
        await getSource(
          '$mega${link['link'].split('e-1/')[1].split('?')[0]}',
          sources['sources'],
        ),
      );
    }
    sources['tracks'].removeWhere((element) => element['kind'] != 'captions');
    return Source(
      qualities: {
        'default': sources['sources'][0]['file'],
      },
      subtitles: {
        for (Map i in sources['tracks']) i['label']: i['file'],
      },
    );
  } catch (e) {
    print(e);
    return const Source(qualities: {}, subtitles: {});
  }
}

Future<String> getSource(final String link, String sources) async {
  if (zorokey.isEmpty) {
    final List<String> responses = await Future.wait(
      [
        for (int i = 0; i < 5; i++)
          Dio()
              .get(
                link,
              )
              .then((value) => value.data['sources']),
      ],
    );
    zorokey
      ..clear()
      ..addAll({
        for (int s = 0; s < responses[0].length; s++)
          if (responses[0][s] == responses[1][s] && responses[0][s] != '=')
            s.toString(): responses[0][s],
      });
    for (int i = 2; i < responses.length - 1; i++) {
      zorokey.removeWhere(
          (key, value) => zorokey[key] != responses[i][int.parse(key)]);
    }
  }
  //try {
  int o = 0;
  for (String i in zorokey.keys) {
    sources = sources.replaceRange(int.parse(i) - o, int.parse(i) + 1 - o, '');
    o++;
  }
  return decrypt(
    'U2FsdGVkX1$sources',
    zorokey.values.join('').replaceAll('U2FsdGVkX1', ''),
  );
  // } catch (_) {
  //   print(_);
  //   zorokey.clear();
  //   return await getSource(link, sources);
  // }
}
