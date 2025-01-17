// GITHUB REQUEST-RESPONSE MODELS
class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest({this.clientId, this.clientSecret, this.code});
  // convert to JSON
  dynamic toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
      };
}

class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  String rawResponse;

  GitHubLoginResponse(
      {this.accessToken, this.tokenType, this.scope, this.rawResponse});
  // create response from JSON we get
  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      GitHubLoginResponse(
          accessToken: json["access_token"],
          tokenType: json["token_type"],
          scope: json["scope"],
          rawResponse: json.toString());

  @override
  String toString() {
    return rawResponse;
  }
}
