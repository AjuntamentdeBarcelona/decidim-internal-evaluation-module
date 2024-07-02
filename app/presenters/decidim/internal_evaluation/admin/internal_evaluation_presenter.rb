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
          decidim_sanitize_editor_admin(translated_attribute(body))
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
