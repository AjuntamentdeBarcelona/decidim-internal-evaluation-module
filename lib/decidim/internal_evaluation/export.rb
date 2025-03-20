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
        filtered_collection(resource_class, component, user).map do |proposal|
          proposal.evaluation_assignments.map do |assignment|
            author = assignment.evaluator_role&.user

            next if author.blank?

            InternalEvaluation.find_or_initialize_by(proposal:, author:)
          end
        end.flatten.compact
      end

      # Internal: Returns the filtered collection for the given resource class, component and user.
      #
      # resource_class - The resource's Class
      # component      - The component where the resource is scoped to.
      # user           - The user that is requesting the export.
      #
      # Returns an Arel::Relation with the filtered collection.
      def filtered_collection(resource_class, component, user)
        @filtered_collection ||= begin
          collection = resource_class
                       .not_hidden
                       .published
                       .where(component:)
                       .where.not(evaluation_assignments_count: 0)

          participatory_space = component.participatory_space
          user_is_evaluator = participatory_space.user_roles(:evaluator).where(user:).any?

          if user_is_evaluator
            collection.with_evaluation_assigned_to(user, participatory_space)
          else
            collection
          end
        end
      end

      module_function :internal_evaluations_for_resource, :filtered_collection
    end
  end
end
