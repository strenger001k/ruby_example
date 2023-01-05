class SearchModel < ApplicationRecord
  self.abstract_class = true
  extend Searchable

  def self.search_fields
    raise NotImplementedError
  end

  def self.search_from
    raise NotImplementedError
  end

  def self.select_fields
    raise NotImplementedError
  end
end
