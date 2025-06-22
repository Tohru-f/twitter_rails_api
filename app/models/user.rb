# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :tweets, dependent: :destroy
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true
  validates :birthday, presence: true
  # validates :name, presence: true, length: {in: 1..50}, default: "" プロフィール機能実装まではコメントアウト
  # validates :profile, length: {in: 1..160} プロフィール機能実装まではコメントアウト

  # 引数authから取得したproviderとuidを持つユーザーを探し、存在すればそのユーザーデータを使用し、
  # 存在しなければ、google側から取得したデータを元にユーザーを新しく生成する
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = 'password'
      user.name = auth.info.name
      user.phone_number = '090-1234-5678'
      user.birthday = '20250101'
    end
  end
  include DeviseTokenAuth::Concerns::User
end
