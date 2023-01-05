module Searchable::RangeFilter
  OPERATORS = { from: :>=, to: :<= }.freeze
  DATE_FIELDS = %i[created_at updated_at discarded_at].freeze

  def range_filter_keys(records)
    range_fields = records.search_fields.filter { |_, value| value == :range }.keys
    range_fields.reduce([]) do |keys, filter|
      keys << OPERATORS.keys.map { |comparison| :"#{filter}_#{comparison}" }
    end.flatten
  end

  def range_filter(records, filters)
    range_filters = filters.slice(*range_filter_keys(records))
    range_filters.reduce(records) do |result, (key, value)|
      range = parse_range_key(key)
      result.where("#{range[:field]} #{range[:operator]}?", format_value(value, value_type(range[:field])))
    end
  end

  def parse_range_key(key)
    parts = key.to_s.rpartition('_').map(&:to_sym)

    {
      field: parts.first,
      operator: OPERATORS[parts.last]
    }
  end

  def format_value(value, type)
    type == :date ? Time.parse(value).utc : value
  end

  def value_type(key)
    :date if DATE_FIELDS.include?(key)
  end
end
