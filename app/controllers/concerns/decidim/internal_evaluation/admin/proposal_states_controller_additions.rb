# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module Admin
      module ProposalStatesControllerAdditions
        extend ActiveSupport::Concern

        included do
          private

          def permission_class_chain
            super + [Decidim::InternalEvaluation::Admin::ProposalStatesExtraPermissions]
          end
        end
      end
    end
  end
end
