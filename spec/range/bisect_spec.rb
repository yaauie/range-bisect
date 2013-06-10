# encoding: utf-8

require 'range/bisect'

describe Range::Bisect do
  let(:needles) { [1, 3, 9, 5, 11] }
  let(:needle_finder) do
    proc { |haystack| haystack.any? { |elem| needles.include?(elem) } }
  end
  let(:haystack) do
    (1...12)
  end
  subject { Range::Bisect.bisect(haystack, &needle_finder) }

  it { should == needles.sort }
end
