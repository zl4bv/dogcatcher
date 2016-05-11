require 'spec_helper'

describe Dogcatcher::Markdown do
  describe '#bullet' do
    it 'returns a datadog markdown string with a bullet' do
      subject.bullet('foo')
      expect(subject.result).to eq("%%%\n* foo\n\n%%%")
    end
  end

  describe '#code_block' do
    context 'when language is not provided' do
      it 'returns a datadog markdown string with a code block' do
        subject.code_block('foo')
        expect(subject.result).to eq("%%%\n```\nfoo\n```\n\n%%%")
      end
    end

    context 'when language is provided' do
      it 'returns a datadog markdown string with a code block' do
        subject.code_block('foo', 'bar')
        expect(subject.result).to eq("%%%\n```bar\nfoo\n```\n\n%%%")
      end
    end

    context 'when max length not given' do
      it 'does not truncate the string' do
        subject.code_block('foobar')
        expect(subject.result).to match(/foobar/)
      end
    end

    context 'when max length is a negative number' do
      it 'does not truncate the string' do
        subject.code_block('foobar', nil, -123)
        expect(subject.result).to match(/foobar/)
      end
    end

    context 'when max length is a positive number' do
      context 'when str is less than max length' do
        it 'returns the whole string' do
          subject.code_block('foobar', nil, 100)
          expect(subject.result).to match(/foobar/)
        end
      end

      context 'when str is greater than max length' do
        it 'truncates the string' do
          subject.code_block('foobar', nil, 12)
          expect(subject.result).to match(/foo\n/)
        end
      end
    end
  end

  describe '#result' do
    it 'returns an empty datadog markdown string' do
      expect(subject.result).to eq("%%%\n\n%%%")
    end
  end
end
