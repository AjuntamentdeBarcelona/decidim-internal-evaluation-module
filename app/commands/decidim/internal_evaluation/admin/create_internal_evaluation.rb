# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # A command with all the business logic when a valuator evaluates a proposal.
      class CreateInternalEvaluation < Decidim::Command

        # Initializes the command.
        # @param form [Decidim::Form] the form object to create the resource.
        def initialize(form)
          @form = form
        end

        # Creates the result if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          create_record

          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_record
          evaluation = Decidim.traceability.create!(
            Decidim::InternalEvaluation::InternalEvaluation,
            form.current_user,
            body: form.body,
            internal_state: form.available_states.find_by(token: form.internal_state),
            proposal:,
            author: form.current_user
          )
        end
        #
        # def extra_params
        #   { resource: { title: proposal.title } }
        # end


      end
    end
  end
end
