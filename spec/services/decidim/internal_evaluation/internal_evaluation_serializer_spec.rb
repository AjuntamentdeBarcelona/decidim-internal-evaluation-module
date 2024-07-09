# frozen_string_literal: true

require "spec_helper"

module Decidim
  module InternalEvaluation
    describe InternalEvaluationSerializer do
      subject do
        described_class.new(internal_evaluation)
      end

      let(:internal_evaluation) { create(:internal_evaluation, body:, internal_state:, proposal:) }
      let(:proposal) { create(:proposal, title: proposal_title, body: proposal_body) }
      let(:internal_state) { create(:proposal_state, component: proposal.component, title: state_title) }
      let(:body) { { en: "The body", es: "El cuerpo" } }
      let(:state_title) { { en: "Accepted", es: "Aceptado" } }
      let(:proposal_title) { { en: "The title", es: "El título" } }
      let(:proposal_body) { { en: "The body", es: "El cuerpo" } }

      describe "#serialize" do
        let(:serialized) { subject.serialize }

        it "serializes the id" do
          expect(serialized).to include(id: internal_evaluation.id)
          expect(serialized).to include(created_at: internal_evaluation.created_at)
          expect(serialized).to include(status: "Accepted")
          expect(serialized).to include(text: "The body")
          expect(serialized).to include(evaluator_name: internal_evaluation.author.name)
          expect(serialized).to include(proposal_title: "The title")
          expect(serialized).to include(proposal_description: "The body")
        end
      end
    end
  end
end
