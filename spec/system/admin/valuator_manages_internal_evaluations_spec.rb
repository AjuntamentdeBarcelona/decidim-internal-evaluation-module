# frozen_string_literal: true

require "spec_helper"

describe "Valuator manages internal evaluations" do
  let(:manifest_name) { "proposals" }
  let!(:assigned_proposal) { create(:proposal, component: current_component) }
  let!(:unassigned_proposal) { create(:proposal, component: current_component) }
  let(:participatory_process) { create(:participatory_process, :with_steps, organization:) }
  let(:participatory_space_path) do
    decidim_admin_participatory_processes.edit_participatory_process_path(participatory_process)
  end
  let!(:user) { create(:user, organization:) }
  let!(:valuator_role) { create(:participatory_process_user_role, role: :valuator, user:, participatory_process:) }
  let!(:another_user) { create(:user, organization:) }
  let!(:another_valuator_role) { create(:participatory_process_user_role, role: :valuator, user: another_user, participatory_process:) }

  include Decidim::ComponentPathHelper

  include_context "when managing a component as an admin"

  before do
    user.update(admin: false)

    create(:valuation_assignment, proposal: assigned_proposal, valuator_role:)
    create(:valuation_assignment, proposal: assigned_proposal, valuator_role: another_valuator_role)
  end

  context "when in the proposal page" do
    before do
      visit current_path

      within "tr", text: translated(assigned_proposal.title) do
        click_on "Answer proposal"
      end
    end

    it "shows all evaluators" do
      within "#accordion-internal-evaluations" do
        expect(page).to have_content("0 out of 2 evaluations")
        expect(page).to have_content(user.name)
        expect(page).to have_content(another_user.name)
      end
    end

    context "when creating an evaluation" do
      it "cannot create an invalid evaluation" do
        page.find("[data-action='evaluate']").click

        expect do
          within "div.evaluate-modal" do
            click_on "Save"
          end
        end.not_to change(Decidim::InternalEvaluation::InternalEvaluation, :count)

        expect(page).to have_content("Body cannot be blank")
      end

      it "can only create an internal evaluation for themselves" do
        within "tr", text: another_user.name do
          expect(page).to have_no_css("[data-action='evaluate']")
        end

        within "tr", text: user.name do
          expect(page).to have_css("[data-action='evaluate']")

          page.find("[data-action='evaluate']").click
        end

        expect do
          within "div.evaluate-modal" do
            choose "Accepted"
            fill_in_editor :internal_evaluation_body, with: "Great proposal"

            click_on "Save"
          end
        end.to change(Decidim::InternalEvaluation::InternalEvaluation, :count).by(1)

        expect(page).to have_content("successfully")
        expect(page).to have_content("1 out of 2 evaluations")
      end
    end
  end

  context "when evaluation already exists" do
    let!(:evaluation) { create(:internal_evaluation, proposal: assigned_proposal, author: user, body: "Great proposal!") }

    before do
      visit current_path

      within "tr", text: translated(assigned_proposal.title) do
        click_on "Answer proposal"
      end
    end

    it "shows the evaluation status and content" do
      within "tr", text: user.name do
        expect(page).to have_content(translated(evaluation.internal_state.title))
        expect(page).to have_content(evaluation.body)
      end
    end

    it "can edit owned internal evaluations" do
      within "tr", text: another_user.name do
        expect(page).to have_no_css("[data-action='evaluate']")
      end

      within "tr", text: user.name do
        expect(page).to have_css("[data-action='evaluate']")

        page.find("[data-action='evaluate']").click
      end

      expect do
        within "div.evaluate-modal" do
          expect(page).to have_checked_field(translated(evaluation.internal_state.title))
          choose "Accepted"
          fill_in_editor :internal_evaluation_body, with: "Change"

          click_on "Save"
        end
      end.not_to change(Decidim::InternalEvaluation::InternalEvaluation, :count)

      expect(page).to have_content("successfully")
      evaluation.reload

      expect(evaluation.internal_state.token).to eq("accepted")
      expect(evaluation.body).to eq("<p>Change</p>")
    end
  end
end
