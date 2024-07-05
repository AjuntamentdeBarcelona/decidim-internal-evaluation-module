# frozen_string_literal: true

# Works when defined in decidim/decidim-proposals/lib/decidim/proposals/component.rb

Decidim.register_component(:proposals) do |component|
  component.exports :internal_evaluations do |exports|
    exports.collection do |component_instance, user|
      Decidim::InternalEvaluation::Export.internal_evaluations_for_resource(
        Decidim::Proposals::Proposal, component_instance, user
      )
    end

    exports.include_in_open_data = true

    exports.serializer Decidim::InternalEvaluation::InternalEvaluationSerializer
  end
end
