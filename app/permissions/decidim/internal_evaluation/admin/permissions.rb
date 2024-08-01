# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin

          allow! if permission_action.subject == :internal_evaluation && permission_action.action == :create && can_evaluate_proposal?

          return permission_action unless user&.admin?

          allow! if can_access?

          permission_action
        end

        private

        def can_evaluate_proposal?
          user_valuator_role.present? && valuator_assigned_to_proposal?
        end

        def proposal
          @proposal ||= context.fetch(:proposal, nil)
        end

        def can_access?
          permission_action.subject == :internal_evaluation &&
            permission_action.action == :read
        end

        def user_valuator_role
          @user_valuator_role ||= space.user_roles(:valuator).find_by(user:)
        end

        def valuator_assigned_to_proposal?
          @valuator_assigned_to_proposal ||=
            Decidim::Proposals::ValuationAssignment
            .where(proposal:, valuator_role: user_valuator_role)
            .any?
        end
      end
    end
  end
end
