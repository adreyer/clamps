
module Puppet::Parser::Functions
  newfunction(:int_range, :type => :rvalue) do |args|
    max = args.first.to_i
    (1..max).to_a
  end
end
