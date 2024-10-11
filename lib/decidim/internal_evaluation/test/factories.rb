# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/proposals/test/factories"

FactoryBot.define do
  factory :internal_evaluation, class: "Decidim::InternalEvaluation::InternalEvaluation" do
    proposal
    author { build(:user, organization: proposal.organization) }
    internal_state { create(:proposal_state, component: proposal.component) }
    body { "<script>alert(\"internal_evaluation_body\");</script> #{generate(:title)}" }
  end
end
