module Spigot
  module ActiveRecord
    module ClassMethods

      ## #find_by_api(service, api_data)
      #
      # Build a query based on the defined map for this resource
      # to find a single matching record in this model's table
      def find_by_api(service, api_data)
        find_all_by_api(service, api_data).first
      end

      ## #find_all_by_api(service, api_data)
      #
      # Build a query based on the defined map for this resource
      # to find all matching records in this model's table
      def find_all_by_api(service, api_data)
        find_by_translator Translator.new(service, self, api_data)
      end

      ## #create_by_api(service, api_data)
      def create_by_api(service, api_data)
        create_by_translator Translator.new(service, self, api_data)
      end

      ## #update_by_api(service, api_data)
      def update_by_api(service, api_data)
        babel = Translator.new(service, self, api_data)
        record = find_by_translator(babel)
        update_by_translator(babel, record) if record.present?
      end

      ## #find_or_create_by_api(service, api_data)
      def find_or_create_by_api(service, api_data)
        babel = Translator.new(service, self, api_data)
        find_by_translator(babel) || create_by_translator(babel)
      end

      ## #create_or_update_by_api(service, api_data)
      def create_or_update_by_api(service, api_data)
        babel = Translator.new(service, self, api_data)
        record = find_by_translator(babel).first
        record.present? ? update_by_translator(babel, record) : create_by_translator(babel)
      end

      private

      def find_by_translator(translator)
        if invalid_primary_keys?(translator)
          raise Spigot::InvalidSchemaError, "The #{translator.primary_key} column does not exist on #{self.to_s}"
        end

        if translator.id.blank?
          Spigot.logger.warn "   <Spigot::Warning> No #{translator.service} API data found at :#{translator.foreign_key}"
        end

        return [] if translator.conditions.blank?
        self.where(translator.conditions)
      end

      def create_by_translator(translator)
        Record.create(self, translator.format)
      end

      def update_by_translator(translator, record)
        Record.update(self, record, translator.format)
        record
      end

      def invalid_primary_keys?(translator)
        [*translator.primary_key].each do |key|
          return true unless self.column_names.include?(key.to_s)
        end
        false
      end
    end

  end
end
