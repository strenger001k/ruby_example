module Searchable::Order
  def search_order(filters)
    order_by = filters[:order_by] ? filters[:order_by] : self.primary_key
    order_dir = filters[:order_dir] ? filters[:order_dir] : :asc

    sanitized_params = sanitize_sql_for_order({ order_by => order_dir })

    order(sanitized_params)
  end
end
