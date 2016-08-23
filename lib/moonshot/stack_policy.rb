require 'json'

module Moonshot
  # A StackPolicy loads the JSON policy from disk and stores information
  # about it.
  class StackPolicy
    Parameter = Struct.new(:name, :default) do
      def required?
        default.nil?
      end
    end

    attr_reader :body

    def initialize(filename, log:)
      @log = log

      unless File.exist?(filename)
        @log.error("Could not find CloudFormation policy at #{filename}")
        raise
      end

      # The maximum TemplateBody length is 51,200 bytes, so we remove
      # formatting white space.
      @body = JSON.parse(File.read(filename)).to_json
    end
  end
end
