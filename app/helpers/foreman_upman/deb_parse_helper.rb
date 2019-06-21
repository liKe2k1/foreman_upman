module ForemanUpman
  module DebParseHelper
    delegate :logger, to: ::Rails

    def _inject_tags(package, _tags)
      _tags.each do |_tag|
        tag = Tag.where(label: _tag.label).first_or_create
        unless Package.joins(:tags).where('id' => package.id).exists?
          package.tags << tag
        end
      end
      package
    end

    def _inject_maintainer(package, _maintainer)
      maintainer = Maintainer.where(name: _maintainer.name, email: _maintainer.email).first_or_create
      unless Package.joins(:maintainers).where('id' => package.id).exists?
        package.maintainers << maintainer
      end
      package
    end

    def _parse_release_file(body)
      release_data = _get_hashed_values(body)
      release_data['architectures'] = release_data['architectures'].gsub(/\s+/m, ' ').strip.split(' ')
      var = if release_data['components'].present?
              release_data['components'] = release_data['components'].gsub(/\s+/m, ' ').strip.split(' ')
            end
      var
      release_data['date'] = DateTime.parse(release_data['date'])
      release_data
    end

    def _parse_regex_group(body, regex)
      body.split("\n").each do |line|
        return Regexp.last_match(1) if line =~ regex
      end
      nil
    end

    def _get_hashed_values(body)
      result = {}
      body.scan(/([\w-]+): (.+)/).each do |match|
        key = match[0].downcase.tr('-', '_')
        result[key] = match[1]
      end
      result
    end

    def _get_hashed_values_simple(body)
      result = {}
      body.each_line do |line|
        p line.split(':', 2)
      end
      result
    end

    # Parse something like
    # Maintainer: Debian Games Team <pkg-games-devel@lists.alioth.debian.org>
    def _parse_package_maintainer(body)
      body.split("\n").each do |line|
        if line =~ /^Maintainer: (.*) <(.*)>$/i
          return Maintainer.new(name: Regexp.last_match(1), email: Regexp.last_match(2))
        end
      end
      nil
    end

    # Parse something like
    # Tag: game::strategy, interface::graphical, interface::x11, role::program,
    #  uitoolkit::sdl, uitoolkit::wxwidgets, use::gameplaying,
    #  x11::application
    def _parse_package_tags(body)
      result = []
      body.split("\n").each do |line|
        next unless line =~ /^Tag: ([a-z0-9:,\s\n]+)$/i

        Regexp.last_match(1).strip.split(',').each do |tag|
          result.push(Tag.new(label: tag.strip))
        end
      end
      result
    end
  end
end
