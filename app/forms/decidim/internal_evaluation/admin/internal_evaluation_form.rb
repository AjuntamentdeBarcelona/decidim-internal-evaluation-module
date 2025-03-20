# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A form object to be used when evaluator users want to evaluate a proposal.
      class InternalEvaluationForm < Decidim::Form
        include TranslatableAttributes

        attribute :body, String
        attribute :internal_state, String

        validates :internal_state, presence: true, inclusion: { in: :states_tokens }
        validates :body, presence: true

        def map_model(model)
          self.internal_state = model.internal_state&.token
        end

        def available_states
          Decidim::Proposals::ProposalState.where(component: current_component)
        end

        def internal_state
          super || states_tokens.first
        end

        private

        def states_tokens
          available_states.pluck(:token).map(&:to_s)
        end
      end
    end
  end
end
