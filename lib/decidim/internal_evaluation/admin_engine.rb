# frozen_string_literal: true

require "deface"

module Decidim
  module InternalEvaluation
    # This is the engine that runs on the public interface of `InternalEvaluation`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::InternalEvaluation::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      initializer "decidim_internal_evaluation.admin_mount_routes" do
        Decidim::Proposals::AdminEngine.class_eval do
          routes do
            resources :proposals, only: [] do
              resources :internal_evaluations, only: [:create, :update], controller: "/decidim/internal_evaluation/admin/internal_evaluations"
            end
          end
        end
      end

      initializer "decidim_internal_evaluation.filters" do
        Decidim.admin_filter(:proposals) do |filter|
          user = if ransack_params[:valuator_role_ids_has].present?
                   Decidim::Proposals::ValuationAssignment.find_by(valuator_role_id: ransack_params[:valuator_role_ids_has])&.valuator
                 else
                   current_user
                 end
          if user.present? && Decidim::Proposals::ValuationAssignment.joins(proposal: :component).where(proposal: { component: current_component }).exists?(
            valuator_role: current_participatory_space.user_roles("valuator").where(user:)
          )
            filter.add_filters(:evaluated_by_user)
            filter.add_filters_with_values(evaluated_by_user: %w(true false))
          end
        end
      end

      initializer "decidim_internal_evaluation.proposals_admin_controller_additions" do
        config.to_prepare do
          Decidim::Proposals::Admin::ProposalsController.include(Decidim::InternalEvaluation::Admin::ProposalsControllerAdditions)
        end
      end

      initializer "decidim_internal_evaluation.proposal_states_admin_controller_additions" do
        config.to_prepare do
          Decidim::Proposals::Admin::ProposalStatesController.include(Decidim::InternalEvaluation::Admin::ProposalStatesControllerAdditions)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
