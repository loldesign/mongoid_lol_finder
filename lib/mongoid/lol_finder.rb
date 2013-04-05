module Mongoid
  module LolFinder
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for(*fields)
        @find_for_fields = *fields
      end

      def search(query="", options={})
        @find_for_fields.inject(scoped) do |relation, attr|

          case way_to_search(attr)
          when :embedded
            search_by_embedded(relation, attr, query)
          when :association
            search_by_association(relation, attr, query)
          when :model
            search_in_model(relation, attr, query)
          end
        end
      end

      private

      def klass_by(resource)
        resource.to_s.classify.constantize
      end

      def search_by_association(relation, resource, query)
        association = klass_by(resource).search(query).first if query.present?
        return relation if association.nil?

        relation.or({"#{resource}" => association})
      end

      def search_by_embedded(relation, resource, query)
        klass_by(resource).fields.keys.inject(relation) do |relation, field|
          relation.or({"#{resource}.#{field}" => query})
        end
      end

      def search_in_model(relation, field, query)
        if fields[field.to_s].type == Hash
          relation.or({"#{field}.#{query}".to_sym.exists => true})
        else
          relation.or({field => /#{query}/i})
        end
      end

      def way_to_search(field)
        if embedded_relations.include?(field.to_s)
          :embedded
        elsif associations.include?(field.to_s)
          :association
        else
          :model
        end
      end
    end
  end
end
