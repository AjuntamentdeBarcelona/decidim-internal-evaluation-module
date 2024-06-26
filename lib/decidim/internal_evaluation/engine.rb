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
    end
  end
end
