class HelloController < ApplicationController
  def index
    render json: system_info
  end

  private

  def system_info
    user = `whoami`.strip
    ruby_version = `ruby --version`.strip
    host_name = `scutil --get ComputerName`.strip
    ip = `ifconfig en0 | grep netmask`.split.second
    os = `sw_vers | grep ProductName`.split.last
    version = (`sw_vers | grep ProductVersion`).split.last
    blah

    @system_info ||= {
      status: 'OK',
      system_info: {
        user: user,
        ruby_version: ruby_version,
        host_name: host_name,
        ip: ip,
        os: os,
        version: version
      }
    }

  rescue => e
      { 
        status: 'Failed',
        error: e.message
      }
  end
end
