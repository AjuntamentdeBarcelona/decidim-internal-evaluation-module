# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A command with all the business logic when a valuator evaluates a proposal.
      class UpdateInternalEvaluation < Decidim::Command
        def initialize(form, evaluation)
          @form = form
          @evaluation = evaluation
        end

        # Updates the status if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_evaluation
          end
          broadcast(:ok)
        end

        private
        attr_reader :form, :evaluation

        def update_evaluation
          Decidim.traceability.update!(
            evaluation,
            form.current_user,
            body: form.body,
            internal_state: form.available_states.find_by(token: form.internal_state)
          )
        end
      end
    end
  end
end
