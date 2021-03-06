require 'json'
require 'ostruct'

module Kaigara
  class Metadata

    class DeepHash < Hash
      def method_missing(name, *args, &block)
        if name[-1] == '='
          key = name[0...-1]
          self[key] = args.first
          return self[key]

        elsif !has_key?(name)
          self[name] = DeepHash.new
        end

        return self[name]
      end
    end

    attr_reader :data

    def initialize(&block)
      hash = DeepHash.new
      block.call(hash)
      json = hash.to_json
      @data = JSON.parse(json, object_class: OpenStruct)
    end

    def method_missing(name, *args, &block)
      return @data.send(name)
    end
  end
end
