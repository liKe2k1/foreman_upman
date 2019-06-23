module Api
  module V2
    module ForemanUpman
      class BaseController < V2::BaseController
        def find_resource
          instance_variable_set("@#{resource_name}",
                                resource_finder(resource_scope, params[:id]))
        end

        def resource_finder(scope, id)
          raise ActiveRecord::RecordNotFound if scope.empty?

          result = scope.from_param(id) if scope.respond_to?(:from_param)
          begin
            result ||= scope.friendly.find(id) if scope.respond_to?(:friendly)
          rescue ActiveRecord::RecordNotFound
          end
          result || scope.find(id)
        end

        def controller_permission
          controller_name
        end

        def resource_name(resource = controller_name)
          resource.singularize
        end

        def resource_class
          @resource_class ||= resource_class_for(resource_name)
          raise NameError, "Could not find resource class for resource #{resource_name}" if @resource_class.nil?

          @resource_class
        end

        def resource_scope(options = {})
          @resource_scope ||= scope_for(resource_class, options)
        end

        def scope_for(resource, options = {})
          controller = options.delete(:controller) { controller_permission }
          # don't call the #action_permission method here, we are not sure if the resource is authorized at this point
          # calling #action_permission here can cause an exception, in order to avoid this, ensure :authorized beforehand
          permission = options.delete(:permission)

          if resource.respond_to?(:authorized)
            permission ||= "#{action_permission}_#{controller}"
            resource = resource.authorized(permission, resource)
          end

          resource.where(options)
        end

        def resource_class_for(resource)
          klass = "ForemanUpman::#{resource.classify}".constantize
          klass
        rescue NameError
          nil
        end

        def action_permission
          case params[:action]
          when 'installed_packages'
            'installed_packages'
          when 'install_history'
            'install_history'
          else
            super
          end
        end
      end
    end
  end
end
