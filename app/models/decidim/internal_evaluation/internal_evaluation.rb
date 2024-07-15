# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    # Abstract class from which all models in this engine inherit.
    class InternalEvaluation < ::Decidim::InternalEvaluation::ApplicationRecord
      belongs_to :internal_state, foreign_key: "decidim_proposal_state_id", class_name: "Decidim::Proposals::ProposalState", optional: true
      belongs_to :proposal, foreign_key: "decidim_proposal_id", class_name: "Decidim::Proposals::Proposal"
      belongs_to :author, foreign_key: "decidim_author_id", class_name: "Decidim::User"

      class << self
        def sort_by_state_asc
          sort_by_state("ASC")
        end

        def sort_by_state_desc
          sort_by_state("DESC")
        end

        private

        def sort_by_state(keyword)
          return if %w(ASC DESC).exclude?(keyword)

          states = Decidim::Proposals::ProposalState.arel_table
          field = Arel::Nodes::InfixOperation.new("->>", states[:title], Arel::Nodes.build_quoted(I18n.locale))
          joins(:internal_state).order(Arel::Nodes::InfixOperation.new("", field, Arel.sql(keyword)))
        end
      end
    end
  end
end
