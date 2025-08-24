# frozen_string_literal: true

module AuthorizationHelper
  def sign_in(user)
    # 引数で受け取ったユーザーデータを使ってログインする。
    post '/api/v1/auth/sign_in/', params: { email: user.email, password: user.password }, as: :json
    # ヘッダーデータの中でclient, access-token, uidのみを切り出す
    response.headers.slice('client', 'access-token', 'uid')
  end
end
