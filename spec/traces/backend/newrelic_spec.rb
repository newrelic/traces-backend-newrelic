# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/traces-backend-newrelic/blob/main/LICENSE for complete details.
# frozen_string_literal: true

require 'traces'
require 'traces/backend/newrelic'

NewRelic::Agent.require_test_helper

class MyClass
  def my_method(argument); end
end

Traces::Provider(MyClass) do
  def my_method(argument)
    Traces.trace('my_method', attributes: { the_args: argument }) do |span|
      super
      span[:extra_attr] = 'another'
    end
  end
end

describe Traces::Backend::NewRelic do
  let(:instance) { MyClass.new }

  it 'has version number' do
    expect(Traces::Backend::NewRelic::VERSION).not_to be nil
  end

  it 'can invoke trace wrapper' do
    expect(Traces).to receive(:trace)

    instance.my_method(nil)
  end

  it 'creates a segment' do
    expect(::NewRelic::Agent::Tracer).to receive(:start_segment).with(name: 'my_method')

    instance.my_method(nil)
  end

  it 'adds attributes to segment' do
    expect_any_instance_of(::NewRelic::Agent::Transaction::Segment).to receive(:add_agent_attribute).with(:the_args, 'test arg')
    expect_any_instance_of(::NewRelic::Agent::Transaction::Segment).to receive(:add_agent_attribute).with(:extra_attr, 'another')

    instance.my_method('test arg')
  end

  describe 'trace_context' do
    before(:all) do
      # set up info needed for the trace state to be created
      config = {
        account_id: '101',
        primary_application_id: '12345',
        trusted_account_key: '999999',
        disable_harvest_thread: true
      }
      ::NewRelic::Agent.config.add_config_for_testing(config)
    end

    it 'attributes match what the agent has for transaction' do
      ::NewRelic::Agent::Tracer.in_transaction(name: 'test_txn', category: :web) do
        nr_freeze_process_time

        context = Traces.trace_context
        txn = ::NewRelic::Agent::Tracer.current_transaction

        expect(context.trace_id).to eq(txn.trace_id)
        expect(context.parent_id).to eq(txn.current_segment.guid)
        expect(context.flags).to eq(0x1)
        expect(context.state).to eq(txn.distributed_tracer.create_trace_state)

        nr_unfreeze_process_time
      end
    end
  end
end
