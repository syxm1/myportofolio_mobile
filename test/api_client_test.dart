import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  const project = Project(
    id: null,
    title: 'Portfolio',
    description: 'Example',
    techStack: 'Flutter',
    projectUrl: 'https://example.com',
    projectImageUrl: '',
  );

  test(
    'token login, project POST, and logout send the required requests',
    () async {
      final paths = <String>[];
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((request) async {
          paths.add(request.url.path);
          expect(request.method, 'POST');
          if (request.url.path.endsWith('/auth/token/')) {
            expect(jsonDecode(request.body), {
              'username': 'user',
              'password': 'password',
            });
            return http.Response('{"token":"abc"}', 200);
          }
          expect(request.headers['authorization'], 'Token abc');
          if (request.url.path.endsWith('/auth/logout/')) {
            return http.Response('', 204);
          }
          expect(request.headers['content-type'], contains('application/json'));
          expect(jsonDecode(request.body)['tech_stack'], 'Flutter');
          return http.Response(
            jsonEncode({'id': 'test-id', ...project.toJson()}),
            201,
          );
        }),
      );

      final token = await client.obtainToken('user', 'password');
      expect(token, 'abc');
      final created = await client.createProject(project, token: token);
      expect(created.id, 'test-id');
      await client.logout(token: token);
      expect(paths, [
        '/api/v1/auth/token/',
        '/api/v1/projects/',
        '/api/v1/auth/logout/',
      ]);
      client.close();
    },
  );

  test(
    'logout clears local token when the server rejects revocation',
    () async {
      final client = ApiClient(
        baseUrl: 'https://example.com',
        client: MockClient((_) async => http.Response('invalid token', 401)),
      );
      final auth = AuthState(client, initialToken: 'old-token');
      await expectLater(auth.logout(), throwsA(isA<ApiException>()));
      expect(auth.isLoggedIn, isFalse);
      expect(auth.token, isNull);
      auth.dispose();
      client.close();
    },
  );
}
