import 'package:key/src/aes_decrypt.dart';
import 'package:dio/dio.dart';

// sources =
//     "UT2UGIAD2FsdGVkX19SCQEPj8WgHIN7zvvDsBHLNpz1k8LP9b/iCA20fiKUHmKzqVEvh0FcBKv9AJzlJ3DwEykLJPFr0xpLEqZh1sG7I5osJAsQRMSMj8iJI9OV41GXOU5qNAkdwsnTa/SdHpN81eslIic7XQAejB+G1apnZuBVcOyDMNn/Y2mXqek80mUrU0RsAk3lKkhAoQbSuuP/l9KeFpsdg1RaPRUOm8CeBfrquUREf6RLlkpCIKkluWJx7/X3xODCXZT31lTJqaZC3aPfZQltZtbMKXXE25do4WQfBcKJ3AKE+PxD0IrkzgsWLAWkyxawtH/Gq2baguM+7jnOYgcrqBdO5/U9Gc388WeZETz8AfxbZxedyooYz640bQJxW6W3CSLIpJ60lpZUu+MuOas/NpLsTiDvPPUn8+tacbDfvX46hX5BRtgUDE5uVFm3uBxAvEjaKWPeo6a3kXxopFfjc8rb/4iqUokiteFkhv2yw==";
// List<String> responses = [
//   "UT2UGIAD2FsdGVkX18aivjFWJ41HIN7zvdbLp1glbK3jmzK7ZuFwUiATGVoteBOuLnNJDi4aKv9AJzhS6RBszOtjR815QuFDwZh1sG7IgdAggKfBcJ8DAhznDhpWJ9JVl0umEt9Gs/WUXGs0qPZIvfqPb46YD7JHu7oCQx5xdpIyz9rNpGB5dWJw8nIrulFNTdKQ2BXm/6Xlmf3v9AgPx6SocrXzb3PjEZqqsXO94a/FSBFnEz1CZVWl8LLI+e68QkXjeYiTZRo8I8w4yX8vZSPWlJ2nw06n1eYfavo/+r2UisiLHgXLRO/y0BV5QZBOenIeOgFg5wXockbf/KTYsVvYeauOdQbv1BjqEfLl+XxpUY10vHtzpmlrbdURWOYZ9fDVziZ+8X5z+oYrTUQ5Ar/TQEd50/poG/m0WPpqrjCb1xP7I/GpPzXiQLU8kPi7LPb83sJruSJ/sSzmXNJtLZLGHXhY5pqqw7cIt+UB98d4FC2g==",
//   "UT2UGIAD2FsdGVkX1/52WU99y09HIN7zvZulU+i6wCdtSP9NNK5w7bh/owm1xFTJgUlSCcKfKv9AJzVN5E6eMrjnjcY8mkWLRZh1sG7IoK2aiMqxaFrjpTaKbTDn7/3tAMnbjs5rZ+bdyuxNZMNPuxFmpFrys5c6AgDKiUXSbZ9qrrNJ8dwEcUX2HoWea96UQGOVKv7//KjDkDBphqidWwiMz8o9wLXQcIRXtgLSAVgJ1BaND0LNbrjPG8ugv58e2/R0L+6x6U+O81RYJ1jMRAYsoAbIpEvgmsLvWwpd0CzsUGodkriN9nFWMhxdhh1UKWuUhFelhUqhG++DeTTHBm3aGLOYy1utg3Tq1QXdcrdkkE2/PWZp148r75DOF1j8Bv9R9wyBaK1A1HU9VfbrzU3aq0O7texAxNNcYGHghVxRDX35EWC8COiTQGjSK/BsZXj1QUIPCmQVR7izVUBne9Y6RA8bzAxUz2cMpHRtWdREPTiA==",
//   "UT2UGIAD2FsdGVkX1/+M1Vnpi60HIN7zvUyD5b56kW2v3VBce3I1eE8OeeYx6lZAcT2Ltlf4Kv9AJz5BoGbBvJ0YQpcPil3asZh1sG7IjLQVzMOfIZjVbpXDHIPo6k60I9PhdGjlGssjEATJsrwRbqBF0eF4bECedpzuVX+oMJ1W++Z1wtbCrNA8ME3JPENqBDsrcbhKxVdOW4BBkGKZLrXrrFmMhhKQIgovcdmLE6qOchFtBIq0yAapeYj9uJBQg0kfm46vaLx+idGU1gO2xDKo1rfiTMFM4wqHL7dLhj4d/rWQ0UzqqackIdiF6iPPJ2gCLtwBwVi0kriNTfhxix4mp+27w1UVryKBZ65uYkJEeGeNLXmNTM8coBEbYKjZTvaUDVZht87WF8zLu9BZHPVT6ErSSJCh0UMcORewRZdBV9+wYaqUuIoEN5gJr+9/UZn9NR75K+XqTeQBIWKoVJh3bkqyKTZEC0VXOr/2qexN96zg==",
//   "UT2UGIAD2FsdGVkX18dVaayXFb4HIN7zvRx06m9jOcXX6hwc0lqJzicMaYjr+6rZIMaaLU+BKv9AJzsHlKZTq2VmYGa5usmX5Zh1sG7Ii+GdiSuj7jl/POwQNzJxJVV0mVmdu+Kncnrz6jTSDBUBsuV3q5Xfpvpr8aNkMQO5cg3C94kmWmd/Ojpjga/NOWnUYDzqsnuHfDbnl8x8ftVLIxeNsWUiS2Nl87C339MikjBJ/3HNkyNSKkhR/kOQMA64T5xHdjxR2vtKDlVM3sGc/5gWwZsP8CGc2o8XILzgh8NFx5y3F1tFRj4Mb0gAHcUqTqvrYhrtqqRA1wMyfFKlg0i1kaLlEJq4anPQDv26FcNBujLpKkWZgQwWzXxvNCiC8VdH8gyQXaQjaChzrW+eMKzEs3su6hYkOSVUg9iNgyev/+4kgVoS7HYOGCKErv1xE6SvNPcIda9Am1Tzmm00LLgRuZYtBS3V9u6gTs88cG/X+JFg==",
// ];

const String salt = "U2FsdGVkX1";
final Map key = {};
int retries = 0;

Future<String> getSource(final String link, String sources, bool clear) async {
  int o = 0;
  if (clear || key.isEmpty) {
    key.clear();
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
    if (retries == 1) {
      print(responses);
    }
    key.addAll(sources.split('').asMap());
    for (int i = 0; i < responses.length; i++) {
      key.removeWhere(
          (key, value) => value != responses[i][key] || value == '=');
    }
    for (int i = 0; i < salt.length; i++) {
      if (salt[i] == key.values.elementAt(o)) {
        key.remove(key.keys.elementAt(o));
      } else {
        o++;
        i--;
      }
    }
  }
  print(key.values.join());
  o = 0;
  for (final i in key.keys) {
    sources = sources.replaceRange(i - o, i + 1 - o, '');
    o++;
  }
  return decrypt(
    sources,
    key.values.join(),
  );
}
