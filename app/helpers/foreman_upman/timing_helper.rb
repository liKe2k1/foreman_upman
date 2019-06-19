module ForemanUpman
  module TimingHelper
    def measure_time
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      yield
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed_time = end_time - start_time
      elapsed_time.round(3)
    end
  end
end
