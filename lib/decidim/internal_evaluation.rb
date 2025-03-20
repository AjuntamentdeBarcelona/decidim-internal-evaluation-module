# frozen_string_literal: true

require "decidim/internal_evaluation/admin"
require "decidim/internal_evaluation/admin/unassign_proposals_from_evaluators_overrides"
require "decidim/internal_evaluation/engine"
require "decidim/internal_evaluation/admin_engine"

module Decidim
  # This namespace holds the logic of the `InternalEvaluation` component. This component
  # allows users to create internal_evaluation in a participatory space.
  module InternalEvaluation
    autoload :InternalEvaluationSerializer, "decidim/internal_evaluation/internal_evaluation_serializer"
    autoload :Export, "decidim/internal_evaluation/export"
  end
end
