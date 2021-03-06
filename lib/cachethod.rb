module Cachethod
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def cache_class_method names, *args
      [*names].each do |name|
        define_singleton_method "#{name}_cached" do
          cache_key = "cachethod.#{self.class.to_s.underscore}.self."
          cache_key += "#{hash}.#{name}."
          cache_key += args.hash.to_s

          Rails.cache.fetch(cache_key, *args) do
            send("#{name}!")
          end
        end

        self.singleton_class.send(:alias_method, "#{name}!", name)
        self.singleton_class.send(:alias_method, name, "#{name}_cached")
      end
    end

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
    alias_method :cache_class_methods, :cache_class_method

    def method_added name
      super
      return if @methods_to_cache.nil? || @methods_to_cache[name].nil?
      args = @methods_to_cache.delete(name)
      cache_method_create(name, *args)
    end

    def cache_method_create name, *args
      define_method "#{name}_cached" do
        cache_key = "cachethod.#{self.class.to_s.underscore}."
        cache_key += "#{hash}.#{name}."
        cache_key += args.hash.to_s

        Rails.cache.fetch(cache_key, *args) do
          send("#{name}!")
        end
      end

      alias_method "#{name}!", name
      alias_method name, "#{name}_cached"
    end
  end
end
