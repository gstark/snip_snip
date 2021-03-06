module SnipSnip
  class Registry
    attr_accessor :records

    def initialize
      clear
    end

    def clear
      self.records = []
    end

    def each_record(&block)
      return to_enum(:each_record) unless block_given?
      records.each(&block)
    end

    def register(record)
      records << record
    end

    class << self
      def instance
        @instance ||= new
      end

      def method_missing(method, *args, &block)
        respond_to_missing?(method) ? instance.public_send(method, *args, &block) : super
      end

      def respond_to_missing?(method)
        instance.respond_to?(method)
      end
    end
  end
end
