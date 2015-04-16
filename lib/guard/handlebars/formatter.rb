module Guard
  class Handlebars
    module Formatter
      class << self

        def info(message, options = {})
          Compat::UI.info(message, options)
        end

        def debug(message, options={})
          Compat::UI.debug(message, options)
        end

        def error(message, options={})
          Compat::UI.error(message, options)
        end

        def success(message, options={})
          Compat::UI.info(message, options)
        end

        def notify(message, options={})
          Compat::UI.notify(message, options)
        end

        private
        def color(text, color_code)
          Compat::UI.send(:color_enabled?) ? "\e[0#{ color_code }m#{ text }\e[0m" : text
        end

      end
    end
  end
end
