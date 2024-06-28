# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # This controller allows admins to create internal evaluations on proposals in a participatory space.
      class InternalEvaluationsController < Admin::ApplicationController
        helper_method :proposal

        def index; end

        def new; end

        def edit; end

        def create
          # TODO: Pending to implement
          # enforce_permission_to(:create, :internal_evaluation, proposal:)
          # @form = form(InternalEvaluationForm).from_params(params)

          # CreateInternalEvaluation.call(@form, proposal) do
          #   on(:ok) do
          #     flash[:notice] = I18n.t("internal_evaluations.create.success", scope: "decidim.internal_evaluation.admin")
          #     redirect_to proposal_path(id: proposal.id)
          #   end

          #   on(:invalid) do
          #     flash.keep[:alert] = I18n.t("internal_evaluations.create.error", scope: "decidim.internal_evaluation.admin")
          #     redirect_to proposal_path(id: proposal.id)
          #   end
          # end
        end

        def update; end

        private

        def skip_manage_component_permission
          true
        end

        def proposal
          @proposal ||= Proposal.where(component: current_component).find(params[:proposal_id])
        end
      end
    end
  end
end
