# frozen_string_literal: true

require_relative "colorized_logger/version"
require 'active_support/logger'
require 'active_support/tagged_logging'

module ColorizedLogger
  class Error < StandardError; end
  class Logger < ActiveSupport::Logger
    def initialize(path, colorize: false)
      super(path)
      return unless colorize
      @formatter = ActiveSupport::Logger::SimpleFormatter.new
      self.formatter = proc { |severity, datetime, progname, msg|
        formatted_message = "#{datetime} #{severity} -- #{progname}: #{msg}\n"
        colorize(formatted_message, color_for_severity(severity))
      }
    end
  
    def print(message, tag = nil, severity: :debug)
      caller_file = find_caller_file
      tag = tag ? "#{tag} | /#{caller_file}.rb" : "/#{caller_file}.rb"
      color_code = color_for_severity(severity.to_s.upcase)
      colorized_tag = colorize(tag, color_code)
      colorized_message = colorize(message, color_code)
      Rails.logger.tagged(colorized_tag) do
        Rails.logger.debug(colorized_message)
      end
    end
  
    private
  
    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end
  
    def color_for_severity(severity)
      case severity
      when "DEBUG" then '36'  # cyan
      when "INFO" then '32'   # green
      when "WARN" then '33'   # yellow
      when "ERROR", "FATAL" then '31' # red
      else '0' # default
      end
    end
  
    def find_caller_file
      caller_locations.each do |location|
        file_path = location.path
        if file_path.include?('/app/') && !file_path.include?('/lib/')
          relative_path = extract_relative_path(file_path)
          return "#{relative_path}:#{location.lineno}"
        end
      end
      'unknown'
    end
  
    def extract_relative_path(file_path)
      app_index = file_path.index('/app/')
      return file_path[app_index + 5..-1] if app_index
      file_path
    end
    
    def color_for_custom_color(color)
      case color
      when :cyan then '36'
      when :green then '32'
      when :yellow then '33'
      when :red then '31'
      else '0' # default
      end
    end
  end
end
