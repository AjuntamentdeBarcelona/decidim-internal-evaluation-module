# frozen_string_literal: true

require "spec_helper"

# We check the checksum of the file overriden.
# If the test fails, that the overriden file should be updated.
checksums = [
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/admin/proposals/_proposal-tr.html.erb" => "4fdf708691596e6e52a6aa427303b0a6",
      "/app/views/decidim/proposals/admin/proposals/show.html.erb" => "bde8bbe14eea0c5c5e0539071a10a2b6",
      "/app/controllers/decidim/proposals/admin/proposals_controller.rb" => "08ed9b8ced5e5302e9bf42c0afaa0679",
      "/app/controllers/decidim/proposals/admin/proposal_states_controller.rb" => "cd2d1521734ebf60e9769acbec3d83fa",
      "/app/commands/decidim/proposals/admin/unassign_proposals_from_valuator.rb" => "377e2ef5c196b4ced4c20b44889e1861"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
