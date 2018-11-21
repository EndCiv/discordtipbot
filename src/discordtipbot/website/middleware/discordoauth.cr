class DiscordOAuth2
  def initialize(client_id : String, client_secret : String,
                 redirect_uri : String)
    @client = OAuth2::Client.new("discordapp.com/api/v6",
      client_id,
      client_secret,
      authorize_uri: "/oauth2/authorize",
      redirect_uri: redirect_uri)
  end

  def authorize_uri(scope)
    @client.get_authorize_uri(scope)
  end

  def get_access_token(params)
    @client.get_access_token_using_authorization_code(params["code"])
  end

  def get_user(access_token)
    client = HTTP::Client.new("discordapp.com", tls: true)
    OAuth2::AccessToken::Bearer.new(access_token, nil, nil, nil, nil).authenticate(client)

    raw_json = client.get("/api/v6/users/@me").body

    Discord::User.from_json(raw_json)
  end
end
