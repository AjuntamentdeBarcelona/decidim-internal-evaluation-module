# frozen_string_literal: true

require "spec_helper"

module Decidim::InternalEvaluation
  describe InternalEvaluation do
    subject { internal_evaluation }

    let!(:internal_evaluation) { create(:internal_evaluation) }

    it { is_expected.to be_valid }
  end
end
