# Cachethod

With this Rails plugin you can **cache** your **model methods** and speed up
obtaining results. This can be very useful when you are doing some
expensive operations (eg. reading from file or doing some http request)
in your model methods and you don't need fresh results every time you
invoke the method or results just don't change so frequently.

**Works out of box with Rails 3 and Rails 4.**

## About

It wraps Rails.cache.fetch method so it is completely without
configuration and if you change cache configuration of your project it
will be reflected also on Cachethod methods.

## Install

In Gemfile

```ruby
gem 'cachethod', '~> 0.2.0'
```

Then run

```
bundle install
```

## Usage

First step is including **Cachethod** module to your class.

```ruby
class User < ActiveRecord::Base
  include Cachethod

  ...
end
```

Next you can choose one of following methods:

```ruby
cache_method :method_name, expires_in: 1.minutes
cachethod :method_name, expires_in: 2.days
cache_methods [:method1_name, :method2_name], expires_in: 3.weeks
cachethods [:method2_name, :method2_name], expires_in: 4.months
```

First argument is name of the method you want to cache and other
arguments are the same that you are used to pass on Rails.cache.fetch
method.

Just put it in your controller:

```ruby
class User < ActiveRecord::Base
  include Cachethod

  cache_method :some_io_method, expires_in: 10.minutes

  def some_io_method arg1
    ...
  end
end
```

Then invoke cached method multiple times in the usual way and you will
see the difference:

```ruby
user.some_io_method(2) # this will take a long time
user.some_io_method(2) # you get cached result instantly
user.some_io_method(3) # this will take a long time again
user.some_io_method(3) # you get cached result instantly
user.some_io_method(2) # you get cached result instantly
```

Note that Cachethod takes method arguments into the account and when you change
arguments it will need to cache method result also.

If you want to access uncached version of your method then you can do:

```ruby
user.some_io_method!
```

## Caching class methods

```ruby
class Apple < ActiveRecord::Base
  include Cachethod

  class << self
    def kinds
      ...
    end
  end

  cache_class_method :kinds, expires_in: 10.minutes
end
```

## Result

For example it translates following code:

```ruby
class Stormtrooper
  include Cachethod

  cache_methods [:some_io_method, :another_io_method], expires_in: 10.minutes

  def some_io_method
    ...
  end

  def another_io_method
    ...
  end
end
```

into the equivalent of:

```ruby
class Stormtrooper < ActiveRecord::Base
  def some_io_method *args
    Rails.cache.fetch(:some_key, expires_in: 10.minutes) do
      ...
    end
  end

  def another_io_method *args
    Rails.cache.fetch(:another_key, expires_in: 10.minutes) do
      ...
    end
  end
end
```

## License

This library is distributed under the Beerware license.
