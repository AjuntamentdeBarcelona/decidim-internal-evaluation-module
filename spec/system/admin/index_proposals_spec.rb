# frozen_string_literal: true

require "spec_helper"

describe "Index proposals" do
  let(:manifest_name) { "proposals" }
  let!(:assigned_proposal) { create(:proposal, component: current_component) }
  let!(:unassigned_proposal) { create(:proposal, component: current_component) }
  let(:participatory_process) { create(:participatory_process, :with_steps, organization:) }
  let(:participatory_space_path) do
    decidim_admin_participatory_processes.edit_participatory_process_path(participatory_process)
  end
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }
  let!(:user) { create(:user, organization:) }
  let!(:valuator_role) { create(:participatory_process_user_role, role: :valuator, user:, participatory_process:) }
  let!(:another_user) { create(:user, organization:) }
  let!(:another_valuator_role) { create(:participatory_process_user_role, role: :valuator, user: another_user, participatory_process:) }
  let!(:user_valuation_assignment) { create(:valuation_assignment, proposal: assigned_proposal, valuator_role:) }
  let!(:another_user_valuation_assignment) { create(:valuation_assignment, proposal: assigned_proposal, valuator_role: another_valuator_role) }

  include Decidim::ComponentPathHelper

  include_context "when managing a component as an admin"

  context "when in the proposal index" do
    context "and no evaluations are created" do
      before do
        visit current_path
      end

      it "shows a column with zero evaluations count" do
        expect(page).to have_css("td.valuators-count", text: "0 / 2")
      end
    end

    context "and there are evaluations" do
      let!(:evaluation) { create(:internal_evaluation, proposal: assigned_proposal, author: user) }

      before do
        visit current_path
      end

      it "shows a column with zero evaluations count" do
        expect(page).to have_css("td.valuators-count", text: "1 / 2")
      end
    end
  end
end
