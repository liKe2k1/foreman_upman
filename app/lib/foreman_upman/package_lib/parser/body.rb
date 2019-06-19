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
          @package_dao.maintainer = maintainer unless maintainer.nil?
        end

        def inject_tag(tag)
          @package_dao.tag = tag unless tag.nil?
        end

        def inject_package_replaces(replaces)
          @package_dao.replaces = replaces unless replaces.nil?
        end

        def inject_package_depends(depends)
          @package_dao.depends = depends unless depends.nil?
        end

        def inject_package_suggests(suggests)
          @package_dao.suggests = suggests unless suggests.nil?
        end

        def inject_package_recommends(recommends)
          @package_dao.recommends = recommends unless recommends.nil?
        end

        def inject_package_breaks(breaks)
          @package_dao.breaks = breaks unless breaks.nil?
        end

        def inject_package_provides(provides)
          @package_dao.provides = provides unless provides.nil?
        end

        def inject_package_conflicts(conflicts)
          @package_dao.conflicts = conflicts unless conflicts.nil?
        end
      end
    end
  end
end
