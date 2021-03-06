module SnipSnip
  class Railtie < Rails::Railtie
    initializer 'snip_snip.load_extensions' do
      ActiveSupport.on_load(:action_controller) do
        before_action { Registry.clear }
        after_action { Reporter.report(self) }
      end

      ActiveSupport.on_load(:active_record) do
        after_find { Registry.register(self) unless Filter.filtered?(self) }
      end
    end
  end
end
