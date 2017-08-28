module SnipSnip
  class Registry
    Entry = Struct.new(:model, :stack)

    attr_accessor :entries
    attr_accessor :backtrace_cleaner

    def initialize
      self.backtrace_cleaner = Rails.backtrace_cleaner
      clear
    end

    def clear
      self.entries = []
    end

    def each_entry(&block)
      return to_enum(:each_entry) unless block_given?
      entries.each(&block)
    end

    def register(entry, stack)
      entries << { model: entry, stack: stack }
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
