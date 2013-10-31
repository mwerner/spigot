module Spigot
  module ActiveRecord
    module ClassMethods
      ## #create_by_api(service, api_data)
      def find_by_api(service, api_data)
        find_by_translator Translator.new(service, self, api_data)
      end

      ## #create_by_api(service, api_data)
      def create_by_api(service, api_data)
        create_by_translator Translator.new(service, self, api_data)
      end

      ## #update_by_api(service, api_data)
      def update_by_api(service, api_data)
        t = Translator.new(service, self, api_data)
        record = find_by_translator(t)
        update_by_translator(t, record)
      end

      ## #find_or_create_by_api(service, api_data)
      def find_or_create_by_api(service, api_data)
        t = Translator.new(service, self, api_data)
        find_by_translator(t) || create_by_translator(t)
      end

      ## #create_or_update_by_api(service, api_data)
      def create_or_update_by_api(service, api_data)
        t = Translator.new(service, self, api_data)
        record = find_by_translator(t)
        record.present? ? update_by_translator(t, record) : create_by_translator(t)
      end

      private

      def find_by_translator(translator)
        unless self.column_exists?(translator.primary_key.to_sym)
          raise RuntimeError, "The #{translator.primary_key} column does not exist on #{self.class.to_s}"
        end

        if translator.id.blank?
          raise RuntimeError, "No value found in #{service} api data at #{translator.foreign_key}"
        end

        self.where(["? = ?", translator.primary_key, translator.id]).first
      end

      def create_by_translator(translator)
        Factory.create(self, translator.format)
      end

      def update_by_translator(translator, record)
        # TODO
      end
    end

  end
end
