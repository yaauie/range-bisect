# Range::Bisect

Given a `Range` of `Integer`s, find by bisection the Integers who satisfy
a given block.

## Installation

Add this line to your application's Gemfile:

    gem 'range-bisect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install range-bisect

## Usage

Usage is best-served by an example.

Suppose a limited external service allows you to specify a range of integers,
and will tell you whether or not that range contains one or more things that
you are looking for.

```ruby
# Here is a haystack implementation.
# We can only use its interface.
class Haystack
  # @param range [Range<Integer>]
  # @return [Boolean]
  def has_needles?(range)
    # ...
  end
end

# suppose we have an instance of that, called haystack
haystack # => <Haystack:0x007fb3721013c8>
# and we know that somewhere between 0 and 100, 
# it includes one or more needles
haystack.has_needles?(0...100) #=> true

# but we can only know whether or not a range has needles,
# not how many there are or where they are.
haystack.has_needle?(0...1) #=> false
haystack.has_needle?(1...2) #=> false
haystack.has_needle?(2...3) #=> false
haystack.has_needle?(3...4) #=> false
 # ...
haystack.has_needle?(99...100) #=> true

# Let's try the same thing with iteration
query_count = 0
(0...100).to_a.select do |idx|
  query_count += 1
  haystack.has_needle?(idx...idx.next)
end
# => [17, 47, 99]
query_count #=> 100

# Note that we still had to query every single item.
# Imagine a haystack with a billion items; whether
# it has one or a billion needles, you must query it
# a billion times.

# Bisect improves the best-case scenario using a 
# divide-and-conquer method. It splits the search range
# recursively, continuing to search into sub-ranges that
# return true for the given block.
search_range = 0...100
query_count = 0
search_range.extend(Range::Bisect)
search_range.bisect do |sub_range|
  query_count += 1
  haystack.has_needle?(sub_range)
end
# => [17, 47, 99]
query_count #=> 35
```

Worth noting is that Bisect is actualy *less* efficient at
the worst-case scenario.

As the number of needles (`n`)
in the haystack (size `h`) approaches `h`, the total number
of times the block is executed approaches `2 * h`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
