module ForemanUpman
  module DebParseHelper
    delegate :logger, :to => ::Rails

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
      maintainer = Maintainer.where(name: _maintainer.name, email: _maintainer.email).first_or_create
      unless Package.joins(:maintainers).where('id' => package.id).exists?
        package.maintainers << maintainer
      end
      return package
    end


    def _parse_release_file(body)

      release_dao = ForemanUpman::Dao::Release

      release_data = _get_hashed_values(body)

      release_data['architectures'] = release_data['architectures'].gsub(/\s+/m, ' ').strip.split(" ")
      if release_data['components'].present?
        release_data['components'] = release_data['components'].gsub(/\s+/m, ' ').strip.split(" ")
      end

      release_data['date'] = DateTime.parse(release_data['date'])

      release_data
    end

    def _parse_regex_group(body, regex)
      body.split("\n").each do |line|
        if line =~ regex
          return $1
        end
      end
      return nil
    end


    def _get_hashed_values(body)
      result = {}
      body.scan(/([A-Za-z-]+): (.+)/).each do |match|
        key = match[0].downcase.gsub("-", "_")
        result[key] = match[1]
      end
      result
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

