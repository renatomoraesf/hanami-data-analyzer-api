module Api
  module Actions
    module Home
      class Health < Api::Action
        def handle(request, response)
          response.format = :json
          response.body = {
            status: "healthy",
            timestamp: Time.now.iso8601,
            environment: Hanami.env,
            uptime: Process.clock_gettime(Process::CLOCK_MONOTONIC).to_i
          }.to_json
        end
      end
    end
  end
end
