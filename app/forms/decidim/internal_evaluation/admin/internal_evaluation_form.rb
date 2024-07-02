# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A form object to be used when valuator users want to evaluate a proposal.
      class InternalEvaluationForm < Decidim::Form
        include TranslatableAttributes
        mimic :movidita

        translatable_attribute :body, String
        attribute :internal_state, String

        validates :internal_state, presence: true, inclusion: { in: :states_tokens }
        validates :body, translatable_presence: true

        def map_model(model)
          self.internal_state = model.internal_state.token
        end

        def available_states
          Decidim::Proposals::ProposalState.where(component: current_component)
        end

        private

        def states_tokens
          available_states.pluck(:token).map(&:to_s)
        end
      end
    end
  end
end
