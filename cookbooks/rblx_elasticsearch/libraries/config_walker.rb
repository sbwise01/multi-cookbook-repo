#
# Chef Documentation
# https://docs.chef.io/libraries.html
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#
module RblxElasticsearch
  module ConfigWalkerHelpers
    #
    # Define the methods that you would like to assist
    # the work you do in recipes,
    # resources, or templates.
    #
    def parse_values(key, val)
      case val
      when Hash
        res = {}
        val.each do |k, v|
          res.merge!(parse_values("#{key}.#{k}", v))
        end
        res
      when Numeric
        { key.to_s => val }
      when String
        { key.to_s => "\"#{val}\"" }
      when TrueClass
        { key.to_s => 'true' }
      when FalseClass
        { key.to_s => 'false' }
      when NilClass
        { key.to_s => '' }
      when Array
        val.map! { |v| "\"#{v}\"" }
        { key.to_s => "[#{val.join(', ')}]" }
      end
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend RblxElasticsearch::ConfigWalkerHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend RblxElasticsearch::ConfigWalkerHelpers
#       variables specific_key: my_helper_method
#     end
#
