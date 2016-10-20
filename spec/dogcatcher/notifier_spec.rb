require 'spec_helper'

describe Dogcatcher::Notifier do
  let(:use_dogapi) { nil }
  let(:use_statsd) { nil }
  let(:send_event) { nil }
  let(:send_metric) { nil }
  let(:notice) { double('Notice') }
  let(:config) { double('Config', use_dogapi?: use_dogapi, use_statsd?: use_statsd, send_event: send_event, send_metric: send_metric) }

  subject { described_class.new(config) }

  describe '#notify' do
    context 'when use_dogapi is true' do
      let(:use_dogapi) { true }
      context 'when send_event is true' do
        let(:send_event) { true }
        it 'notifies dogapi via event' do
          expect(subject).to receive(:notify_dogapi_event).with(notice)
          subject.notify(notice)
        end
      end
      context 'when send_event is false' do
        let(:send_event) { false }
        it 'does not notify dogapi via event' do
          expect(subject).to_not receive(:notify_dogapi_event).with(notice)
          subject.notify(notice)
        end
      end

      context 'when send_metric is true' do
        let(:send_metric) { true }
        it 'notifies dogapi via metric' do
          expect(subject).to receive(:notify_dogapi_metric).with(notice)
          subject.notify(notice)
        end
      end
      context 'when send_metric is false' do
        let(:send_metric) { false }
        it 'does not notify dogapi via metric' do
          expect(subject).to_not receive(:notify_dogapi_metric).with(notice)
          subject.notify(notice)
        end
      end
    end

    context 'when use_dogapi is false' do
      let(:use_dogapi) { false }

      it 'does not notify dogapi' do
        expect(subject).to_not receive(:notify_dogapi_event).with(notice)
        expect(subject).to_not receive(:notify_dogapi_metric).with(notice)
        subject.notify(notice)
      end
    end

    context 'when use_statsd is true' do
      let(:use_statsd) { true }

      context 'when send_event is true' do
        let(:send_event) { true }
        it 'notifies statsd via event' do
          expect(subject).to receive(:notify_statsd_event).with(notice)
          subject.notify(notice)
        end
      end
      context 'when send_event is false' do
        let(:send_event) { false }
        it 'does not notify statsd via event' do
          expect(subject).to_not receive(:notify_statsd_event).with(notice)
          subject.notify(notice)
        end
      end

      context 'when send_metric is true' do
        let(:send_metric) { true }
        it 'notifies statsd via metric' do
          expect(subject).to receive(:notify_statsd_metric).with(notice)
          subject.notify(notice)
        end
      end
      context 'when send_metric is false' do
        let(:send_metric) { false }
        it 'does not notify statsd via metric' do
          expect(subject).to_not receive(:notify_statsd_metric).with(notice)
          subject.notify(notice)
        end
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
