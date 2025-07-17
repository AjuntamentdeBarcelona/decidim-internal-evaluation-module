# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    class InternalEvaluationSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper
      include HtmlToPlainText

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      # Serializes an internal evaluation
      def serialize
        {
          id: resource.id || "",
          created_at: resource.created_at || "",
          status: resource.internal_state.present? ? translated_attribute(resource.internal_state.title) : "",
          text: resource.body.present? ? convert_to_text(resource.body) : "",
          evaluator_name: resource.author.name || "",
          proposal_id: proposal.id || "",
          proposal_title: translated_attribute(proposal.title) || "",
          proposal_description: convert_to_text(translated_attribute(proposal.body)) || "",
          scope: translated_attribute(proposal.scope&.name) || "",
          category: translated_attribute(proposal.category&.name) || ""
        }
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      private

      def proposal
        @proposal ||= resource.proposal
      end
    end
  end
end
