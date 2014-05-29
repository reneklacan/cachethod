module Cachethod
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def cache_method names, *args
      @methods_to_cache ||= {}

      [*names].each do |name|
        if instance_methods.include?(name.to_sym)
          cache_method_create(name, *args)
        else
          @methods_to_cache[name.to_sym] = args
        end
      end
    end

    alias_method :cache_methods, :cache_method
    alias_method :cachethod, :cache_method
    alias_method :cachethods, :cache_method

    def method_added name
      super
      return if @methods_to_cache.nil? || @methods_to_cache[name].nil?
      args = @methods_to_cache.delete(name)
      cache_method_create(name, *args)
    end

    def cache_method_create name, *args
      define_method "#{name}_cached" do
        cache_key = "cachethod.#{self.class.to_s.underscore}-#{id}.#{name}"

        Rails.cache.fetch(cache_key, *args) do
          send("#{name}!")
        end
      end

      alias_method "#{name}!", name
      alias_method name, "#{name}_cached"
    end
  end
end
