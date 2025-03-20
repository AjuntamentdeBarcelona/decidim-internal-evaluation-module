# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = ">= 0.29.0"

gem "decidim-internal_evaluation", path: "."

gem "decidim", DECIDIM_VERSION
gem "decidim-proposals", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "bootsnap", "~> 1.4"
gem "puma", ">= 6.3.1"
gem "wkhtmltopdf-binary", "~> 0.12"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "parallel_tests", "~> 4.2"
end

group :development do
  gem "faker", "~> 3.2"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end
