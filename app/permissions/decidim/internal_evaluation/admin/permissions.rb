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
          user_evaluator_role.present? && evaluator_assigned_to_proposal?
        end

        def proposal
          @proposal ||= context.fetch(:proposal, nil)
        end

        def can_access?
          permission_action.subject == :internal_evaluation &&
            permission_action.action == :read
        end

        def user_evaluator_role
          @user_evaluator_role ||= space.user_roles(:evaluator).find_by(user:)
        end

        def evaluator_assigned_to_proposal?
          @evaluator_assigned_to_proposal ||=
            Decidim::Proposals::EvaluationAssignment
            .where(proposal:, evaluator_role: user_evaluator_role)
            .any?
        end
      end
    end
  end
end
