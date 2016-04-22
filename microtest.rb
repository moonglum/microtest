module MicroTest
  TESTS = []

  def self.run_all_tests
    reporter = Reporter.new

    TESTS.each do |klass|
      klass.run reporter
    end

    reporter.summary
  end

  class Test
    attr_accessor :name
    attr_accessor :failure
    alias :failure? :failure

    def initialize(name)
      self.name = name
      self.failure = false
    end

    def self.inherited(x)
      TESTS << x
    end

    def self.test_names
      public_instance_methods.grep(/_test$/)
    end

    def self.run(reporter)
      test_names.shuffle.each do |name|
        result = self.new(name).run
        reporter << result
      end
    end

    def setup
    end

    def teardown
    end

    def run
      setup
      send name
      teardown
    rescue => e
      self.failure = e
    ensure
      return self
    end

    def assert(test, msg = "Failed test")
      raise RuntimeError, msg unless test
    end

    def assert_equal(a, b)
      assert a == b, "Failed assert_equal #{a} vs #{b}"
    end
  end

  class Reporter
    attr_accessor :failures

    def initialize
      self.failures = []
    end

    def <<(result)
      if result.failure?
        print "F"
        failures << result
      else
        print "."
      end
    end

    def summary
      puts

      failures.each do |result|
        failure = result.failure

        puts
        puts "Failure: #{result.class}##{result.name}: #{failure.message}"
        puts "  #{filter_backtrace(failure.backtrace)}"
      end
    end

    private

    def filter_backtrace(backtrace)
      backtrace.drop_while { |s| s =~ /#{__FILE__}/ }.first
    end
  end
end
