# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim-internal_evaluation", path: "."
gem "decidim", ">= 0.28"
gem "decidim-proposals", ">= 0.28"
gem "decidim-templates", ">= 0.28"

gem "bootsnap", "~> 1.4"
gem "puma", ">= 6.3.1"
gem "wkhtmltopdf-binary", "~> 0.12"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", ">= 0.28"
  gem "parallel_tests", "~> 4.2"
end

group :development do
  gem "faker", "~> 3.2"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end
