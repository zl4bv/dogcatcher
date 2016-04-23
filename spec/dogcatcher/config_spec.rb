require 'spec_helper'

describe Dogcatcher::Config do
  let(:bc) { double('BacktraceCleaner') }

  before do
    subject.backtrace_cleaner = bc
    allow(bc).to receive(:add_filter).and_yield('filterstring')
    allow(bc).to receive(:add_silencer).and_yield('silencerstring')
  end

  describe '#add_filter' do
    it 'adds a filter' do
      expect { |b| subject.add_filter(&b) }.to yield_with_args('filterstring')
    end
  end

  describe '#add_silencer' do
    it 'adds a silencer' do
      expect { |b| subject.add_silencer(&b) }.to yield_with_args('silencerstring')
    end
  end

  describe '#use_dogapi?' do
    context 'when use_dogapi not defined' do
      context 'when an API key is not defined' do
        it 'returns false' do
          expect(subject.use_dogapi?).to be_falsey
        end
      end

      context 'when an API key is defined' do
        before do
          subject.api_key = ''
        end

        it 'returns true' do
          expect(subject.use_dogapi?).to be_truthy
        end
      end
    end

    context 'when use_dogapi is true' do
      before do
        subject.use_dogapi = true
      end

      it 'returns true' do
        expect(subject.use_dogapi?).to be_truthy
      end
    end

    context 'when use_dogapi is false' do
      before do
        subject.use_dogapi = false
      end

      it 'returns false' do
        expect(subject.use_dogapi?).to be_falsey
      end
    end
  end

  describe '#use_statsd?' do
    context 'when use_statsd not defined' do
      context 'when an API key is not defined' do
        it 'returns true' do
          expect(subject.use_statsd?).to be_truthy
        end
      end

      context 'when an API key is defined' do
        before do
          subject.api_key = ''
        end

        it 'returns false' do
          expect(subject.use_statsd?).to be_falsey
        end
      end
    end

    context 'when use_statsd is true' do
      before do
        subject.use_statsd = true
      end

      it 'returns true' do
        expect(subject.use_statsd?).to be_truthy
      end
    end

    context 'when use_statsd is false' do
      before do
        subject.use_statsd = false
      end

      it 'returns false' do
        expect(subject.use_statsd?).to be_falsey
      end
    end
  end
end
