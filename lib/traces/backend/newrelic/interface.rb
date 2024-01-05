# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/traces-backend-newrelic/blob/main/LICENSE for complete details.
# frozen_string_literal: true

require 'newrelic_rpm'

require 'traces/context'
require_relative 'version'

module Traces
  module Backend
    module NewRelic
      module Interface
        def trace(name, resource: nil, attributes: {}, &block)
          segment = ::NewRelic::Agent::Tracer.start_segment(name: name)
          span_attributes = {}
          attributes.each { |key, value| segment&.add_agent_attribute(key, value) }
          begin
            if block.arity.zero?
              yield
            else
              yield(span_attributes)
            end
          rescue StandardError => e
            ::NewRelic::Agent.notice_error(e)
            raise
          end
        ensure
          span_attributes.each { |key, value| segment&.add_agent_attribute(key, value) }
          segment&.finish
        end

        def trace_context=(context)
          return unless context

          headers = {
            'traceparent' => context.to_s,
            'tracestate' => context.state
          }
          ::NewRelic::Agent::DistributedTracing.accept_distributed_trace_headers(headers, 'Other')
        end

        def trace_context
          transaction = ::NewRelic::Agent::Tracer.current_transaction
          return unless transaction && ::NewRelic::Agent.config[:'distributed_tracing.enabled']

          trace_id = transaction.trace_id.rjust(32, '0').downcase
          parent_id = transaction.current_segment.guid
          flags = transaction.sampled? ? 0x1 : 0x0
          state = transaction.distributed_tracer.create_trace_state

          Context.new(trace_id, parent_id, flags, state)
        end
      end
    end

    Interface = NewRelic::Interface
  end
end
