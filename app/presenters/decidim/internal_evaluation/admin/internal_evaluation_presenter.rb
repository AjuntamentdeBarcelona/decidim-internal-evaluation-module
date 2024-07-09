# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      #
      # Decorator for proposal internal evaluations
      #
      class InternalEvaluationPresenter < SimpleDelegator
        include Decidim::Proposals::ApplicationHelper
        include ActionView::Helpers
        include Decidim::SanitizeHelper

        def update_date
          I18n.l(updated_at, format: :decidim_short)
        end

        def formatted_body
          return "" if body.blank?

          default_body = decidim_sanitize_editor_admin(translated_attribute(body))

          return default_body if decidim_sanitize(default_body, strip_tags: true).present?

          alternative_body = body.except(I18n.locale.to_s).values.map { |value| decidim_sanitize(value, strip_tags: true) }.find(&:presence)

          return "" if alternative_body.blank?

          decidim_sanitize_editor_admin(translated_attribute(alternative_body))
        end

        def state_css_class
          proposal_state_css_class(state_proposal)
        end

        def state_css_style
          proposal_state_css_style(state_proposal)
        end

        def state_title
          translated_attribute(internal_state.title)
        end

        private

        def state_proposal
          @state_proposal ||= Decidim::Proposals::Proposal.new(proposal_state: internal_state)
        end

        def safe_content?
          true
        end
      end
    end
  end
end
