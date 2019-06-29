import 'package:herigone_server_dart/model/user.dart';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  Map<int, Agent> agents;

  setUp(() async {
    agents = {};
    for (var i = 0; i < 6; i++) {
      final user = User()
        ..username = "bob+$i@stablekernel.com"
        ..password = "foobaraxegrind$i%";
      agents[i] = await harness.registerUser(user);
    }
  });

  tearDown(() async {
    await harness.resetData();
  });

  test("Can get all users", () async {
    final response = await agents[0].get("/users");
    expect(response, hasStatus(200));
    print("response: ${response.headers.contentLength}");
    expect(response.headers.contentLength, equals(99));
  });

  test("Can get user with valid credentials", () async {
    final response = await agents[1].get("/users/1");
    expect(
        response,
        hasResponse(200,
            body: partial({"username": "bob+0@stablekernel.com"})));
  });

  test("Getting user fails when id does not exist", () async {
    final response = await agents[2].get("/users/7");
    expect(response, hasResponse(404));
  });

  test("Updating user fails if not owner", () async {
    final response =
        await agents[4].put("/users/1", body: {"username": "a@a.com"});
    expect(response, hasStatus(401));
  });
}
