# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    # Abstract class from which all models in this engine inherit.
    class InternalEvaluation < ::Decidim::InternalEvaluation::ApplicationRecord
      include Decidim::TranslatableResource

      belongs_to :internal_state, foreign_key: "decidim_proposal_state_id", class_name: "Decidim::Proposals::ProposalState", optional: true
      belongs_to :proposal, foreign_key: "decidim_proposal_id", class_name: "Decidim::Proposals::Proposal"
      belongs_to :author, foreign_key: "decidim_author_id", class_name: "Decidim::User"

      translatable_fields :body
    end
  end
end
