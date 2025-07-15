# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe InternalEvaluation do
    subject { described_class }

    it "has version" do
      expect(subject.version).to eq("0.0.2")
    end
  end
end
