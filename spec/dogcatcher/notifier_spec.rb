require 'spec_helper'

describe Dogcatcher::Notifier do
  let(:use_dogapi) { nil }
  let(:use_statsd) { nil }
  let(:notice) { double('Notice') }
  let(:config) { double('Config', use_dogapi?: use_dogapi, use_statsd?: use_statsd) }

  subject { described_class.new(config) }

  describe '#notify' do
    context 'when use_dogapi is true' do
      let(:use_dogapi) { true }

      it 'notifies dogapi' do
        expect(subject).to receive(:notify_dogapi).with(notice)
        subject.notify(notice)
      end
    end

    context 'when use_dogapi is false' do
      let(:use_dogapi) { false }

      it 'does not notify dogapi' do
        expect(subject).to_not receive(:notify_dogapi).with(notice)
        subject.notify(notice)
      end
    end

    context 'when use_statsd is true' do
      let(:use_statsd) { true }

      it 'notifies statsd' do
        expect(subject).to receive(:notify_statsd).with(notice)
        subject.notify(notice)
      end
    end

    context 'when use_statsd is false' do
      let(:use_statsd) { false }

      it 'does not notify statsd' do
        expect(subject).to_not receive(:notify_statsd).with(notice)
        subject.notify(notice)
      end
    end
  end
end
