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
      end
    end
  end
end
