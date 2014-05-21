class ActiveRecord::Base
  class << self
    alias_method :method_added_original, :method_added

    def cache_method name, *args
      @methods_to_cache ||= {}

      if name.is_a?(String) || name.is_a?(Symbol)
        @methods_to_cache[name.to_sym] = args
      elsif method_name.is_a?(Array)
        cache_methods(name, *args)
      else
        raise Exception.new('Invalid first argument for cachethod method!')
      end
    end

    def cache_methods names, *args
      @methods_to_cache ||= {}

      names.each do |name|
        @methods_to_cache[name.to_sym] = args
      end
    end

    alias_method :cachethod, :cache_method
    alias_method :cachethods, :cache_method

    def method_added name
      return if @methods_to_cache.nil? || @methods_to_cache[name].nil?

      args = @methods_to_cache.delete(name)

      define_method "#{name}_cached" do
        Rails.cache.fetch("user#{id}.#{name}", *args) do
          send("#{name}!")
        end
      end

      alias_method "#{name}!", name
      alias_method name, "#{name}_cached"
    end
  end
end
