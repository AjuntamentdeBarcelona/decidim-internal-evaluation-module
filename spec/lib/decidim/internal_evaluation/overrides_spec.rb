# frozen_string_literal: true

require "spec_helper"

# We check the checksum of the file overriden.
# If the test fails, that the overriden file should be updated.
checksums = [
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/admin/proposals/_proposal-tr.html.erb" => "608af89f7bfa800fe2e3c853f8e2ace0",
      "/app/views/decidim/proposals/admin/proposals/show.html.erb" => "541d1f188e12c6c6ccf18d8908165d81",
      "/app/controllers/decidim/proposals/admin/proposals_controller.rb" => "e4c0f7d53474d75a9f9a091970995abb",
      "/app/controllers/decidim/proposals/admin/proposal_states_controller.rb" => "46d227d4b80c177ee4bf50eba003d008",
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
