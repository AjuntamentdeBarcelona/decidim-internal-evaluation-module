# frozen_string_literal: true

require "spec_helper"

describe "Admin manages proposals states" do
  include_context "when managing a component as an admin" do
    let!(:component) { create(:proposal_component, participatory_space:) }
  end

  describe "deleting a proposal state" do
    let(:state_params) do
      {
        title: { "en" => "Editable state" },
        announcement_title: { "en" => "Editable announcement title" },
        token: "editable",
        bg_color: "#EBF9FF",
        text_color: "#0851A6"
      }
    end
    let!(:state) { create(:proposal_state, component: current_component, **state_params) }
    let!(:valuator_role) { create(:participatory_process_user_role, role: :valuator, user:, participatory_process:) }
    let!(:assigned_proposal) { create(:proposal, component: current_component) }
    let!(:valuation_assignment) { create(:valuation_assignment, proposal: assigned_proposal, valuator_role:) }

    before do
      click_on "Statuses"
    end

    it "deletes the proposal state" do
      within "tr", text: translated(state.title) do
        accept_confirm { click_on "Delete" }
      end
      expect(page).to have_admin_callout("successfully")

      state = Decidim::Proposals::ProposalState.find_by(token: "editable")

      expect(state).to be_nil
    end

    it "does not delete the proposal state if there are proposals attached" do
      proposal = create(:proposal, component: current_component, state: state.token)

      visit current_path
      expect(state.reload.proposals).to include(proposal)
      expect(state.proposals_count).to eq(1)
      within "tr", text: translated(state.title) do
        expect(page).to have_no_link("Delete")
      end
    end

    it "does not delete the proposal state if there are internal evaluations attached" do
      create(:internal_evaluation, proposal: assigned_proposal, author: user, internal_state: state, body: "Great proposal!")

      visit current_path
      expect(assigned_proposal.reload.internal_evaluations.where(internal_state: state).count).to eq(1)
      within "tr", text: translated(state.title) do
        expect(page).to have_no_link("Delete")
      end
    end
  end
end
