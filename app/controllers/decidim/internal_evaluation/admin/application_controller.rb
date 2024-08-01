# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      class ApplicationController < Decidim::Proposals::Admin::ApplicationController
      end
    end
  end
end
