// user ID for use with github API
final String github_id = "66f7d8aad0cb41e09026";

final String github_secret = "c1b9b3237caa2db1ea0604268d4cd7e319f33aec";

final String url = "https://github.com/login/oauth/authorize" +
    "?client_id=" +
    github_id +
    "&scope=public_repo%20read:user%20user:email%20user:username";


// location of your backend implementation
final String serverId = "http://192.168.43.186:8000";
