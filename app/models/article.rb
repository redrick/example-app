class Article < ActiveRecord::Base
  attr_accessible :author_name, :name, :content, :user, :sticky

  has_many :comments
  
  belongs_to :user
  
  before_save { inject_time(:published_at) }
  
  def inject_time(column)
    begin
      self[column] = Time.zone.now
    end while Article.exists?(column => self[column])
  end
end
