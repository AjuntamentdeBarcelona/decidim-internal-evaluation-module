# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    # This is the engine that runs on the public interface of `InternalEvaluation`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::InternalEvaluation::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :proposals, only: [] do
          resources :internal_evaluations, except: [:show, :destroy]
        end
      end

      initializer "decidim_internal_evaluation.admin_mount_routes" do
        Decidim::Proposals::AdminEngine.routes do
          mount Decidim::InternalEvaluation::AdminEngine, at: "/", as: "decidim_admin_internal_evaluation"
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

      def load_seed
        nil
      end
    end
  end
end
