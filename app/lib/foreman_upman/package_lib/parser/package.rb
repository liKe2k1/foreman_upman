module ForemanUpman
  module PackageLib
    class Parser
      class Package
        require 'securerandom'

        # @param [String] body
        # @param [String] type Packages Type  ['depends', 'replaces', 'conflicts', 'provides', 'breaks', 'recommends' 'suggests']
        def parse(body, type)
          package_return = nil

          if (package_item_match = body.match(/#{type}: (.*)/i))
            package_item_match[1].split(",").each do |package|
              guid = SecureRandom.uuid
              if (package_match = package.strip.scan(/([a-z.+0-9- ]+)(\:any)?(\(([<>=\-+~:.\w ]+)\))?( ?\|)?/))
                package_match.each do |match|
                  package_return = ::ForemanUpman::Dao::ExtPackage.new
                  package_return.package = match[0].strip
                  package_return.guid = guid
                  package_return.type = type.downcase
                  unless match[3].empty?
                    if (version_mask = match[3].match(/([<>=]+) (.+)/))
                      package_return.version_mask = version_mask[1]
                      package_return.version = version_mask[2]
                    else
                      package_return.version = match[3]
                    end
                  end
                  unless match[4].empty?
                    if match[4].strip == '|'
                      package_return.condition = 'OR'
                    end
                  end

                end
              end
            end
          end
          package_return
        end
      end
    end
  end
end