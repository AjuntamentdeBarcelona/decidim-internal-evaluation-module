# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A command with all the business logic when a valuator evaluates a proposal.
      class CreateInternalEvaluation < Decidim::Commands::CreateResource
        fetch_form_attributes :body, :internal_state

        def attributes
          super.merge(
            body: form.body,
            internal_state: form.available_states.find_by(token: form.internal_state),
            proposal:,
            author: form.current_user
          )
        end

        def resource_class
          Decidim::InternalEvaluation::InternalEvaluation
        end

        def extra_params
          { resource: { title: proposal.title } }
        end
      end
    end
  end
end
