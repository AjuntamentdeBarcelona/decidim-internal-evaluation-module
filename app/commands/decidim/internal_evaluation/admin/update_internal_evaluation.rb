# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A command with all the business logic when a valuator evaluates a proposal.
      class UpdateInternalEvaluation < Decidim::Commands::UpdateResource
        def attributes
          super.merge(
            body: form.body,
            internal_state: form.available_states.find_by(token: form.internal_state)
          )
        end

        def extra_params
          { resource: { title: proposal.title } }
        end
      end
    end
  end
end
