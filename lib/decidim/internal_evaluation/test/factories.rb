# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/proposals/test/factories"

FactoryBot.define do
  factory :internal_evaluation, class: "Decidim::InternalEvaluation::InternalEvaluation" do
    transient do
      skip_injection { false }
    end

    proposal
    author { build(:user, organization: proposal.organization, skip_injection:) }
    internal_state { create(:proposal_state, component: proposal.component, skip_injection:) }
    body do
      if skip_injection
        generate(:title)
      else
        "<script>alert(\"internal_evaluation_body\");</script> #{generate(:title)}"
      end
    end
  end
end
