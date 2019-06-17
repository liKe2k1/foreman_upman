module ForemanUpman
  module PackageLib
    class Parser
      class Tag

        # Parse something like
        # Tag: game::strategy, interface::graphical, interface::x11, role::program,
        #  uitoolkit::sdl, uitoolkit::wxwidgets, use::gameplaying,
        #  x11::application
        def parse(body)
          tags = []
          if (match = body.match(/^Tag: ([a-z0-9:,\-\s\n]+)$/i))
            match[1].strip.split(",").each do |tag|
              tags.push(::ForemanUpman::Dao::Tag.new(tag.strip))
            end
          end
          tags
        end
      end

    end
  end
end
