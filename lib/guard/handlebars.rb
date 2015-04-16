require 'guard/compat/plugin'


module Guard
  class Handlebars < Plugin

    require 'guard/handlebars/formatter'
    require 'guard/handlebars/inspector'
    require 'guard/handlebars/runner'
    require 'guard/handlebars/template'

    DEFAULT_OPTIONS = {
      bare: false,
      shallow: false,
      hide_success: false,
      compiled_name: 'compiled.js'
    }

    attr_reader :patterns

    def initialize(options = {})
      defaults = DEFAULT_OPTIONS.clone
      @patterns = options.dup.delete(:patterns) || []
      if options[:input]
        @patterns << %r{#{options[:input]}/(.+\.handlebars)}
      end

      puts options
      puts @patterns


      # msg = ":input option not provided (see current template Guardfile)"
      # fail msg unless options[:input]

      super(defaults.merge(options))
    end

    def start
      run_all if options[:all_on_start]
    end

    def run_all
      found = Dir.glob(File.join('**', '*.handlebars'))
      found.select! do |file|
        @patterns.any? do |pattern|
          pattern.match(file)
        end
      end
      run_on_modifications(found)
    end

    def run_on_changes(paths)
      _changed_files, success = Runner.run(Inspector.clean(paths), @patterns, options)
      notify(_changed_files)
    end

    def run_on_modifications(paths)
      puts "Run on Modifications"
      _changed_files, success = Runner.run(Inspector.clean(paths), @patterns, options)
      throw :task_has_failed unless success
    end

    def run_on_removals(paths)
      Runner.remove(Inspector.clean(paths, missing_ok: true), @patterns, options)
    end

  end
end
