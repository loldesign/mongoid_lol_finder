module Mongoid
  module LolFilter
    extend ActiveSupport::Concern

    module ClassMethods
      def filter options={}
        options.inject(scoped) do |relation, hash|
          key, value = hash
          relation = send("by_#{key}", value, relation) if value.present?
          relation
        end
      end

      private

      def by_created_at dates, relation
        start_date, finish_date = dates
        started_at, finished_at = formated_date(start_date), formated_date(finish_date)

        return relation unless started_at.present?

        relation.where(:created_at => (started_at.utc.beginning_of_day..(finished_at || Time.now).utc.end_of_day))
      end

      def by_belongs_to association, relation
        return relation unless association[:id].present?

        relation.where("#{association[:name]}_id" => association[:id])
      end
      
      def formated_date date
        if date.present?
          day, month, year = date.split('/')
          Time.new(year.to_i, month.to_i, day.to_i)
        end
      end
    end    
  end
end