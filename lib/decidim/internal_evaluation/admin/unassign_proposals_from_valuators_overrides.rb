# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module Admin
      module UnassignProposalsFromValuatorsOverrides
        extend ActiveSupport::Concern

        included do
          private

          def unassign_proposals
            transaction do
              form.proposals.flat_map do |proposal|
                form.valuator_roles.each do |valuator_role|
                  assignment = find_assignment(proposal, valuator_role)
                  unassign(assignment) if assignment
                  proposal.internal_evaluations.where(author: valuator_role.user).destroy_all
                end
              end
            end
          end
        end
      end
    end
  end
end
