module ForemanUpman
  module Package
    class Parser

      def initialize

      end


      def parse_from_text(plain_text)

      end


      def _inject_tags(package, _tags)
        _tags.each do |_tag|
          tag = Tag.where(label: _tag.label).first_or_create
          unless Package.joins(:tags).where('id' => package.id).exists?
            package.tags << tag
          end
        end
        return package
      end

      def _inject_maintainer(package, _maintainer)

        if _maintainer.nil?
          _abort_job(package, "Cannot find Maintainer in Package %s")
        end

        maintainer = Maintainer.where(name: _maintainer.name, email: _maintainer.email).first_or_create
        unless Package.joins(:maintainers).where('id' => package.id).exists?
          package.maintainers << maintainer
        end
        return package
      end

      def _parse_regex_group(body, regex)
        body.split("\n").each do |line|
          if line =~ regex
            return $1
          end
        end
        return nil
      end

      # Parse something like
      # Maintainer: Debian Games Team <pkg-games-devel@lists.alioth.debian.org>
      def _parse_package_maintainer(body)
        body.split("\n").each do |line|
          if line =~ /^Maintainer: (.*) <(.*)>$/i
            return Maintainer.new(name: $1, email: $2)
          end
        end
        return nil
      end

      # Parse something like
      # Tag: game::strategy, interface::graphical, interface::x11, role::program,
      #  uitoolkit::sdl, uitoolkit::wxwidgets, use::gameplaying,
      #  x11::application
      def _parse_package_tags(body)
        result = []
        body.split("\n").each do |line|
          if line =~ /^Tag: ([a-z0-9:,\s\n]+)$/i
            $1.strip.split(",").each do |tag|
              result.push(Tag.new(label: tag.strip))
            end
          end
        end
        return result
      end
    end
  end
end