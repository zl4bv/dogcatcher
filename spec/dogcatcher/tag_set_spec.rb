require 'spec_helper'

describe Dogcatcher::TagSet do
  describe '#compile' do
    context 'when set contains a procedure element' do
      subject { described_class.new([proc { 'abc' }]) }

      it 'returns new tag set with procedure element replaced with result of procedure' do
        expect(subject.compile!).to eq(Dogcatcher::TagSet.new(['abc']))
      end
    end
  end
end
