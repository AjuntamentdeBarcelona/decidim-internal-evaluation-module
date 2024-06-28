# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/internal_evaluation/version"

Gem::Specification.new do |s|
  s.version = Decidim::InternalEvaluation.version
  s.authors = ["Eduardo Martinez Echevarria"]
  s.email = ["eduardomech@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://decidim.org"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/decidim/decidim/issues",
    "documentation_uri" => "https://docs.decidim.org/",
    "funding_uri" => "https://opencollective.com/decidim",
    "homepage_uri" => "https://decidim.org",
    "source_code_uri" => "https://github.com/decidim/decidim"
  }
  s.required_ruby_version = "~> 3.1"

  s.name = "decidim-internal_evaluation"
  s.summary = "A decidim internal_evaluation module"
  s.description = "Tools to manage in an easier way the internal evaluation process of proposals."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end

  s.add_dependency "decidim-core", Decidim::InternalEvaluation.decidim_version
  s.add_dependency "decidim-proposals", Decidim::InternalEvaluation.decidim_version
end
