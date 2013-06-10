# encoding: utf-8
require 'range/bisect/version'

module Range::Bisect
  # Extends Range::Bisect into a duplicate of integer_range,
  # then calls #bisect.
  #
  # @param integer_range [Range<Integer>]
  # @yieldparam [Range<Integer>]
  # @yieldreturn [Boolean]
  def self.bisect(integer_range, &block)
    source = integer_range.dup
    source.extend(self) unless source.kind_of?(Range::Bisect)
    source.bisect(&block)
  end

  # By bisection, find all of the elements in this range
  # that cause the block to return true. It is especially
  # important to note that the given block must operate with
  # the whole range, not simply its beginning or end.
  #
  # @yieldparam [Range<Integer>]
  # @yieldreturn [Boolean]
  def bisect(&block)
    ensure_integer_range!

    return [] unless yield(self)

    if first(2).size == 1 # determine if single-element without #to_a
      return [first]
    else
      bisection.map do |range|
        Range::Bisect.bisect(range, &block)
      end.flatten.sort
    end
  end

  private

  # Ensure that self is a [Range<Integer>]
  # @raise [ArgumentError] if self is not [Range<Integer>].
  def ensure_integer_range!
    unless self.kind_of?(Range) &&
           self.first.kind_of?(Integer) &&
           self.last.kind_of?(Integer)
      raise ArgumentError, "Not a Range<Integer>: #{self}"
    end
  end

  # splits self in two
  # @return [Array<Range<Integer>>]
  def bisection
    size = self.end - self.begin
    midpoint = self.begin + (size / 2)

    first_half = Range.new(self.begin, midpoint, false)
    last_half = Range.new(midpoint.next, self.end, exclude_end?)

    [first_half, last_half]
  end
end
