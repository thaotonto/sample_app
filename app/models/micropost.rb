class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
   length: {maximum: Settings.micropost.content_maximum}
  validate :picture_size
  scope :order_micropost, ->{order created_at: :desc}
  following_ids = "SELECT followed_id FROM relationships
    WHERE follower_id = :user_id"
  scope :feed_microposts, (lambda do |id|
    where "user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id
  end)

  private

  def picture_size
    return if picture.size < Settings.micropost.picture_size.megabytes
    errors.add :picture, I18n.t("micropost.picture_size_error")
  end
end
