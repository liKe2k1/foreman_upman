class DebianPlugin < PluginBase

  delegate :logger, :to => ::Rails

  def initialize
    @dist_code = 'debian'


    @source_url = 'https://packages.debian.org/source'
    # Download all nessessary information from
    # https://lists.debian.org/debian-security-announce/
    @base_url = 'https://lists.debian.org/debian-security-announce/'
  end

  def fetch_items

    logger.info "[DebianPlugin] fetch_items from #{@base_url}"
    messages = _fetch_from_web(2019)
    logger.info "[DebianPlugin] finished"

    messages.each do |message_url|
      plain_text = get_url_contents(message_url, true)
      _process_message_subject(plain_text)
    end
  end


  private

  def _process_message_reboot(plain_text)
    reboot = false
    if plain_text.include? "to reboot"
      reboot = true
    end
    reboot
  end


  def _process_message_summary(plain_text)
    summary = ''
    header_found = false
    mailing_match = false
    plain_text.each_line do |line|
      if /^.*\s+:\s+.*$/ =~ line
        header_found = true
      end
      if /^Mailing list:/ =~ line
        mailing_match = true
      end
      if mailing_match
        break
      end
      if header_found
        summary += line + '\n'
      end
    end
    if summary == ''
      summary = 'Parsing description failed'
    end
    summary
  end


  def _process_message_cves(plain_text)
    cves = Set.new
    plain_text.each_line do |line|
      if (matches = line.scan(/(CVE-\d{4}-\d+)/))
        matches.each do |cve|
          cves.add(cve)
        end
      end
    end
    cves
  end

  def _process_message_packagelist(name, plain_text)
    dist_packages = Hash.new
    if dists_data = plain_text.scan(/For the ([a-z]+) distribution \(([a-z]+)\).*\n+(.*version\s([0-9+.:\-a-z]+))?(.+)/)
      dists_data.each do |dist|
        dist_code = dist[1]
        if dist[3].nil?
          version = dist[4]
        else
          version = dist[3]
        end
        if dist_packages[dist_code].nil?
          dist_packages[dist_code] = Array.new
        end
        bin_packages = _get_bin_packages(dist_code, name)
        bin_packages.each do |pkg|
          dist_packages[dist_code].push(pkg + "-" + version)
        end
      end
    end
    dist_packages
  end


  def _process_message_subject(plain_text)
    announce = ForemanUpman::Erratum.new
    announce.category = "DSA"

    if /Subject: \[SECURITY\] \[DSA[-\s](\d+)-(\d+)\] (\S+)( (.*))?$/ =~ plain_text
      announce.errata_id = $1
      announce.release = $2
      announce.name = $3
      unless $5
        announce.subject = $3
      else
        announce.subject = $3 + " " + $5
      end
    end
    announce.synopsis = announce.get_advisory_name + " " + announce.subject
    if /Date:\s+(.*?)(?=(\s\(.*\))?$)/ =~ plain_text
      announce.date = $1
    end
    if /From:\s+(.*)$/ =~ plain_text
      announce.from = $1
    end
    announce.dist = ""

    announce.packages = _process_message_packagelist(announce.name, plain_text).to_json
    announce.description = _process_message_summary(plain_text)
    announce.reboot = _process_message_reboot(plain_text)
    announce.errata_type = "Security Advisory"

    announce.save!

    announce
  end

  ##### Helper

  def _get_bin_packages(dist, package)
    packages = []
    source_content = get_url_contents(source_url + "/" + dist + "/" + package)
    if /(<div id="pbinaries">The following binary packages are built from this source.*?<\/div>)/m =~ source_content
      if (matches = source_content.scan(/<dt><a href.*?>(.*?)<\/a><\/dt>/))
        matches.each do |package|
          packages.append package[0]
        end
      end
    end
    packages
  end

  def _fetch_from_web(year)
    messages = nil
    link_list = _fetch_available_year_links(year)
    link_list.each do |data|
      #logger.info "Parsing index page #{base_url}#{data[1]}"
      messages = _fetch_avaiable_messages(data[0], data[1])
    end
    messages
  end


  def _fetch_available_year_links(year)
    result = []
    index_content = get_url_contents(base_url)
    regex = /debian-security-announce-#{year}+\/threads\.html/i
    if (links = index_content.scan(regex))
      links.each do |link|
        result.append [year, link]
      end
    end
    result
  end


  def _fetch_avaiable_messages(year, link)
    result = []
    messages_content = get_url_contents(base_url + link)
    regex = /msg\d{5}\.html/i
    if messages = messages_content.scan(regex)
      messages.each do |message|
        #logger.info "Found Message #{base_url}#{year}/#{message}"
        result.append "#{base_url}#{year}/#{message}"
      end
    end
    return result
  end

end
