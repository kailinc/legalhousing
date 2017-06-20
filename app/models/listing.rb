class Listing < ApplicationRecord
	has_many :phrase_listings
	has_many :phrases, through: :phrase_listings

  def illegal?
    Phrase.all.each do |phrase|
      if self.description.match(/#{phrase.content}/i)
				PhraseListing.find_or_create_by(listing_id: self.id, phrase_id: phrase.id)				
				self.save
        return true
      end
    end
  return false
  end

  def check_phrase(phrase)
    regex = phrase.strip.gsub(' ','\s')
    reg_obj = Regexp.new(/#{regex}/i)
    if reg_obj.match(self.description)
      true
    else
      false
    end
  end

	def self.set_discriminatory
		Listing.all.each do |listing|
			listing.illegal?
		end
	end
	
  def self.discriminatory
    Listing.all.select {|listing| listing.discriminatory == true}
  end

	def self.num_listings
		Listing.all.count
	end
	
	def self.num_discriminatory
		Listing.discriminatory.count
	end
end
