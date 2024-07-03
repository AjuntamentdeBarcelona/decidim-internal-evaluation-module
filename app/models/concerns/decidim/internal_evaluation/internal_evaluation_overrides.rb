# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module InternalEvaluationOverrides
      extend ActiveSupport::Concern

      class_methods do
        def ransack(params = {}, options = {})
          return ProposalSearchWithInternalEvaluation.new(self, params.merge("current_user" => options[:auth_object]), options) if options[:search_context] == :admin

          ::Decidim::Proposals::ProposalSearch.new(self, params, options)
        end
      end
    end
  end
end
