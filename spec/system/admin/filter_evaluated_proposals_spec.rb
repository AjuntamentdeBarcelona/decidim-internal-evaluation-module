# frozen_string_literal: true

require "spec_helper"

describe "Admin filters evaluated proposals" do
  # include_context "when admin manages proposals"

  let(:manifest_name) { "proposals" }
  let!(:assigned_proposal_evaluated) { create(:proposal, component: current_component) }
  let!(:assigned_proposal_not_evaluated) { create(:proposal, component: current_component) }
  let!(:unassigned_proposal) { create(:proposal, component: current_component) }
  let(:model_name) { Decidim::Proposals::Proposal.model_name }
  let(:resource_controller) { Decidim::Proposals::Admin::ProposalsController }

  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:valuator_user) { create(:user, organization:) }
  # let!(:user) { admin }
  let!(:valuator_role) { create(:participatory_process_user_role, role: :valuator, user: valuator_user, participatory_process:) }
  let!(:another_user) { create(:user, organization:) }
  let!(:another_valuator_role) { create(:participatory_process_user_role, role: :valuator, user: another_user, participatory_process:) }
  let!(:user_valuation_assignment) { create(:valuation_assignment, proposal: assigned_proposal_evaluated, valuator_role:) }
  let!(:user_valuation_assignment2) { create(:valuation_assignment, proposal: assigned_proposal_not_evaluated, valuator_role:) }
  let!(:another_user_valuation_assignment) { create(:valuation_assignment, proposal: assigned_proposal_evaluated, valuator_role: another_valuator_role) }
  let!(:another_user_valuation_assignment2) { create(:valuation_assignment, proposal: assigned_proposal_not_evaluated, valuator_role: another_valuator_role) }
  let!(:valuator_user_evaluation) { create(:internal_evaluation, proposal: assigned_proposal_evaluated, author: valuator_user) }
  let!(:another_user_evaluation) { create(:internal_evaluation, proposal: assigned_proposal_evaluated, author: another_user) }

  include_context "when managing a component as an admin"
  include_context "with filterable context"

  context "when filtering by evaluation status" do
    before { visit_component_admin }

    context "when admin is not valuator" do
      it "does not show the evaluation filter" do
        within(".filters__section") do
          find_link("Filter").hover
          within ".submenu" do
            expect(page).to have_no_content("Evaluation")
          end
        end
      end

      context "when admin filters by valuator" do
        before do
          apply_filter "Assigned to valuator", another_user.name
        end

        it "shows the evaluation filter" do
          within(".filters__section") do
            find_link("Filter").hover
            within ".submenu" do
              expect(page).to have_content("Evaluation")
            end
          end
        end

        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Evaluated" do
          let(:in_filter) { translated(assigned_proposal_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_not_evaluated.title) }
        end

        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Not evaluated" do
          let(:in_filter) { translated(assigned_proposal_not_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_evaluated.title) }
        end
      end
      # it_behaves_like "a filtered collection", options: "Answered", filter: "Answered" do
      #   let(:in_filter) { translated(answered_proposal.title) }
      #   let(:not_in_filter) { translated(unanswered_proposal.title) }
      # end
    end

    context "when admin is valuator" do
      let!(:valuator_user) { user }

      it "shows the evaluation filter" do
        within(".filters__section") do
          find_link("Filter").hover
          within ".submenu" do
            expect(page).to have_content("Evaluation")
          end
        end
      end

      context "and filters by admin as valuator" do
        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Evaluated" do
          let(:in_filter) { translated(assigned_proposal_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_not_evaluated.title) }
        end

        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Not evaluated" do
          let(:in_filter) { translated(assigned_proposal_not_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_evaluated.title) }
        end
      end

      context "when admin filters by valuator" do
        before do
          apply_filter "Assigned to valuator", another_user.name
        end

        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Evaluated" do
          let(:in_filter) { translated(assigned_proposal_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_not_evaluated.title) }
        end

        it_behaves_like "a filtered collection", options: "Evaluation", filter: "Not evaluated" do
          let(:in_filter) { translated(assigned_proposal_not_evaluated.title) }
          let(:not_in_filter) { translated(assigned_proposal_evaluated.title) }
        end
      end
    end

    # context "when filtering proposals by Not answered" do
    #   it_behaves_like "a filtered collection", options: "Answered", filter: "Not answered" do
    #     let(:in_filter) { translated(unanswered_proposal.title) }
    #     let(:not_in_filter) { translated(answered_proposal.title) }
    #   end
    # end
  end
end
