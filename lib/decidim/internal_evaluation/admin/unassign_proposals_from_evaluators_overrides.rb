# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module Admin
      module UnassignProposalsFromEvaluatorsOverrides
        extend ActiveSupport::Concern

        included do
          private

          def unassign_proposals
            transaction do
              form.proposals.flat_map do |proposal|
                form.evaluator_roles.each do |evaluator_role|
                  assignment = find_assignment(proposal, evaluator_role)
                  unassign(assignment) if assignment
                  proposal.internal_evaluations.where(author: evaluator_role.user).destroy_all
                end
              end
            end
          end
        end
      end
    end
  end
end
