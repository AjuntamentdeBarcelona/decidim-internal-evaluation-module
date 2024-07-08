# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module InternalEvaluation
    # This is the engine that runs on the public interface of internal_evaluation.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::InternalEvaluation

      routes do
        # Add engine routes here
        # resources :internal_evaluation
        # root to: "internal_evaluation#index"
      end

      initializer "InternalEvaluation.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_internal_evaluation.proposals_search_additions" do
        config.to_prepare do
          Decidim::Proposals::Proposal.include(Decidim::InternalEvaluation::InternalEvaluationAdditions)
          Decidim::Proposals::Proposal.prepend(Decidim::InternalEvaluation::InternalEvaluationOverrides)
        end
      end

      initializer "decidim_internal_evaluation.internal_evaluations_export" do
        Decidim.component_registry.find(:proposals).tap do |component|
          component.exports :internal_evaluations do |exports|
            exports.collection do |component_instance, user|
              Decidim::InternalEvaluation::Export.internal_evaluations_for_resource(
                Decidim::Proposals::Proposal, component_instance, user
              )
            end

            exports.include_in_open_data = true

            exports.serializer Decidim::InternalEvaluation::InternalEvaluationSerializer
          end
        end
      end
    end
  end
end
