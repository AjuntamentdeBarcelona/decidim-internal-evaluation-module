# frozen_string_literal: true

require "spec_helper"

# We check the checksum of the file overriden.
# If the test fails, that the overriden file should be updated.
checksums = [
  {
    package: "decidim-proposals",
    files: {
      "/app/views/decidim/proposals/admin/proposals/_proposal-tr.html.erb" => "057ee4242479109023a5904c8de55222",
      "/app/views/decidim/proposals/admin/proposals/show.html.erb" => "5dae5c5dc6b6c25a5b4cfc5cda5e9f01"
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
