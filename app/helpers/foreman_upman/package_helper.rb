module ForemanUpman
  module PackageHelper
    include ForemanUpman::TimingHelper
    include ForemanUpman::CompressionHelper

    delegate :logger, to: ::Rails

    ##
    #  This is my first parser, feel free to optimize or modify :)
    ##
    def sync_package_file(repository, options)
      tmp_file = RepositoryService.fetch_repository_information(repository)

      body = gunzip_file_to_string(tmp_file)
      package_chunks = body.split("\n\n")
      last_package_name = ''

      sync_service = SyncService.new(
        uuid: options[:uuid],
        repository: repository,
        packages_count: package_chunks.size
      )
      i = 0
      package_chunks.each do |chunk|
        elapsed = measure_time do
          package = Package.where(name: _parse_regex_group(chunk, /^Package: (.*)$/i), version: _parse_regex_group(chunk, /^Version: (.*)$/i)).first_or_create
          package.version = _parse_regex_group(chunk, /^Version: (.*)$/i)
          package.installed_size = _parse_regex_group(chunk, /^Installed-Size: ([0-9]+)$/i)
          package.architecture = _parse_regex_group(chunk, /^Architecture: ([a-z0-9]+)$/i)
          package.multi_arch = _parse_regex_group(chunk, /^Multi-Arch: ([a-z]+)$/i)
          package.description = _parse_regex_group(chunk, /^Description: (.*)$/i)
          package.homepage = _parse_regex_group(chunk, /^Homepage: (.*)$/i)
          package.description_md5 = _parse_regex_group(chunk, /^Description-md5: ([a-z0-9]+)$/i)
          package.section = _parse_regex_group(chunk, /^Section: ([a-z]+)$/i)
          package.priority = _parse_regex_group(chunk, /^Priority: ([a-z]+)$/i)
          package.filename = _parse_regex_group(chunk, /^Filename: (.*)$/i)
          package.size = _parse_regex_group(chunk, /^Size: ([0-9]+)$/i)
          package.md5sum = _parse_regex_group(chunk, /^MD5sum: ([a-z0-9]+)$/i)
          package.sha265 = _parse_regex_group(chunk, /^SHA256: ([a-z0-9]+)$/i)
          package.repository = repository

          package = _inject_tags(package, _parse_package_tags(chunk))
          package = _inject_maintainer(package, _parse_package_maintainer(chunk))

          unless package.save
            logger.error "Can not save package #{package.name}"
            package.errors.full_messages.each do |errstr|
              logger.error errstr
            end
          end

          last_package_name = package.name
        end
        i += 1
        sync_service.update(i, last_package_name, elapsed)
      end

      sync_service.finish
    end

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

    def _parse_regex_group(body, regex)
      body.split("\n").each do |line|
        return Regexp.last_match(1) if line =~ regex
      end
      nil
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
