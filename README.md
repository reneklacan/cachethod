# Cachethod

With this Rails plugin you can cache your model methods and speed up
obtaining results. This can be very useful when you are doing some
expensive operations (eg. reading from file or doing some http request)
in your model attributes and you don't need fresh results every time you
invoke the method or results just dont change so frequently.

## About

It wraps Rails.cache.fetch method so it is completely without
configuration and if you change cache configuration of your project it
will be reflected also on Cachethod methods.

## Install

In Gemfile

    gem 'cachethod'

Then run

    bundle install

## Usage

You can choose one of following methods:

    cache_method :method_name, expires_in: 1.minutes
    cachethod :method_name, expires_in: 2.days
    cache_methods [:method1_name, :method2_name], expires_in: 3.weeks
    cachethods [:method2_name, :method2_name], expires_in: 4.months

First argument is name of the method you want to cache and other
arguments are the same that you are used to pass on Rails.cache.fetch
method.

Just put it in your controller:

    class User < ActiveRecord::Base
      cache_method :some_io_method, expires_in: 10.minutes
      
      def some_io_method
        ...
      end
    end

Then invoke cached method multiple times in the usual way and you will
see the difference:

    user.some_io_method
    user.some_io_method
    user.some_io_method

If you want to access uncached version of your method then you can do:

    user.some_io_method!
