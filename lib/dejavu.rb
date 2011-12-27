require "dejavu/version"

module Dejavu
  module ViewHelpers
    def has_dejavu?(obj)
      obj_name = ActiveRecord::Base === obj ? obj.class.model_name.underscore : obj.to_s
      !!flash[:"saved_#{obj_name}_for_redisplay"]
    end

    def get_dejavu_for(obj)
      is_instance = ActiveRecord::Base === obj
      model_name = is_instance ? obj.class.model_name.underscore : obj.to_s

      if has_dejavu?(obj)
        foo = if is_instance
                obj.attributes = flash[:"saved_#{model_name}_for_redisplay"]
                obj
              else
                obj.to_s.classify.constantize.new flash[:"saved_#{model_name}_for_redisplay"]
              end
        foo.valid?
        foo
      else
        is_instance ? obj : obj.to_s.classify.constantize.new
      end
    end
  end

  module ControllerMethods
    def save_for_dejavu(obj)
      flash[:"saved_#{obj.class.model_name.underscore}_for_redisplay"] = obj.attributes
    end
  end
end

ActionController::Base.send(:include, Dejavu::ControllerMethods)
ActionView::Base.send(:include, Dejavu::ViewHelpers)
