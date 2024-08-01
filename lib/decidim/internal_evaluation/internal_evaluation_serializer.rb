# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    class InternalEvaluationSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper
      include HtmlToPlainText

      # Serializes an internal evaluation
      def serialize
        {
          id: resource.id,
          created_at: resource.created_at,
          status: translated_attribute(resource.internal_state&.title),
          text: convert_to_text(resource.body),
          evaluator_name: resource.author.name,
          proposal_title: translated_attribute(proposal.title),
          proposal_description: convert_to_text(translated_attribute(proposal.body))
        }
      end

      private

      def proposal
        @proposal ||= resource.proposal
      end
    end
  end
end
