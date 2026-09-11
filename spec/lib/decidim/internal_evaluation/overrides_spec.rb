# frozen_string_literal: true

require "spec_helper"

# We check the checksum of the file overriden.
# If the test fails, that the overriden file should be updated.
checksums = [
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/admin/proposals/_proposal-tr.html.erb" => "608af89f7bfa800fe2e3c853f8e2ace0",
      "/app/views/decidim/proposals/admin/proposals/show.html.erb" => "8beac85dc41b860a2cc83efa6fa97e42",
      "/app/controllers/decidim/proposals/admin/proposals_controller.rb" => "f815697e34a2a24ce20696e7f6c46d4f",
      "/app/controllers/decidim/proposals/admin/proposal_states_controller.rb" => "23cdaa84a8951ed053e374b6bc5b3428",
      "/app/commands/decidim/proposals/admin/unassign_proposals_from_evaluator.rb" => "8dc24ee1ae681b57c475e873f5d0347f"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        gem_dir = Gem::Specification.find_by_name(item[:package]).gem_dir

        expect(md5("#{gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
