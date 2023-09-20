import 'package:key/src/aes_decrypt.dart';
import 'package:dio/dio.dart';

const String salty = 'U2FsdGVkX1';
final Map zorokey = {};
int retries = 0;

Future<String> getSource(final String link, String sources) async {
  print(zorokey.isEmpty);
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
    if (retries == 1) {
      print(responses);
    }
    // sources =
    //     "U2Fsl7n4VJdGVkKguWpmX1+4t7wj9S77897LE8qiZnXrVZ94CexHnkVtSKFfFNo8B+O1HdcBi5qYbyTM/gEAaibXZYZ0MH2jNOIwVzWr1uXsPPOBYY0fSgAhGezKkQBcOWWpjR72jKTc+3lk7/IbKKXukbC3WWvtqCZ18nwQk5UMkP1SUCSm/x/qOwUQrvkG/wF/z3RH0P+VP/9sPW5+vqwghRXRqBXsV8zFpU9SY/qmOGB9SdrxcTyVOXI1p6KlhZwtadt1fNv6ozUhKpEfcAW6P2E/UAU45/8O7j28aPV08GuTpzyHhKPl6L51RL/huLoosrsmYBF116dYLuhnbhAt/Glg9E/j9iTBQI9LTDx8Z0cKGLQOxu/fpTEhSAktSAYSJLpchrWyVqW8lXGVrBiVoNUuNHpCwdGidW+tbiBQzk0QLUfopPgKdXykCk7A1MKIiTqUcr59UoaDHr5IIXTZn92P6MYneYYErNGAio7W2rZw==";
    // List<String> responses = [
    //   "U2Fsl7n4VJdGVkKguWpmX1/v7jHpZW0Nb2vr8H19BSGeneEojoCWIMHWkrWURqfL4YcZUH5UZpIAFVCS82egNJCyZxvxdLUQPz4TIa/61uXsPPOfPE138QYQ8ezKkQBcUSe1sScjpKSFC5gGjA/aLmTlHHrzWBsMeAPnBH4nq/Ze4T36lMUOKW8uzYJUKRHKsXprViiLXReGuuwAmcx8E3bLXqcn2hehz3DkoeMUjBsGXgCfo8xCv0diJan3wcMY4gOcZfLpdACqY1R8UQtZ9JkZeLBqT8zI2H7QAxDQlsDlXa0KlguBJOj33EFWpfyfN4tkEhVIp+bwxZCfy1rAfPc2M6b11BNzkHQ4+eEOqj+35IK2dvA+foKzaHbaIOG/w2IQbaBse98XJgjUMq6OagvGpMYi6qsGnVejogSmMTUBk7rvtte2uBxZlXJ8N6qiTb/8rh3qh04Arx7oyi/EuiaGh0Y86JFcS2mNC4GaVjX+oqrQ==",
    //   "U2Fsl7n4VJdGVkKguWpmX18Ln/tuwliASfuq6iUgH0KNjKHX4heN052AVcDDrwJjAiwC42BDj//7SaS8LUjCmmOHwE14qjhCgdqSk5br1uXsPPOabh3cZI9vEezKkQBcFeeqOhSE3DpfKEGMv5rM8dCGzsEqS30k6o7lswwlPNlwa27P1gS9fQqdVHoAttqjjNJ9c3V2gOH0SPbU7n9/Pv56rpU7aVcESep09/AVtKmlQFSjZOSyQ6Vhr9GPM1YAZqL/hmX0dwt0EocPeZWycESyPE25m1ryB5Zwg9r4/8X09muDGSKyI52kDm4PMZFGlKxQ2rnAEMNik1OAIuRtl10wNt08MK9cyPzvqZFkZ8fR+wBWG3BYeBOv80JL+7ClzUK3u1NnnsR+ZrF5OpZrwHvtnwM6SHINOrS2WrhiD0TdUaZaKqJWMODW1dVbc1R/vixSvZ6wEg/nJMj58Zc+uHGRWUo4HA/NuMs5GCJ/UQiMIQWA==",
    //   "U2Fsl7n4VJdGVkKguWpmX18cYXB6NtLeY0zqWCSYFMw02t5jP42wrhZZ7vXaKtbGPyYnjqHi2JFqK+Y8p8PteKhUAIL7i0OYCXS5QQvk1uXsPPO9t2PHe0sv9ezKkQBcLjqex/5OM0Ve5yAw4wgsBHONn+f5DlaWmF8SzPSwxrjgCZLGnqOsYhY5ngiepKk+uACHEraHBgy6CrNg2oKjWGmoZbvqdTdEWFl3mpW3TAJW7nUo/xT0i+ekE8RPfdCXLnt8Q5wSdC59aIps6YWV5kL41Ix0f3QlrmhIAVcVocIgKHnrzsQtpsGrb4lUKbqg9y+CNWmP1IF8OyCuysnQzAZ33/pos3MrZDSmBTaiMJIs7kyZyHtuVBjpy7TxOjPli7PD0rS10EJpeer/+N/aPu15DvTDLMk9b1QqMaoLzAKRQCTM4R5+bqVDsrF9r+9YjYSSr3Yl3+rX60DodywZFsiq2WPxxO4mMtijpKPRBuuWD3Ow==",
    //   "U2Fsl7n4VJdGVkKguWpmX1+Fm4LWdlmSolN0sQxcvWP838DyswNVlFSyM2WATDEk0pZpdKxAh3D9Iok1ngYFEvTa6BamJq3Qn6yDT6HA1uXsPPOh4Juv+IX/OezKkQBciuaETVY21exkdzfOisa61F+ADS1LUS2KrnYYN/Ge2D003cgDw4ijEfYcFXaNEV2Gf2kXjXWpD+CZQrGn/h8KaQIpxAmdMkVFLJ+bbGXDUTK0N3xN4GYCdqHZ4Z1ZmchhuZRk2MTss3uwZKn2o46KEzxQK4Q7qxUIgjuSzk+/nvkjPR3KFXqvBaN8yH7v/c1dzEJswls0dJzs6wJjRXnN4/9Oe54A8Be52sClb7t8cPScscunODx+wCNoTmnIkHcd8EHv3x/c7uyhNW2wbTJD+FcYrVHmfuBOz5+NdoGRxECHvRcRcPQcBTxnLszaoTdFa/U4gSjr9e3Z0fXnqaRlJWRyQyAxzype+dWn0jQsmlgIpzSw==",
    //   'U2Fsl7n4VJdGVkKguWpmX1/Bw5Gj4Qp6BZmxRlfPhZouhKsuEEYwWbu6BW7+GS22LQn19PO28B9ZXoTRyNGBuO4/kC7RbarWxrNfuRH/1uXsPPOA4nAx/7Bz6ezKkQBcqydN4Xby7kdukOvWbOJH/bJQaFo/QM9XmXG8SA5S8cWyabLu+WarsDsm5WA49j51Dwwn9Kq260RoAfCF8qHafcJFSy2SyCIteUoZm+dNYU+YxqJw6Mj/n4F/Dk3wBAhPbqO9QGEipk+c2kXzmaY4/EHqv4Vt/ShB+izR/2x7a0k3dRppQ7gf1r98K9h26FtW4NRu+K1rg4CUwA3r8H3H1TrDGORAFnx4FwW7HmIHn/SNY9RqUS3NtkXcHTSzFccC8dTGrAVMs7n76n4W6s23JfvCHcdjKdY+m7zTA6biADLEp9suk0Va18CtjayPQibTRK1y4Goj09LHsyuBq6+O/ZFG2I35Ah7ok89hQ28dOw3huoNA==',
    // ];
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

  int o = 0;
  final String temp = sources;
  for (final i in zorokey.entries) {
    sources = sources.replaceRange(
        int.parse(i.key) - o, int.parse(i.key) + 1 - o, '');
    o++;
  }

  try {
    return decrypt(
      '$salty$sources',
      remove(salty, zorokey.values.join(''))!,
    );
  } catch (_) {
    print(_);
    zorokey.clear();
    if (retries < 1) {
      retries++;
      return await getSource(link, temp);
    } else {
      return '';
    }
  }
}

String? remove(String salt, String key) {
  if (key.startsWith(salt)) {
    print(key);
    key = key.replaceFirst(salt, '');
    salt = salty.substring(salt.length);
    for (int i = 0; i < salt.length; i++) {
      key = key.replaceFirst(salt[i], '');
    }
    print(key);
    return key;
  } else {
    return remove(salt.substring(0, salt.length - 1), key);
  }
}
