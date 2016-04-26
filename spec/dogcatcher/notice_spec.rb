require 'spec_helper'

describe Dogcatcher::Notice do
  let(:gem_tags) { false }
  let(:program) { nil }
  let(:bc) { double('BacktraceCleaner') }
  let(:bline) { "/usr/local/rvm/gems/ruby-2.2.1/gems/foo-1.2.3/lib/rake/task.rb:240:in `call'" }
  let(:config) { double('Config', backtrace_cleaner: bc, gem_tags: gem_tags, program: program, custom_tags: ['custom-example']) }
  let(:exception) { double('Error', backtrace: [bline], message: 'bar') }

  subject { described_class.new(config, exception) }

  describe '#message' do
    before do
      allow(bc).to receive(:clean).with([bline]).and_return([bline])
    end

    it 'contains the cleaned backtrace' do
      expect(subject.message).to match(/gems\/foo-1\.2\.3\//)
    end

    context 'when metadata is provided' do
      before do
        subject.metadata['foo'] = 'bar'
      end

      it 'contains the metadata' do
        expect(subject.message).to match(/\* foo: bar/)
      end
    end
  end

  describe '#tags' do
    before do
      subject.notifier = 'one'
      subject.action = 'two'
    end

    it 'returns an array of tags' do
      expect(subject.tags).to be_an(Array)
    end

    it 'returns a notifier tag' do
      expect(subject.tags).to include('notifier:one')
    end

    it 'returns an action tag' do
      expect(subject.tags).to include('action:two')
    end

    it 'returns an exception class tag' do
      expect(subject.tags).to include('exception_class:RSpec::Mocks::Double')
    end

    it 'returns a ruby_version tag' do
      expect(subject.tags).to include("ruby_version:#{RUBY_VERSION}")
    end

    it 'returns custom tags' do
      expect(subject.tags).to include('custom-example')
    end

    context 'when program name is not set' do
      it 'does not return a program tag' do
        expect(subject.tags).to_not include('program:')
      end
    end

    context 'when program name is set' do
      let(:program) { 'progname' }

      it 'returns a program tag' do
        expect(subject.tags).to include('program:progname')
      end
    end

    context 'when gem_tags is true' do
      let(:gem_tags) { true }

      it 'includes gem version tags' do
        expect(subject.tags).to include('foo:1.2.3')
      end
    end

    context 'when gem_tags is false' do
      it 'does not include gem version tags' do
        expect(subject.tags).to_not include('foo:1.2.3')
      end
    end
  end

  describe '#title' do
    context 'when program is configured' do
      let(:program) { 'foo' }

      it 'returns a string containg program, exception class, exception message' do
        expect(subject.title).to eq('foo - RSpec::Mocks::Double:bar')
      end
    end

    context 'when program is not configured' do
      it 'returns a string containg exception class, exception message' do
        expect(subject.title).to eq('RSpec::Mocks::Double:bar')
      end
    end
  end
end
