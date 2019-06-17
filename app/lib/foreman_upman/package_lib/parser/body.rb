module ForemanUpman
  module PackageLib
    class Parser
      class Body

        attr_accessor :package_dao

        include ForemanUpman::DebParseHelper

        def parse(body_chunk)
          data = _get_hashed_values(body_chunk)
          @package_dao = ::ForemanUpman::Dao::Package.new
          @package_dao.map(data, ['maintainer', 'tag', 'depends', 'replaces', 'conflicts', 'provides', 'breaks', 'recommends' 'suggests'])
          self
        end

        def inject_maintainer(maintainer)
          unless maintainer.nil?
            @package_dao.maintainer = maintainer
          end
        end

        def inject_tag(tag)
          unless tag.nil?
            @package_dao.tag = tag
          end
        end

        def inject_package_replaces(replaces)
          unless replaces.nil?
            @package_dao.replaces = replaces
          end
        end

        def inject_package_depends(depends)
          unless depends.nil?
            @package_dao.depends = depends
          end
        end

        def inject_package_suggests(suggests)
          unless suggests.nil?
            @package_dao.suggests = suggests
          end
        end

        def inject_package_recommends(recommends)
          unless recommends.nil?
            @package_dao.recommends = recommends
          end
        end

        def inject_package_breaks(breaks)
          unless breaks.nil?
            @package_dao.breaks = breaks
          end
        end

        def inject_package_provides(provides)
          unless provides.nil?
            @package_dao.provides = provides
          end
        end

        def inject_package_conflicts(conflicts)
          unless conflicts.nil?
            @package_dao.conflicts = conflicts
          end
        end
      end
    end
  end
end
