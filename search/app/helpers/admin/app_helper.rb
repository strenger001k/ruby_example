# frozen_string_literal: true

module Admin
  module AppHelper
    DEFAULT_INPUT_OPTIONS = { tag: :input }.freeze

    def model_index_url(model)
      polymorphic_url(model.new)
    end
  end
end
