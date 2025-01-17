import 'package:flutter/material.dart';
import 'package:flutter_mate/network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mate/usermodel.dart';
import 'package:url_launcher/url_launcher.dart';

// TextStyles for cards to be displated
TextStyle nameStyle =
    TextStyle(color: Colors.purple[700], fontSize: 28.0, fontFamily: 'Oxygen');
TextStyle usernameStyle =
    TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'Oxygen');
TextStyle aboutStyle =
    TextStyle(color: Colors.black87, fontSize: 17.0, fontFamily: 'Oxygen');
TextStyle headStyle =
    TextStyle(color: Colors.blueGrey, fontFamily: 'Oxygen', fontSize: 16.0);
TextStyle genericStyle = TextStyle(fontSize: 15.0);

/*FirebaseUser user = Network().user;

String githubName = user.displayName;
String imagePath = user.photoUrl;*/
//String username = Network().getUsername();

class ProfileCard extends StatelessWidget {
  final User snapshot;

  ProfileCard(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 420.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(116, 235, 213, 0.7),
                      Color.fromRGBO(172, 182, 229, 0.7),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60.0,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          new NetworkImage(snapshot.data['picture']),
                      radius: 72,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 8.0),
                      child: InkWell(
                        child: Text(
                          snapshot.data['name'],
                          style: nameStyle,
                          overflow: TextOverflow.fade,
                        ),
                        onTap: () async {
                          if (await canLaunch("https://github.com/" + snapshot.data['username'])) {
                            await launch("https://github.com/" + snapshot.data['username']);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Text(
                        snapshot.data['username'].toString(),
                        style: usernameStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Followers",
                                style: headStyle,
                              ),
                              Text(
                                snapshot.data['followers'].toString(),
                                style: headStyle,
                              ),
                            ],
                          ),
                          Text(
                            "|",
                            style: TextStyle(
                                fontSize: 24.0, color: Colors.blueGrey[300]),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Following",
                                style: headStyle,
                              ),
                              Text(
                                snapshot.data['following'].toString(),
                                style: headStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        //boxShadow: Box,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      height: 300,
                      width: 340,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26.0, vertical: 2.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 32.0, horizontal: 4.0),
                                child: Text(
                                  snapshot.data['bio'],
                                  style: aboutStyle,
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18.0, horizontal: 4.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Repos: ", style: genericStyle,),
                                      Text(
                                        snapshot.data['repos'].toString(),
                                        style: aboutStyle,
                                      ),
                                      VerticalDivider(
                                        width: 20,
                                      ),
                                      Text(
                                        "Compatibility Index: ",
                                        style: genericStyle,
                                      ),
                                      Text(
                                        snapshot.compatibility,
                                        style: aboutStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
