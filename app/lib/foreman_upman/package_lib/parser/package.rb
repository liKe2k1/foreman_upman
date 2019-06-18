module ForemanUpman
  module PackageLib
    class Parser
      class Package
        require 'securerandom'

        # @param [String] body
        # @param [String] type Packages Type  ['depends', 'replaces', 'conflicts', 'provides', 'breaks', 'recommends' 'suggests']
        def parse(body, type)

          packages = []
          if (package_item_match = body.match(/#{type}: (.*)/i))
            package_item_match[1].split(",").each do |package|
              guid = SecureRandom.uuid
              if (package_match = package.strip.scan(/([a-z.+0-9- ]+)(\:any)?(\(([<>=\-+~:.\w ]+)\))?( ?\|)?/))
                package_match.each do |match|
                  package_item = ::ForemanUpman::Dao::ExtPackage.new
                  package_item.package = match[0].strip
                  package_item.guid = guid
                  package_item.type = type.downcase
                  unless match[3].empty?
                    if (version_mask = match[3].match(/([<>=]+) (.+)/))
                      package_item.version_mask = version_mask[1]
                      package_item.version = version_mask[2]
                    else
                      package_item.version = match[3]
                    end
                  end
                  unless match[4].empty?
                    if match[4].strip == '|'
                      package_item.condition = 'OR'
                    end
                  end
                  packages.append package_item

                end
              end
            end
          end
          packages
        end
      end
    end
  end
end