# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      class ProposalStatesExtraPermissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin

          return permission_action unless user&.admin?

          if permission_action.subject == :proposal_state && permission_action.action == :destroy && Decidim::InternalEvaluation::InternalEvaluation.exists?(internal_state:)
            disallow!
          end

          permission_action
        end

        private

        def internal_state
          @internal_state ||= context.fetch(:proposal_state, nil)
        end
      end
    end
  end
end
