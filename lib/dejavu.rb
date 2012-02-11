require "dejavu/version"

module Dejavu
  module ViewHelpers
    def has_dejavu?(obj)
      obj_name = ActiveRecord::Base === obj ? obj.class.model_name.underscore : obj.to_s
      !!flash[:"saved_#{obj_name}_for_redisplay"]
    end

    def get_dejavu_for(obj, opts = {})
      is_instance = ActiveRecord::Base === obj
      model_name = is_instance ? obj.class.model_name.underscore : obj.to_s

      if has_dejavu?(obj)
        foo = if is_instance
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
        is_instance ? obj : obj.to_s.classify.constantize.new
      end
    end
  end

  module ControllerMethods
    def save_for_dejavu(obj, opts = {})
      attrs = obj.attributes
      if keys = opts[:nested]
        keys = [keys] unless keys.is_a? Array
        keys.each { |key| attrs = save_nested_for_dejavu(obj, key, attrs) }
      end
      flash[:"saved_#{obj.class.model_name.underscore}_for_redisplay"] = attrs
    end

    private

    def save_nested_for_dejavu(obj, key, attrs)
      value = obj.send(key)

      attrs["#{key}_attributes"] = (value.is_a? Array) ?
        value.map{ |vi| vi.attributes }
        :
        value.attributes

      attrs
    end
  end
end

ActionController::Base.send(:include, Dejavu::ControllerMethods)
ActionView::Base.send(:include, Dejavu::ViewHelpers)
