require "dejavu/version"

module Dejavu
  module ViewHelpers
    def has_dejavu?(obj)
      !!flash[:"saved_#{object_name(obj)}_for_redisplay"]
    end

    def get_dejavu_for(obj, opts = {})
      model_name = object_name(obj)

      if has_dejavu?(obj)
        foo = if is_instance?(obj)
                if Rails::VERSION::MINOR >= 1
                  obj.assign_attributes(flash[:"saved_#{model_name}_for_redisplay"], :without_protection => true)
                else
                  obj.attributes = flash[:"saved_#{model_name}_for_redisplay"]
                end
                obj
              else
                obj.to_s.classify.constantize.new flash[:"saved_#{model_name}_for_redisplay"]
              end
        foo.valid?

        if opts[:exclude_errors_on]
          [opts[:exclude_errors_on]].flatten.each do |attr|
            foo.errors.delete(attr)
          end
        end

        foo
      else
        is_instance?(obj) ? obj : obj.to_s.classify.constantize.new
      end
    end

    def is_instance?(obj)
      ActiveRecord::Base === obj
    end

    def object_name(obj)
      (is_instance?(obj) ? obj.class.model_name : obj).to_s.underscore
    end
  end

  module ControllerMethods
    def save_for_dejavu(obj, opts = {})
      attrs = if opts[:only] && opts[:only].is_a?(Array)
        obj.attributes.slice(*opts[:only].map(&:to_s))
      else
        obj.attributes
      end

      missing_keys = []

      if keys = opts[:nested]
        keys = [keys].flatten
        keys.each { |key| attrs = save_nested_for_dejavu(obj, key, attrs) }
      end

      if virtual = opts[:virtual]
        missing_keys += [virtual].flatten
      end

      missing_keys.each do |key|
        attrs[key] = obj.send(key)
      end

      flash[:"saved_#{object_name(obj)}_for_redisplay"] = attrs
    end

    private

    def save_nested_for_dejavu(obj, key, attrs)
      value = obj.send(key)

      attrs["#{key}_attributes"] = if value.is_a? Array
                                     value.map(&:attributes)
                                   else
                                     value.attributes
                                   end

      attrs
    end
  end
end

ActionController::Base.send(:include, Dejavu::ControllerMethods)
ActionView::Base.send(:include, Dejavu::ViewHelpers)
