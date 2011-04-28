class Post < ActiveRecord::Base
	belongs_to :researcher
	validates :researcher, :presence => true
	has_many :comments

	def self.per_page
		20
	end

	def self.search(search, page)
		paginate :per_page => self.per_page, :page => page,
			:conditions => ['title like ?', "%#{search}%"],
			:order => 'updated_at DESC'
	end
end
