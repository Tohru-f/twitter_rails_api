# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # entrieモデルと異なり、複合ユニークは実装しない。同じユーザーが同じグループで投稿することは何度も発生するため。

  # 空文字は許容しない
  validates :content, presence: true
end
