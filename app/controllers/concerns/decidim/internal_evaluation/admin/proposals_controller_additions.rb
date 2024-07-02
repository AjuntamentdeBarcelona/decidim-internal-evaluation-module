# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module InternalEvaluation
    module Admin
      module ProposalsControllerAdditions
        extend ActiveSupport::Concern

        included do
          helper_method :internal_evaluation_form, :valuation_assignments

          def internal_evaluation_form
            @internal_evaluation_form ||= if current_user_evaluation.present?
                                            form(Decidim::InternalEvaluation::Admin::InternalEvaluationForm).from_model(current_user_evaluation)
                                          else
                                            form(Decidim::InternalEvaluation::Admin::InternalEvaluationForm).instance
                                          end
          end

          def valuation_assignments
            @valuation_assignments ||= proposal.valuation_assignments.includes(:valuator_role, proposal: :internal_evaluations)
          end

          private

          def current_user_evaluation
            @current_user_evaluation ||= proposal.internal_evaluations.find_by(author: current_user)
          end
        end
      end
    end
  end
end
