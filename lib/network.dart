import 'dart:async';
import 'package:flutter_mate/constants.dart';
import 'package:flutter_mate/github-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mate/usermodel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Network {
  // helper singleton class for fetching users
  static final Network _singleton = Network._internal();
  FirebaseUser _user;

  FirebaseUser get user => _user;

  factory Network() {
    return _singleton;
  }

  Network._internal();

  Future<bool> loginWithGitHub(String code) async {
    print("called loginWithGithub");
    //ACCESS TOKEN REQUEST
    final response = await http.post(
      "https://github.com/login/oauth/access_token",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: github_id,
        clientSecret: github_secret,
        code: code,
      )),
    );
    GitHubLoginResponse loginResponse =
        GitHubLoginResponse.fromJson(json.decode(response.body));

    print(loginResponse);
    //FIREBASE STUFF: user credential from GitHub login
    final AuthCredential credential = GithubAuthProvider.getCredential(
      token: loginResponse.accessToken,
    );
    //user we got from using our credential
    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    _user = user;
    //user created successfully
    //send to server

    print("===========================");
    print("=====FIREBASE LOGIN========");
    print(user.providerData.toString());
    final serverResponse = await http.post(serverId + "/signup", headers: {
      "authorisation": await user.getIdToken(),
    });
    print("sent post to server");
    print("===========================");
    print("===========================");
    print(serverResponse.statusCode);

    return (serverResponse.statusCode == 200);
    // if (serverResponse.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<List<User>> getFeed() async {
    final response = await http.get(serverId + "/team", headers: {
      "authorisation": await user.getIdToken(),
    });
    // gets User list from server
    Iterable l = json.decode(response.body);
    List<User> users = l.map((model) => User.fromJson(model)).toList();
    return users;
  }
}
