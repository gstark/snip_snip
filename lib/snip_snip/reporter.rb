module SnipSnip
  class Reporter
    Result = Struct.new(:class_name, :primary_key, :used, :unused, :stack)

    attr_accessor :results

    def initialize
      self.results = find_results
    end

    def report(message)
      return if results.empty?

      backtrace_cleaner = Registry.backtrace_cleaner

      SnipSnip.logger.info(message)
      results.sort_by(&:class_name).each do |result|
        hash = { class: result.class_name, key: result.primary_key, unused: result.unused, used: result.used }
        SnipSnip.logger.info("  #{hash.inspect}")

        backtrace_cleaner.clean(result.stack).each do |stack|
          SnipSnip.logger.info("    #{stack}")
        end
      end
    ensure
      Registry.clear
    end

    def self.report(controller)
      new.report(controller)
    end

    private

    def find_results
      Registry.each_entry.each_with_object([]) do |entry, results|
        model = entry[:model]
        stack = entry[:stack]

        accessed = model.accessed_fields
        unused = (model.attributes.keys - accessed)
        next if unused.empty?

        primary_key = model.class.primary_key
        results << Result.new(model.class.name, model.send(primary_key), accessed, unused, stack)
      end
    end
  end
end
