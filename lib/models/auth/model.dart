class AuthData {
  String? clientId;
  String? clientSecret;
  String? redirectUri;
  String? code;
  String? grantType;

// AuthData(
//     {this.clientId,
//     this.clientSecret,
//     this.redirectUri,
//     this.code,
//     this.grantType});

/*
  AuthData.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientSecret = json['client_secret'];
    redirectUri = json['redirect_uri'];
    code = json['code'];
    grantType = json['grant_type'];
  }
  */

/*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['client_secret'] = this.clientSecret;
    data['redirect_uri'] = this.redirectUri;
    data['code'] = this.code;
    data['grant_type'] = this.grantType;
    return data;
  }
*/
}

class Auth {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  String? scope;
  int? createdAt;

  Auth(
      {this.accessToken,
        this.tokenType,
        this.refreshToken,
        this.scope,
        this.createdAt});

  Auth.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    scope = json['scope'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['refresh_token'] = refreshToken;
    data['scope'] = scope;
    data['created_at'] = createdAt;
    return data;
  }
}
