# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module Admin
      module ProposalsControllerAdditions
        extend ActiveSupport::Concern

        included do
          helper_method :internal_evaluation_form, :evaluation_assignments, :internal_evaluations, :internal_evaluations_query, :reordered_evaluation_assignments

          delegate :internal_evaluations, to: :proposal

          def internal_evaluation_form
            @internal_evaluation_form ||= if current_user_evaluation.present?
                                            form(Decidim::InternalEvaluation::Admin::InternalEvaluationForm).from_model(current_user_evaluation)
                                          else
                                            form(Decidim::InternalEvaluation::Admin::InternalEvaluationForm).instance
                                          end
          end

          def internal_evaluations_query
            @internal_evaluation_query ||= internal_evaluations.ransack(ransack_params, search_context: :admin, auth_object: current_user)
          end

          def evaluation_assignments
            @evaluation_assignments ||= proposal.evaluation_assignments.includes(:evaluator_role, proposal: :internal_evaluations)
          end

          def reordered_evaluation_assignments
            return evaluation_assignments if ransack_params.blank?

            partial_ordered_assignments = evaluation_assignments.to_a.in_order_of(:evaluator, internal_evaluations_query.result.map(&:author))

            return evaluation_assignments if partial_ordered_assignments.blank?

            partial_ordered_assignments + (evaluation_assignments - partial_ordered_assignments)
          end

          private

          def ransack_params
            query_params[:q] || {}
          end

          def query_params
            params.permit(q: {}).to_h.deep_symbolize_keys
          end

          def current_user_evaluation
            @current_user_evaluation ||= proposal.internal_evaluations.find_by(author: current_user)
          end
        end
      end
    end
  end
end
