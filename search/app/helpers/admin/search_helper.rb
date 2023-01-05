# frozen_string_literal: true

module Admin
  module SearchHelper
    include AppHelper

    SEARCH_TEMPLATE_PATH = 'admin/search'
    SEARCH_TEMPLATES = {
      search: "#{SEARCH_TEMPLATE_PATH}/search",
      input: "#{SEARCH_TEMPLATE_PATH}/input"
    }.freeze

    SEARCH_DATA = {
      order: {
        params: { key: 'order_by', direction: 'order_dir' },
        directions: %i[asc desc]
      },
      range: %i[from to]
    }.freeze

    def search_template(template_name = :search)
      SEARCH_TEMPLATES[template_name]
    end

    def search_form(model, extra_data: {})
      {
        action: model_index_url(model),
        fields: model.search_fields.deep_merge(extra_data),
        updatable_id: model.updatable_id,
        method: :get,
        options: SEARCH_DATA
      }
    end

    private

    def search_filter_keys(fields, range)
      fields.reduce([]) do |list, (key, options)|
        list | (options[:range] ? range.map { |point| "#{key}_#{point}" } : Array(key))
      end
    end
  end
end
