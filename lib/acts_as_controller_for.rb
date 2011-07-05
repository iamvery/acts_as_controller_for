require 'action_controller'
require 'acts_as_controller_for/base'
require 'acts_as_controller_for/version'

ActionController::Base.class_eval { include ActsAsControllerFor::Base }
