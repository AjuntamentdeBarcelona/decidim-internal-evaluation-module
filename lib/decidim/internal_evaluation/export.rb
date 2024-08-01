# frozen_string_literal: true

module Decidim
  module InternalEvaluation
    module Export
      # Public: Given a resource class and a component, returns the internal evaluations for that
      # resource in that component.
      #
      # resource_class - The resource's Class
      # component      - The component where the resource is scoped to.
      # user           - The user that is requesting the export.
      #
      # Returns an Arel::Relation with all the internal evaluations for that component and resource.
      def internal_evaluations_for_resource(resource_class, component, user)
        participatory_space = component.participatory_space
        collection = resource_class.not_hidden.published.where(component:)
        user_is_valuator = participatory_space.user_roles(:valuator).where(user:).any?

        filtered_collection = if user_is_valuator
                                collection.with_valuation_assigned_to(user, participatory_space)
                              else
                                collection
                              end

        InternalEvaluation.where(proposal: filtered_collection.pluck(:id))
      end

      module_function :internal_evaluations_for_resource
    end
  end
end
