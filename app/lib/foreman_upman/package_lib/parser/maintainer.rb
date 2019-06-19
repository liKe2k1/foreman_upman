module ForemanUpman
  module PackageLib
    class Parser
      class Maintainer
        # Parse something like
        # Maintainer: Debian Games Team <pkg-games-devel@lists.alioth.debian.org>
        def parse(body)
          maintainer = nil
          if (match = body.match(/^Maintainer: (.*) <(.*)>$/i))
            maintainer = ::ForemanUpman::Dao::Maintainer.new(match[1], match[2])
          end
          maintainer
        end
      end
    end
  end
end
