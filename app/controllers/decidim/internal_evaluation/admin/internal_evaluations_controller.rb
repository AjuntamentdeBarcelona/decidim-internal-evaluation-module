# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # This controller allows admins to create internal evaluations on proposals in a participatory space.
      class InternalEvaluationsController < Admin::ApplicationController
        def create
          enforce_permission_to(:create, :internal_evaluation, proposal:)

          @internal_evaluation_form = form(InternalEvaluationForm).from_params(params)

          CreateInternalEvaluation.call(@internal_evaluation_form) do
            on(:ok) do
              flash[:notice] = I18n.t("internal_evaluations.create.success", scope: "decidim.internal_evaluation.admin")
              redirect_to decidim_proposals.proposal_path(id: proposal.id)
            end

            on(:invalid) do
              flash.keep[:alert] = I18n.t("internal_evaluations.create.error", scope: "decidim.internal_evaluation.admin")
              redirect_to decidim_proposals.proposal_path(id: proposal.id)
            end
          end
        end

        def update
          enforce_permission_to(:create, :internal_evaluation, proposal:)

          @internal_evaluation_form = form(InternalEvaluationForm).from_params(params)

          UpdateInternalEvaluation.call(@internal_evaluation_form, internal_evaluation) do
            on(:ok) do
              flash[:notice] = I18n.t("internal_evaluations.update.success", scope: "decidim.internal_evaluation.admin")
              redirect_to decidim_proposals.proposal_path(id: proposal.id)
            end

            on(:invalid) do
              flash.keep[:alert] = I18n.t("internal_evaluations.update.error", scope: "decidim.internal_evaluation.admin")
              redirect_to decidim_proposals.proposal_path(id: proposal.id)
            end
          end
        end

        private

        def permission_class_chain
          [Decidim::InternalEvaluation::Admin::Permissions] + super
        end

        def skip_manage_component_permission
          true
        end

        def decidim_proposals
          Decidim::EngineRouter.admin_proxy(proposal.component)
        end

        def proposal
          @proposal ||= Decidim::Proposals::Proposal.where(component: current_component).find(params[:proposal_id])
        end

        def internal_evaluation
          @internal_evaluation ||= proposal.internal_evaluations.find(params[:id])
        end
      end
    end
  end
end
