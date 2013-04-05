module Mongoid
  module LolFinder
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for(*fields)
        @find_for_fields = *fields
      end

      def search(query="", options={})
        @find_for_fields.inject(scoped) do |relation, field|

          case way_to_search(field)
          when :embedded
            search_by_embedded(relation, field.to_s, query)
          when :association
            search_by_association(relation, field.to_s, query)
          when :model
            search_by_model(relation, field.to_s, query)
          end
        end
      end

      def search_by_association(relation, field, query)
        association = field.to_s.classify.constantize.send('search', query).first if query.present?
        if association.nil?
          relation
        else
          relation.or({"#{field}_id" => association.id})
        end
      end

      def search_by_embedded(relation, field, query)
        field.classify.constantize.fields.keys.inject(relation) do |relation, attr|
          relation.or({"#{field}.#{attr}" => query})
        end
      end

      def search_by_model(relation, field, query)
        if self.fields[field.to_s].type == Hash
          relation.or({:"#{field}.#{query}".exists => true})
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
