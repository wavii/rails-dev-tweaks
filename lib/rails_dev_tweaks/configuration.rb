class RailsDevTweaks::Configuration

  def initialize
    @granular_autoload_config = GranularAutoloadConfiguration.new

    # And set our defaults
    self.autoload_rules do
      keep :all
    end
  end

  # Takes a block that configures the granular autoloader's rules.
  def autoload_rules(&block)
    @granular_autoload_config.instance_eval(&block)
  end

  class GranularAutoloadConfiguration

    def initialize
      # Each rule is a simple pair: [:skip, callable], [:keep, callable], etc.
      @rules = []
    end

    def keep(*args, &block)
      self.append_rule(:keep, *args, &block)
    end

    def skip(*args, &block)
      self.append_rule(:skip, *args, &block)
    end

    def append_rule(rule_type, *args, &block)
      unless rule_type == :skip || rule_type == :keep
        raise TypeError, "Rule must be :skip or :keep.  Got: #{rule_type.inspect}"
      end

      # Simple matcher blocks
      if args.size == 0 && block.present?
        @rules << [rule_type, block]
        return self
      end

      # String match shorthand
      args[0] = /^#{args[0]}/ if args.size == 1 && args[0].kind_of?(String)

      # Regex match shorthand
      args = [:path, args[0]] if args.size == 1 && args[0].kind_of?(Regexp)

      if args.size == 0 && block.blank?
        raise TypeError, 'Cannot process autoload rule as specified.  Expecting a named matcher (symbol), path prefix (string) or block'
      end

      # Named matcher
      matcher_class = "RailsDevTweaks::GranularAutoload::Matchers::#{args[0].to_s.classify}Matcher".constantize
      @rules << [rule_type, matcher_class.new(*args[1..-1])]

      self
    end

  end

end

