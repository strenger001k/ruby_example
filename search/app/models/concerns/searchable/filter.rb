module Searchable::Filter
  include Searchable::RangeFilter

  def search_filter(filters = nil)
    return where(filters) if filters.blank?

    results = filters.symbolize_keys.reduce(self) { |result, (key, value)| apply_filter(result, key, value) }
    range_filter(results, filters)
  end

  private

  def apply_filter(records, key, value)
    filter_method = records.search_fields[key][:condition_type]
    filter_method ? send("#{filter_method}_filter", records, key, value) : records
  end

  def exact_filter(records, key, value)
    records.where(key => value)
  end

  def like_filter(records, key, value)
    key = [records.name.downcase.pluralize, key].join('.')
    records.where("lower(#{key}) like lower(?)", "%#{value}%")
  end
end
