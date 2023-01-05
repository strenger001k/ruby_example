module Searchable
  include Filter
  include Order

  def search(filters: nil)
    where_filter = filters.except(:order_by, :order_dir)
    order_filter = filters.extract!(:order_by, :order_dir)
    select_fields.search_from.search_filter(where_filter).search_order(order_filter)
  end
end

