class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :blogs, dependent: :destroy

  validates :email, uniqueness: true

  def generate_token
    @token = User.generate_unique_secure_token
    update(authentication_token: @token)
  end
end
